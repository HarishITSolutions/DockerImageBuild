FROM ubuntu 
MAINTAINER 503356053@ge.com

RUN apt-get update 
RUN apt-get install –y nginx 
CMD [“echo”,”Image created”] 