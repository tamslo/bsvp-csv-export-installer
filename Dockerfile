FROM ubuntu:18.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# INSTALL GENERAL DEPENDENCIES

RUN apt-get update
RUN apt-get install -y curl software-properties-common
RUN apt-get install -y python3-minimal python3-pip virtualenv
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash
RUN apt-get install -y nodejs

# INSTALL BSVP EXPORTERS FROM GIT

ADD https://api.github.com/repos/tamslo/bsvp-csv-export/git/refs/heads version.json
RUN git clone https://github.com/tamslo/bsvp-csv-export.git code
WORKDIR /code
RUN virtualenv venv -p python3
RUN source venv/bin/activate && pip install -r requirements.txt
WORKDIR /code/client
RUN npm install
RUN npm run build

WORKDIR /code
COPY ./config.json /code/config.json
