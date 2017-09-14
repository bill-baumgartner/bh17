FROM azul/zulu-openjdk:8u92

RUN apt-get update && apt-get install -y \
    curl \
    maven \
    git \
    unzip \
    wget \
    less

# install a custom version of OWLTools
RUN git clone https://opengogs.adaptcentre.ie/debruync/r2rml.git ./r2rml.git && \
	mvn clean install -f ./r2rml.git/pom.xml