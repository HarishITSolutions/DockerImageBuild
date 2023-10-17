FROM ubuntu:22.04

MAINTAINER 503356053@ge.com

RUN apt update
RUN apt upgrade -y
RUN apt install -y curl git jq libicu70
RUN apt install -y python3
RUN apt install -y python3-pip


