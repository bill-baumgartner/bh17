#!/bin/bash

# This script runs the r2rml library using the parameters passed in via a configuration file
#
# NOTE: input arguments must be absolute paths

function print_usage {
    echo "Usage:"
    echo "$(basename $0) [OPTIONS]"
    echo "  [-c <config file>]: configuration properties file"
}

while getopts "c:h" OPTION; do
    case $OPTION in
        # Configuration file
        c) CONFIG_FILE=$OPTARG
        ;;
        # HELP!
        h) print_usage; exit 0
        ;;
    esac
done

if [[ -z $CONFIG_FILE ]]; then
	echo "Missing required configuration file. Please see usage instructions..."
    print_usage
    exit 1
fi

mvn -X -e -f /carnival_scripts/pom_run_r2rml.xml exec:exec \
        -DconfigurationFile=$CONFIG_FILE
