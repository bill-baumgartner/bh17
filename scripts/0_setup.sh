#!/bin/bash

# build the image
docker build -t billbaumgartner/carnival-download:0.1 ./intake/download
docker build -t billbaumgartner/carnival-xml-processing:0.1 ./intake/xml-processing
docker build -t billbaumgartner/carnival-r2rml:0.1 ./intake/r2rml

# create the carnival_data volume if it does not already exist
if [ ! "$(docker ps -a | grep carnival_data)" ]; then
   docker create -v /carnival_data --name carnival_data ubuntu:latest
fi

# create the carnival-net network if it does not already exist
if [ ! "$(docker network ls | grep carnival-net)" ]; then
   docker network create carnival-net
fi


