FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]

# INSTALL GENERAL DEPENDENCIES

RUN apt-get update
RUN apt-get install -y curl python3-minimal python3-pip git

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 11.11.0
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/v$NODE_VERSION/bin:$PATH

# INSTALL BSVP EXPORTERS FROM GIT

RUN git clone https://github.com/tamslo/bsvp-csv-export.git code
WORKDIR /code
RUN pip3 install -r requirements.txt
WORKDIR /code/client
RUN npm install
RUN npm run build

WORKDIR /code
# TODO: copy config.json (if there, test both cases)
