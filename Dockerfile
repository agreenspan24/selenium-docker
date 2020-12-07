
# base image from https://github.com/matthewfeickert/Docker-Python3-Ubuntu/blob/master/Dockerfile

FROM python:3.8-buster

USER root
WORKDIR /root

SHELL [ "/bin/bash", "-c" ]

ARG PYTHON_VERSION_TAG=3.8.0
ARG LINK_PYTHON_TO_PYTHON3=1

## from https://hub.docker.com/r/selenium/node-chrome/dockerfile
#============================================
# Google Chrome
#============================================
# can specify versions by CHROME_VERSION;
#  e.g. google-chrome-stable=53.0.2785.101-1
#       google-chrome-beta=53.0.2785.92-1
#       google-chrome-unstable=54.0.2840.14-1
#       latest (equivalent to google-chrome-stable)
#       google-chrome-beta  (pull latest beta)
#============================================
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
  
# Install Oathtool:
RUN apt-get -y install gnupg2 oathtool 

ADD requirements.txt .
RUN python3 -m pip install -r requirements.txt

# uncomment below for local dev
# 
# ADD example /opt/app/
# CMD [ "python3.6", "example/run.py" ] 
