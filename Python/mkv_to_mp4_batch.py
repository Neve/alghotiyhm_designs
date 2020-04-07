# /usr/bin/python3
# -*- coding: utf-8 -*-
import glob
import sys
import os
from os import path
import re
import threading
from threading import Thread
# import random
import time

# User deffined path where mkvs reside
if len(sys.argv) == 1:
  print("No path given as arument, will try to search in current directory")
  path_to_convert = path.dirname(__file__)
else:
  path_to_convert = sys.argv[1]
  
# Checking that the path exists and it is directory
if (path.exists(path_to_convert) and path.isdir(path_to_convert)):
  print('We will convert mkv->mp4 in:', str(path_to_convert))
else:
  print(path_to_convert,'Either do not exist or we have no permissions there')



# A List w mkv movies found in given directory
mkv_movies = []
# Human readable without escapes
mkv_movies_human = []

for root, directories, files in os.walk(path_to_convert):
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

print("Script will convert following movies :\n", mkv_movies_human)

# Get user confirm on the list of converted movies
def get_user_grant_to_run():
  n = 'n'
  y = "y"
  user_input = input("Please confirm (%s/%s) [%s]: " % (y,n,y))
  
  if user_input.lower() == y or not user_input:
    print("Ready to start in threads ... \n\n")
  elif user_input.lower() == n:
    print('Aborting ...')
    exit()
  else:
    print("Wrong argument. Please enter 'y' or 'n'. Exit. Try again please")
    exit()

# This method intended to resolve subtitle problem, 
# ffmpeg could just copy subs - as is: -c:s copy
#              or move it: -c:s move_text
# sometimes move_text do not work properly, in this case its better to use 'copy'
# lets ask user and put right value into ffmpeg run cmd
def ask_user_about_sub_convert_type():
  copy = 'copy'
  mov_text = 'mov_text'
  msg = """ffmpeg could just copy subs - as is: '-c:s copy' or move it: '-c:s move_text'.
  Sometimes move_text do not work properly (Fail with: 'codec frame size is not set'),
   in this case its better to use copy
   Enter:
    1 - for copy
    2 - for move_text
    A 'copy' will be default one
    """ 

  print(msg)
  user_input = input("Please confirm (1 - %s / 2- %s) [1]: " % (copy, mov_text))

  if user_input == '2':
    return mov_text
  elif user_input == '1' or not user_input:
    return copy
  else:
    print("Wrong input. Enter 1 or 2")
    exit()

# Renaming .mkv to .mp4
# mkv_movie_path - string with a path to mkv movie
# return : string with a path to mp4 movie
def rename_mkv_file_to_mp4(mkv_movie_path):
  mp4 = os.path.splitext(mkv_movie_path)[0]+".mp4"
  print('  mp4 file full path:', mp4)
  return mp4


# Actual ffmpeg convert sequence
# mkv_movie_path - string with a path to mkv movie
# return : null (executes ffmpeg cmd)
def ffmpeg_convert_to_mp4( mkv_movie_path, c_s_sub_convert_type ):
  if mkv_movie_path == '':
    print("Movie path is empty! exit!")
    exit()
  
  mp4_full_path = rename_mkv_file_to_mp4(mkv_movie_path)
  
  # -c:s mov_text - possible option suggested, but using just copy works better on old mkv files
  
  cmd_options = [
    'ffmpeg -i ', 
    mkv_movie_path, 
    ' -map 0 -c copy -c:s ', 
    c_s_sub_convert_type, 
    ' -metadata:s:s:0 language=eng -metadata:s:s:1 language=ipk ', 
    mp4_full_path
  ]
  cmd = ''.join(cmd_options)
  print("  _______ Executing: _____  \n", cmd)
  os.system(cmd) 

 
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
        msg = "!! Thread for %s is running !!" % self.name
        print(msg)
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

get_user_grant_to_run()
user_subtitle_convert_type = ask_user_about_sub_convert_type()

start_time = time.process_time()
convert_with_threads(mkv_movies, user_subtitle_convert_type) 
elapsed_time = time.process_time() - start_time 
print("Conversion time:", elapsed_time)