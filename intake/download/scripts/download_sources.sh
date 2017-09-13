#!/bin/bash

# Load URLs for files to download
readarray -t lines < /carnival_scripts/sources.txt

# Download all sources
exit_code=0
for url in "${lines[@]}"
do
  target_dir="/carnival_data/intake/data"
  log_file="/carnival_data/intake/data/download.log"
  echo "downloading $url to $target_dir"
  /carnival_scripts/download-and-log.sh $log_file $target_dir $url
  e=$?
  if [ $e -ne 0 ]; then
    exit_code=$e
  fi
done

# unzip any zip files
find /carnival_data/intake -name '*.zip' -exec sh -c 'unzip -u -d "${1%.*}" "$1"' _ {} \;

