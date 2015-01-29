FROM ubuntu:14.04
MAINTAINER Kevin Chen <kvchen@berkeley.edu>

RUN apt-get update
RUN apt-get install -y build-essential python3

ADD entrypoint.sh entrypoint.sh
ENTRYPOINT ["/bin/bash", "entrypoint.sh"]
