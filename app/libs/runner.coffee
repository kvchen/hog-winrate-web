config = require "../config"

Docker = require "dockerode"
MemoryStream = require "memorystream"

fs = require "fs-extra"
logger = require "./logger"
path = require "path"
shortId = require "shortid"

runnerConfig = config.docker.runner

# Create a client attached to the Docker daemon
socket = process.env.DOCKER_SOCKET || config.docker.socket
docker = new Docker 
	socketPath: socket

# Set up default paths
basePath = path.dirname require.main.filename

volumes = {}
volumes[runnerConfig.volumes.share] = {}
volumes[runnerConfig.volumes.env] = {}

# Define options
containerOptions = 
	Image: runnerConfig.image
	Memory: runnerConfig.memory
	NetworkDisabled: runnerConfig.networkDisabled
	Volumes: volumes
	Cmd: []

attachOptions = runnerConfig.output


getWinrate = (strategy, done) ->
	id = shortId.generate()
	share = path.join basePath, "tmp", id

	fs.mkdirs share, (err) ->
		return done err if err

		fs.writeFile path.join(share, 'hog.py'), strategy, (err) ->
			return done err if err

			docker.createContainer containerOptions, (err, container) ->
				return done err if err

				startContainer container, share, done


startContainer = (container, share, done) ->
	container.attach attachOptions, (err) ->
		if err
			clean container, share
			return done err

		startOptions =
			Binds: ["#{share}:#{runnerConfig.volumes.share}"]

		container.start startOptions, (err, data) ->
			if err
				clean container, share
				return done err

			timedOut = false
			timeout = setTimeout ( ->
				timedOut = true
				clean container, share
			), runnerConfig.timeout

			container.wait (err, data) ->
				clearTimeout timeout

				if err
					clean container, share
					return done err

				if timedOut
					response = 
						'status': 'failure'
						'error':
							'type': 'TimeoutError'
				else
					response = require path.join share, 'outfile.json'
				
				done null, response
				clean container, share


clean = (container, volume) ->
	if container
		container.remove force: true, (err, data) ->
			if err
				logger.warn "Failed to remove container #{container.id}"
			else
				logger.info "Removed container #{container.id}"

	if volume
		fs.remove volume, (err) ->
			logger.warn "Failed to remove tmp directory #{volume}" if err


exports.getWinrate = getWinrate


