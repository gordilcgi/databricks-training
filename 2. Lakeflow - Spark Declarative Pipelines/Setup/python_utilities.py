# Databricks notebook source
# DBTITLE 1,Copy Files
def copy_files(copy_from: str, copy_to: str, n: int, sleep=2):
    '''
    Copy files from one location to another destination's volume.

    This method performs the following tasks:
      1. Lists files in the source directory and sorts them. Sorted to keep them in the same order when copying for consistency.
      2. Verifies that the source directory has at least `n` files.
      3. Copies files from the source to the destination, skipping files already present at the destination.
      4. Pauses for `sleep` seconds after copying each file.
      5. Stops after copying `n` files or if all files are processed.
      6. Will print information on the files copied.
    
    Parameters
    - copy_from (str): The source directory where files are to be copied from.
    - copy_to (str): The destination directory where files will be copied to.
    - n (int): The number of files to copy from the source. If n is larger than total files, an error is returned.
    - sleep (int, optional): The number of seconds to pause after copying each file. Default is 2 seconds.

    Returns:
    - None: Prints information to the log on what files it's loading. If the file exists, it skips that file.

    Example:
    - copy_files(copy_from='/Volumes/gym_data/v01/user-reg', 
           copy_to=f'{DA.paths.working_dir}/pii/stream_source/user_reg',
           n=1)
    '''
    import os
    import time

    print(f"\n----------------Loading files to user's volume: '{copy_to}'----------------")

    ## List all files in the copy_from volume and sort the list
    list_of_files_to_copy = sorted(os.listdir(copy_from))
    total_files_in_copy_location = len(list_of_files_to_copy)

    ## Get a list of files in the source
    list_of_files_in_source = os.listdir(copy_to)

    assert total_files_in_copy_location >= n, f"The source location contains only {total_files_in_copy_location} files, but you specified {n}  files to copy. Please specify a number less than or equal to the total number of files available."

    ## Looping counter
    counter = 1

    ## Load files if not found in the co
    for file in list_of_files_to_copy:
      if file.startswith('_'):
        pass
      else:
        ## If the file is found in the source, skip it with a note. Otherwise, copy file.
        if file in list_of_files_in_source:
          print(f'File number {counter} - {file} is already in the source volume "{copy_to}". Skipping file.')
        else:
          file_to_copy = f'{copy_from}{file}'
          copy_file_to = f'{copy_to}{file}'
          print(f'File number {counter} - Copying file {file_to_copy} --> {copy_file_to}.')
          dbutils.fs.cp(file_to_copy, copy_file_to , recurse = True)
          
          ## Sleep after load
          time.sleep(sleep) 

        ## Stop after n number of loops based on argument.
        if counter == n:
          break
        else:
          counter = counter + 1

# COMMAND ----------

# DBTITLE 1,Move Files
def move_files(move_from: str, move_to: str, n: int, sleep=2):
    '''
    Move files from one location to another destination's volume.

    This method performs the following tasks:
      1. Lists files in the source directory and sorts them. Sorted to keep them in the same order when moving for consistency.
      2. Verifies that the source directory has at least `n` files.
      3. Moves files from the source to the destination, skipping files already present at the destination.
      4. Pauses for `sleep` seconds after moving each file.
      5. Stops after moving `n` files or if all files are processed.
      6. Will print information on the files moved.
    
    Parameters
    - move_from (str): The source directory where files are to be moved from.
    - move_to (str): The destination directory where files will be moved to.
    - n (int): The number of files to move from the source. If n is larger than total files, an error is returned.
    - sleep (int, optional): The number of seconds to pause after moving each file. Default is 2 seconds.

    Returns:
    - None: Prints information to the log on what files it's loading. If the file exists, it skips that file.

    Example:
    - move_files(move_from='/Volumes/gym_data/v01/user-reg', 
           move_to=f'{DA.paths.working_dir}/pii/stream_source/user_reg',
           n=1)
    '''
    import os
    import time

    print(f"\n----------------Loading files to user's volume: '{move_to}'----------------")

    ## List all files in the move_from volume and sort the list
    list_of_files_to_move = sorted(os.listdir(move_from))
    total_files_in_move_location = len(list_of_files_to_move)

    ## Get a list of files in the source
    list_of_files_in_source = os.listdir(move_to)

    assert total_files_in_move_location >= n, f"The source location contains only {total_files_in_move_location} files, but you specified {n}  files to move. Please specify a number less than or equal to the total number of files available."

    ## Looping counter
    counter = 1

    ## Load files if not found in the co
    for file in list_of_files_to_move:
      if file.startswith('_') or os.path.isdir(f'{move_from}{file}'):
        pass
      else:
        ## If the file is found in the source, skip it with a note. Otherwise, move file.
        if file in list_of_files_in_source:
          print(f'File number {counter} - {file} is already in the source volume "{move_to}". Skipping file.')
        else:
          file_to_move = f'{move_from}{file}'
          move_file_to = f'{move_to}{file}'
          print(f'File number {counter} - moving file {file_to_move} --> {move_file_to}.')
          dbutils.fs.mv(file_to_move, move_file_to , recurse = True)
          
          ## Sleep after load
          time.sleep(sleep) 

        ## Stop after n number of loops based on argument.
        if counter == n:
          break
        else:
          counter = counter + 1
