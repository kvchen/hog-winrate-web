### Configuration file

This file contains all the necessary options for running an instance of the
hog winrate calculator.
###

# Database and daemon settings

module.exports.docker = 
  socket: "/var/run/docker.sock"
  runner:
    image: "runner"
    networkDisabled: true
    memory: 50e6
    timeout: 1e4
    maxLength: 1e3
    volumes:
      code: "/opt/runner/code"
      env: "/opt/runner/env"
    output:
      stream: true
      stdout: true
      stderr: true
      tty: false