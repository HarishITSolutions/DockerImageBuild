FROM ubuntu:22.04

MAINTAINER 503356053@ge.com

RUN \
# Update
apt-get update -y && \
# Install Unzip
apt-get install unzip -y && \
# need wget
apt-get install wget -y && \
# vim
apt-get install vim -y && \
# Python3
apt-get install python3 -y && \
# python3-pip
apt-get install python3-pip -y && \
# Ansible
pip3 install ansible

################################
# Install Terraform
################################

# Download terraform for linux
RUN wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
# Unzip
RUN unzip terraform_1.6.0_linux_amd64.zip

# Move to local bin
RUN mv terraform /usr/local/bin/
# Check that it's installed
RUN terraform --version
################################
# Install Azure Cli
################################
ENV AZ_REPO $(lsb_release -cs)
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list

RUN apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
 --keyserver packages.microsoft.com \
 --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF

RUN apt-get update

RUN apt-get install azure-cli

CMD ["/bin/bash"]
