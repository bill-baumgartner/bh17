FROM python:latest

#
# Install the xml2json commandline utility
#
#RUN yum install -y curl wget unzip
#
#RUN yum install -y epel-release && \
#    yum -y update && \
#    yum -y install python-pip
#
#RUN pip install --upgrade pip

RUN pip install https://github.com/hay/xml2json/zipball/master

COPY scripts/ /carnival_scripts