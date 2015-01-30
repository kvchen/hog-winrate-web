FROM ubuntu:14.04
MAINTAINER Kevin Chen <kvchen@berkeley.edu>

RUN apt-get update
RUN apt-get install -y build-essential python3

ADD hog/winrate.py /opt/env/winrate.py
ADD hog/util.py /opt/env/util.py

ADD entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["/bin/bash", "/opt/entrypoint.sh"]
