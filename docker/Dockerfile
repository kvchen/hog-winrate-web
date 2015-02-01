FROM ubuntu:14.04
MAINTAINER Kevin Chen <kvchen@berkeley.edu>

RUN apt-get update
RUN apt-get install -y build-essential python3

COPY hog/winrate.py /opt/env/winrate.py
COPY hog/util.py /opt/env/util.py
COPY hog/dice.py /opt/env/dice.py
COPY hog/ucb.py /opt/env/ucb.py

COPY entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["/bin/bash", "/opt/entrypoint.sh"]
