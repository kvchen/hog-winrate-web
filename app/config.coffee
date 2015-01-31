### Configuration file

This file contains all the necessary options for running an instance of the
hog winrate calculator.
###

# Database and daemon settings

module.exports.docker = 
  socket: "/var/run/docker.sock"
  runner:
    image: "arbiter"
    networkDisabled: true
    memory: 10e6
    timeout: 5e3
    maxLength: 1e3
    volumes:
      share: "/opt/share"
      env: "/opt/env"
    output:
      stream: false
      stdout: false
      stderr: false
      tty: false