

# Set the base image

# FROM 144538309574.dkr.ecr.us-east-1.amazonaws.com/gesos-base-ubuntu:20.04
FROM ubuntu:22.04

USER root

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# MetaData
LABEL version="0.1.0"
LABEL description="GESOS Packer Build Container"


# Run Updates
RUN apt-get update \
    && apt-get install software-properties-common \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu55 \
        libunwind8 \
        netcat \
        wget \
        unzip \
        python3-minimal \
        apt-transport-https \
        lsb-release \
        gnupg \
        python3-winrm \
        python3-pip \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
    && AZ_REPO=$(lsb_release -cs) \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update \
    && apt-get install azure-cli \
    && apt-get purge software-properties-common \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* 

# Install python packages

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt
RUN pip3 install ansible --upgrade


# COPY ./cacert.pem  /tmp/cacert.pem

# Install AWSCLIv2

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" -k && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip && \
    rm -r ./aws/*

# Install Terraform

RUN curl "https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip" -o "terraformv1.zip" -k && \
    unzip terraformv1.zip && \
    rm terraformv1.zip

# Set Terraform Path

RUN mv /home/gecloud/terraform /usr/bin/terraform

# Set Python Path

RUN export PYTHONPATH=/usr/bin/python3 && \
    echo $PYTHONPATH && \
    mkdir -p /azp && \
    ln -fs /usr/bin/python3 /usr/bin/python

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

# Setup Python Tool for Azure

CMD ["./start.sh"]