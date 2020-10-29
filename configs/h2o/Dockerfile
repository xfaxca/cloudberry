FROM ubuntu:latest

ARG H2O_VERSION

RUN apt-get update \
	&& apt-get install default-jdk unzip wget -y

RUN wget http://h2o-release.s3.amazonaws.com/h2o/rel-zahradnik/1/h2o-${H2O_VERSION}.zip \
	&& unzip h2o-${H2O_VERSION}.zip

ENV H2O_VERSION ${H2O_VERSION}
CMD java -jar h2o-${H2O_VERSION}/h2o.jar
