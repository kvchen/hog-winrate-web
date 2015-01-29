# Copy files from the host directory to a container directory
cp -r /opt/runner/code/* /opt/runner/env

OUTPUT = "$(python3 /opt/runner/env/winrate.py)"
printf "${OUTPUT}"