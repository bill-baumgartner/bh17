#!/bin/bash

#
# NOTE: Apache Drill container must be running at this point
#

# run the pharmgkb genes r2rml
docker run --rm --net=carnival-net --volumes-from carnival_data billbaumgartner/carnival-r2rml:0.1 sh -c '/carnival_scripts/run_r2rml.sh -c /carnival_config/pharmgkb/pharmgkb_genes.ttl'
