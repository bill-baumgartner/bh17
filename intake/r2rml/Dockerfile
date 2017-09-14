FROM azul/zulu-openjdk:8u92

RUN apt-get update && apt-get install -y \
    curl \
    maven \
    git \
    unzip \
    wget \
    less

# install a custom version of OWLTools
RUN git clone https://opengogs.adaptcentre.ie/debruync/r2rml.git /r2rml.git && \
    # it is necessary to install the ojdbc7.jar file into the local maven repository prior to building the project
    mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=/r2rml.git/lib/ojdbc7.jar \
                                                                                  -DgroupId=com.oracle.jdbc \
                                                                                  -DartifactId=ojdbc7 \
                                                                                  -Dversion=12.1.0.2 \
                                                                                  -Dpackaging=jar \
                                                                                  -DgeneratePom=true && \
	mvn clean install -f ./r2rml.git/pom.xml