FROM mkieboom/apache-drill-docker

#
# Welcome to the FAIR'ification and integration of biological data.
#

#
# Install the xml2json commandline utility
#
RUN yum install -y curl wget

RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
    yum -y install nodejs

RUN npm install -g xml2json-command && \
    mkdir /carnival_scripts

COPY scripts/ carnival_scripts

CMD ["/drill-scripts/bootstrap.sh"]