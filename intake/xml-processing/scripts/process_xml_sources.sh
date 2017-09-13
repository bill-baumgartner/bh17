#!/bin/bash

# convert all .xml files to json
find /carnival_data/intake -name '*.xml' -exec sh -c 'xml2json -t xml2json -o "$1".json "$1"' _ {} \;
