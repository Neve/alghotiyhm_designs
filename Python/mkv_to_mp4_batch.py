# /usr/bin/python3
# -*- coding: utf-8 -*-
import glob
import sys
import os
from os import path
import subprocess
import re
import threading
# from threading import Thread
# import random
import time

# User deffined path where mkvs reside
if len(sys.argv) == 1:
  print("No path given as arument, will try to search in current directory")
  path_to_convert = path.dirname(__file__)
else:
  path_to_convert = sys.argv[1]
  
# User could pass either single file or directory
# Checking that the path exists and it is directory
if path.exists(path_to_convert): 
  if path.isdir(path_to_convert):
    print('We will convert mkv->mp4 in:', path_to_convert)
  else:
    print("We will convert %s->mp4" % path_to_convert)
else:
  print(path_to_convert,'Either do not exist or we have no permissions there')

# Method for mkv_movies list which holds the movies to convert
# path_to_convert - system path to directory or single file
# returns mkv_movies - list with movies to convert
def get_movie_list(path_to_convert):
  # A List w mkv movies found in given directory
  mkv_movies = []
  # Human readable without escapes for console output
  mkv_movies_human = []
  # if single file is given
  if path_to_convert.endswith(".mkv"):
    mkv_movies.append(re.escape(path_to_convert))
    mkv_movies_human.append(path_to_convert)
    return mkv_movies
  # if path is directory
  else:
    for root, files in os.walk(path_to_convert):
      for file in files:
        if file.endswith(".mkv"):
          # Full path to mkv
          mkv_full_path = os.path.join(root, file)

          # this one is only for human readable console output
          mkv_movies_human.append(mkv_full_path)

          # Escaping:  /Volumes/Films/Star wars/Star\ Wars\ Episode\ I\ \-\ The\ Phantom\ Menace\ \(1999\)\ 720p\.mkv 
          # r=root, d=directories, f = files
          # re.escape - escape whitespaces and bracketsin names
          mkv_full_path_esc = re.escape(mkv_full_path)

          # appending to main list
          mkv_movies.append(mkv_full_path_esc)

    return mkv_movies

  print("Script will convert following movies :\n", mkv_movies_human)

# Get user confirm on the list of converted movies
def get_user_grant_to_run():
  n = 'n'
  y = 'y'
  user_input = input(f"Please confirm ({y}/{n}) [{y}]: ")
  
  if user_input.lower() == y or not user_input:
    print("  Ready to start in threads ... \n\n")
  elif user_input.lower() == n:
    print('  Aborting ...')
    exit()
  else:
    print("Wrong argument. Please enter 'y' or 'n'. Exit. Try again please")
    exit()

# Autodecting subtitle type for given mkv movie
# running: ffmpeg -i /path_to_the_.mkv 
# looking for "" Subtitle: subrip" markers in output, 
# if we have found any  - using move_text instead of copy
def detect_srt_subrip_subtitles(mkv_path):
  movie_data = subprocess.getoutput(f"ffprobe {mkv_path}")

  if (movie_data.find('subrip') != -1): 
    print (f"  INFO: {mkv_path} \n    CONTAINS subrip SUBTITLES TYPE 'move_text' or 'A' option recomeded") 
    return True
  else: 
    print ("  MKV file Doesn't contain'subrip' subtitles, 'copy' or 'A' option could be used") 
    return False


# This method intended to resolve subtitle problem, 
# ffmpeg could just copy subs - as is: -c:s copy
#              or move it: -c:s move_text
# sometimes move_text do not work properly, in this case its better to use 'copy'
# lets ask user and put right value into ffmpeg run cmd
def ask_user_about_sub_convert_type():
  copy = 'copy'
  mov_text = 'mov_text'
  auto_detect = 'auto'
  msg = """ffmpeg could just copy subs - as is: '-c:s copy' or move it: '-c:s move_text'.
  Sometimes because of unsupported (subrip) srt 'copy' method do not work properly (Fail with: 'codec frame size is not set'),
   in this case its better to use move_text which is slover and sometimes brakes subs names
   Enter:
    1 - for copy
    2 - for move_text
    a - converter will detect if tere is (subrip) subs and use 'move_text' for affected movies
    """ 

  print(msg)
  user_input = input(f"Please confirm (1 - {copy} / 2- {mov_text} / a - {auto_detect}) [a]: ")

  if user_input == '2':
    return mov_text
  elif user_input == '1':
    return copy
  elif user_input == 'a' or not user_input:
    return auto_detect
  else:
    print("Wrong input. Enter 1 or 2 or 'a' ")
    exit()

# Renaming .mkv to .mp4
# mkv_movie_path - string with a path to mkv movie
# return : string with a path to mp4 movie
def rename_mkv_file_to_mp4(mkv_movie_path):
  mp4 = os.path.splitext(mkv_movie_path)[0]+".mp4"
  print(f"  mp4 file full path: {mp4}")
  return mp4


# Actual ffmpeg convert sequence
# mkv_movie_path - string with a path to mkv movie
# return : null (executes ffmpeg cmd)
def ffmpeg_convert_to_mp4( mkv_movie_path, c_s_sub_convert_type ):
  if mkv_movie_path == '':
    print("  Movie path is empty! exit!")
    exit()
  
  mp4_full_path = rename_mkv_file_to_mp4(mkv_movie_path)
  # Autodetecting srt presense if auto_detect option given
  if c_s_sub_convert_type == 'auto':
    if detect_srt_subrip_subtitles(mkv_movie_path):
      sub_convert_type = 'move_text'
    else:
      sub_convert_type = 'copy'
  else:
    sub_convert_type = c_s_sub_convert_type
  
  cmd_options = [
    'ffmpeg -i ', 
    mkv_movie_path, 
    ' -map 0 -c copy -c:s ', 
    sub_convert_type, 
    ' -metadata:s:s:0 language=eng -metadata:s:s:1 language=ipk ', 
    mp4_full_path
  ]
  cmd = ''.join(cmd_options)
  print("  _______ Executing: _____  \n", cmd)

  start_time = time.process_time()

  #os.system(cmd) 
  subprocess.getoutput(cmd)
  
  elapsed_time = time.process_time() - start_time 
  print("  Conversion time:", elapsed_time)

 
 # Initializing threads, 
 # Curren approach 1 thread per movie, which could hurt you cpu ))
class ConverterThread(Thread):
    def __init__(self, name, sub_convert_type):
        # Thread init
        Thread.__init__(self)
        self.name = name
        self.convert_type = sub_convert_type
    
    def run(self):
        # thread start
        #amount = random.randint(3, 15)
        #time.sleep(amount)
        
        # Get lock to synchronize threads
        # threadLock.acquire()
        print("!! Thread for %s is running !!" % self.name)
        ffmpeg_convert_to_mp4(self.name, self.convert_type)
        # Free lock to release next thread
        # threadLock.release()

threadLock = threading.Lock()
threads = []

  # Creating a number of threads equal to number of movies found
def convert_with_threads(mkv_movies, user_subtitle_convert_type):
  for mkv_movie in mkv_movies:
      converter_thread = ConverterThread(mkv_movie, user_subtitle_convert_type)
      converter_thread.start()
      threads.append(converter_thread)

mkv_movie_list = get_movie_list(path_to_convert)
get_user_grant_to_run()
user_subtitle_convert_type = ask_user_about_sub_convert_type()


convert_with_threads(mkv_movie_list, user_subtitle_convert_type) 
