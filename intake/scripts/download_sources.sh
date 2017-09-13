#!/bin/bash

#
# This script facilitates the import of data sources into the data-intake container.
#

function print_usage {
    echo "Usage:"
    echo "$(basename $0) [OPTIONS]"
    echo "  [-d <drugbank XML file path>]: OPTIONAL -- The local path to the DrugBank 'full database.xml' file. This file requires user registration to download, and therefore must be supplied by the user. This parameter is optional. If not provided, then the DrugBank resource simply will not be included."
    echo "  [-p <pharmgkb relationships file path>]: OPTIONAL -- The local path to the PharmGKB relationships file (relationships.tsv). This file requires a PharmGKB license, and therefore must be supplied by the user. This parameter is optional. If not provided, then the PharmGKB relationships simply will not be included."
}

while getopts "d:p:h" OPTION; do
    case ${OPTION} in
        # OPTIONAL -- The local path to the DrugBank 'full database.xml' file. This file requires user registration to
        # download, and therefore must be supplied by the user. This parameter is optional. If not provided, then the
        # DrugBank resource simply will not be included.
        d) DRUGBANK_FILE=$OPTARG
           ;;
        # OPTIONAL -- The local path to the PharmGKB relationships file. This file requires a license from PharmGKB,
        # and therefore must be supplied by the user. This parameter is optional. If not provided, then the
        # PharmGKB relationships resource simply will not be included.
        p) PHARMGKB_RELATIONS_FILE=$OPTARG
           ;;
        # HELP!
        h) print_usage; exit 0
           ;;
    esac
done

if ! [[ -e README.md ]]; then
    echo "Please run from the root of the project."
    exit 1
fi

# Create a Docker volume where the will be stored:
docker create -v /carnival_data --name carnival_data ubuntu:latest

# if provided, copy the drugbank XML file into the /carnival_data container and create a metadata file (.ready)
if [[ ${DRUGBANK_FILE} ]]; then
    echo "Copying DrugBank file ($DRUGBANK_FILE) into carnival_data volume"
    docker run --rm --volumes-from carnival_data billbaumgartner/carnival:0.1 sh -c 'mkdir -p /carnival_data/intake/drugbank'
    docker cp "${DRUGBANK_FILE}" carnival_data:'/carnival_data/intake/drugbank/full_database.xml'
fi

# if provided, copy the pharmGKB relationships file into the /carnival_data container and create a metadata file (.ready)
if [[ ${PHARMGKB_RELATIONS_FILE} ]]; then
    echo "Copying PharmGKB file ($PHARMGKB_RELATIONS_FILE) into carnival_data volume"
    docker run --rm --volumes-from carnival_data billbaumgartner/carnival:0.1 sh -c 'mkdir -p /carnival_data/intake/pharmgkb'
    docker cp "${PHARMGKB_RELATIONS_FILE}" carnival_data:'/carnival_data/intake/pharmgkb/relationships.tsv'
fi


# Load URLs for files to download
readarray -t lines < sources.txt
declare -A ary
for line in "${lines[@]}"; do
   key="${line%%$'\t'*}"
   value="${line#*$'\t'}"
   ary[$key]=$value  ## Or simply ary[${line%%=*}]=${line#*=}
done

# Download all sources
exit_code=0
for dir in "${!ary[@]}"
do
  target_dir="/carnival_data/intake/${dir}"
  log_file="/carnival_data/intake/${dir}/download.log"
  url = "${ary[$i]}"
  echo "downloading $url to $target_dir"
  download-and-log.sh $log_file $target_dir $url
  e=$?
  if [ $e -ne 0 ]; then
    exit_code=$e
  fi
done

# unzip any zip files
find -name '*.zip' /carnival_data/intake -exec sh -c 'unzip -d "${1%.*}" "$1"' _ {} \;