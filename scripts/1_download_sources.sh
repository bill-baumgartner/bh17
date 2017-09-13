#!/bin/bash

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

# if provided, copy the drugbank XML file into the /carnival_data container and create a metadata file (.ready)
if [[ ${DRUGBANK_FILE} ]]; then
    echo "Copying DrugBank file ($DRUGBANK_FILE) into carnival_data volume"
    docker run --rm --volumes-from carnival_data billbaumgartner/carnival-download:0.1 sh -c 'mkdir -p /carnival_data/intake/drugbank'
    docker cp "${DRUGBANK_FILE}" carnival_data:'/carnival_data/intake/drugbank/full_database.xml'
fi

# if provided, copy the pharmGKB relationships file into the /carnival_data container and create a metadata file (.ready)
if [[ ${PHARMGKB_RELATIONS_FILE} ]]; then
    echo "Copying PharmGKB file ($PHARMGKB_RELATIONS_FILE) into carnival_data volume"
    docker run --rm --volumes-from carnival_data billbaumgartner/carnival-download:0.1 sh -c 'mkdir -p /carnival_data/intake/pharmgkb'
    docker cp "${PHARMGKB_RELATIONS_FILE}" carnival_data:'/carnival_data/intake/pharmgkb/relationships.tsv'
fi


# download and unpack the data source files
docker run --rm --volumes-from carnival_data billbaumgartner/carnival-download:0.1 sh -c '/carnival_scripts/download_sources.sh'

docker run --rm --volumes-from carnival_data billbaumgartner/carnival-xml-processing:0.1 sh -c '/carnival_scripts/process_xml_sources.sh'
