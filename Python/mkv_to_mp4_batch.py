#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import glob
import sys
import os
from os import path
import subprocess
import threading
from threading import Thread
import concurrent.futures
import time

# Detecting if user provided us with path to a dir 
# or to the specific file or just running in directory with movies
def get_movie_path(invocation_arguments):
  # User deffined path where mkvs reside
  if len(invocation_arguments) == 1:
    print("  WARNING: No path given as arument! will try to search in current directory")
    path_to_convert = path.dirname(__file__)
  else:
    path_to_convert = invocation_arguments[1]
    
  # User could pass either single file or directory
  # Checking that the path exists and it is directory
  if path.exists(path_to_convert): 
    if path.isdir(path_to_convert):
      print(f"  INFO: We will convert mkv->mp4 in: {path_to_convert}")
    else:
      print(f"  INFO: We will convert {path_to_convert}->mp4")
  else:
    print(f"  FATAL: {path_to_convert} Either do not exist or we have no permissions there")
    exit()
  return path_to_convert

# Method for mkv_movies list which holds the movies to convert
# path_to_convert - system path to directory or single file
# returns mkv_movies - list with movies to convert
def get_movie_list(path_to_convert):
  # A List w mkv movies found in given directory
  mkv_movies = []
  # if single file is given
  if path_to_convert.endswith(".mkv") or path_to_convert.endswith(".avi"):
    mkv_movies.append(path_to_convert)

  # if path is directory
  else:
    for root, directories, files in os.walk(path_to_convert):
      directories

      for file in files:
        if file.endswith(".mkv") or file.endswith(".avi
          # Full path to mkv
          mkv_full_path = os.path.join(root, file)
          # appending to main list
          mkv_movies.append(mkv_full_path)

  print(f"  INFO: Script will convert following movies :\n {mkv_movies}")
  return mkv_movies


# Get user confirm on the list of converted movies
def get_user_grant_to_run():
  n = 'n'
  y = 'y'
  user_input = input(f"  Please confirm ({y}/{n}) [{y}]: ")
  
  if user_input.lower() == y or not user_input:
    print("  INFO: Confirmed. Ready to start...")
  elif user_input.lower() == n:
    print('  FATAL: Aborting ...')
    exit()
  else:
    print("  ERROR: Wrong argument. Please enter 'y' or 'n'. Exit. Try again please")
    exit()


# This method intended to resolve subtitle problem, 
# ffmpeg could just copy subs - as is: -c:s copy
#              or move it: -c:s move_text
# sometimes move_text do not work properly, in this case its better to use 'copy'
# lets ask user and put right value into ffmpeg run cmd
def ask_user_about_sub_convert_type():
  copy = 'copy'
  mov_text = 'mov_text'
  auto_detect = 'auto'
  msg = """  INFO: ffmpeg could just copy subs - as is: '-c:s copy' or move it: '-c:s move_text'.
    Sometimes because of unsupported (subrip) subtitles type in mkv container, 'copy' method may do not work properly  - (Fail with: 'codec frame size is not set'),
    In this case its better to use 'move_text' which is slover and sometimes brakes subs names
    Enter:
      1 - for copy
      2 - for mov_text
      a - converter will detect if tere is (subrip) subs and use 'move_text' for affected movies
    """ 

  print(msg)
  user_input = input(f"  Please confirm (1 - {copy} / 2- {mov_text} / a - {auto_detect}) [a]: ")

  if user_input == '2':
    return mov_text
  elif user_input == '1':
    return copy
  elif user_input == 'a' or not user_input:
    return auto_detect
  else:
    print("  ERROR: Wrong input. Please enter 1 or 2 or 'a' ")
    exit()

# Renaming .mkv to .mp4
# mkv_movie_path - string with a path to mkv movie
# return : string with a path to mp4 movie
def rename_mkv_file_to_mp4(mkv_movie_path):
  mp4 = os.path.splitext(mkv_movie_path)[0]+".mp4"
  # print(f"  DEBUG: The mp4 file full path:\n    {mp4}")
  return mp4

# method to delete zero sized mp4 
# files from previous unsucessful attempts
def delete_zero_sized_mp4_present(mp4_movie_path):
   if path.exists(mp4_movie_path) and path.getsize(mp4_movie_path) == 0:
     print(f"  WARNING: we have found empty {mp4_movie_path} file. \n  WARNING: Removing before conversion.")
     os.remove(mp4_movie_path)

# Autodecting subtitle type for given mkv movie
# running: ffmpeg -i /path_to_the_.mkv 
# looking for "" Subtitle: subrip" markers in output, 
# if we have found any  - using move_text instead of copy
def detect_srt_subrip_subtitles(ffmpeg_bin_path, mkv_path, thread_counter):
  mkv_path = f"\"{mkv_path}\""
  movie_data = subprocess.getoutput(f"{ffmpeg_bin_path}ffprobe {mkv_path} ")
  print(f"  Thread {thread_counter} INFO:  RUNNING {ffmpeg_bin_path}ffprobe {mkv_path} ") 
  # print (f"  DEEBUG: {movie_data} \n ") 
  if (movie_data.find('subrip') != -1): 
    print(f"  Thread {thread_counter} ATTENTION:\n    {mkv_path} \n    'subrip' subtitles type detected! 'mov_text' option will be used") 
    return True
  else: 
    print(f"  Thread {thread_counter} INFO:\n    {mkv_path} \n    NOTE: Doesn't contain 'subrip' subtitles, 'copy' option will be used") 
    return False



# Actual ffmpeg convert sequence
# mkv_movie_path - string with a path to mkv movie
# return : null (executes ffmpeg cmd)
def ffmpeg_convert_to_mp4(ffmpeg_bin_path, mkv_movie_path, c_s_sub_convert_type, mp4_full_path, thread_counter = 0):
  if mkv_movie_path == '':
    print(f"  Thread {thread_counter} INFO: Movie path is empty! exit!")
    exit()

  print(f"  Thread {thread_counter} INFO: for {mkv_movie_path} is starting")

  # Autodetecting srt presense if auto_detect option given
  if c_s_sub_convert_type == 'auto':
    if detect_srt_subrip_subtitles(ffmpeg_bin_path, mkv_movie_path, thread_counter):
      sub_convert_type = 'mov_text'
    else:
      sub_convert_type = 'copy'
  else:
    sub_convert_type = c_s_sub_convert_type


  cmd_options = [
    f"{ffmpeg_bin_path}ffmpeg -i ", 
    f"\"{mkv_movie_path}\"", 
    ' -map 0 -c copy -c:s ', 
    sub_convert_type, 
   # ' -metadata:s:s:0 language=eng -metadata:s:s:1 language=ipk ', 
    ' ', 
    f"\"{mp4_full_path}\""
  ]
  cmd = ''.join(cmd_options)
  print(f"  Thread {thread_counter} INFO: Executing: \n    {cmd} \n\n")

  

  movie_data = subprocess.getoutput(cmd)
  print(f"  Thread {thread_counter} INFO: Output: \n {movie_data} \n")
  

 
 # Initializing threads, 
def convert_with_threads(ffmpeg_bin_path, mkv_movies, user_subtitle_convert_type):
  thread_count = 0

  # Current approach 1 thread per movie, which could hurt you cpu ))
  # Creating a number of threads equal to number of movies found
  mkv_number = int(mkv_movies.count)
  with concurrent.futures.ThreadPoolExecutor(max_workers = mkv_number) as executor:
    for mkv_movie in mkv_movies:
      mp4_movie_name = rename_mkv_file_to_mp4(mkv_movie)
      delete_zero_sized_mp4_present(mp4_movie_name)
      executor.submit(ffmpeg_convert_to_mp4, ffmpeg_bin_path, mkv_movie, user_subtitle_convert_type, mp4_movie_name, thread_count)
      thread_count+=1

  # threads = list()
  # for mkv_movie in mkv_movies:
  #   mp4_movie_name = rename_mkv_file_to_mp4(mkv_movie)
  #   delete_zero_sized_mp4_present(mp4_movie_name)
  #   converter_thread = threading.Thread(target=ffmpeg_convert_to_mp4, args=(mkv_movie, user_subtitle_convert_type, mp4_movie_name))
  #   #, daemon=True
  #   threads.append(converter_thread)
  #   converter_thread.start()


# main part 
def main():
  ffmpeg_bin_path = "/usr/local/bin/"
  path_to_convert = get_movie_path(sys.argv)
  mkv_movie_list = get_movie_list(path_to_convert)
  get_user_grant_to_run()
  user_subtitle_convert_type = ask_user_about_sub_convert_type()

  start_time = time.process_time()
  convert_with_threads(ffmpeg_bin_path, ffmpeg_bin_path, mkv_movie_list, user_subtitle_convert_type) 
  elapsed_time = time.process_time() - start_time 
  print(f"  INFO: Conversion time: {elapsed_time}")


if __name__ == '__main__':
    main()