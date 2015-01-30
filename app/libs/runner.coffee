config = require "../config"

Docker = require "dockerode"
MemoryStream = require "memorystream"

fs = require "fs-extra"
path = require "path"
logger = require "./logger"
shortId = require "shortid"

runnerConfig = config.docker.runner

# Create a client attached to the Docker daemon
socket = process.env.DOCKER_SOCKET || config.docker.socket
docker = new Docker 
	socketPath: socket

# Set up default paths
basePath = path.dirname require.main.filename

volumes = {}
volumes[runnerConfig.volumes.code] = {}
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
	shared = path.join basePath, "tmp", id

	startOptions = 
		Binds: ["#{shared}:#{runnerConfig.volumes.code}:ro"]

	fs.mkdirs shared, (err) ->
		return done err if err

		fs.writeFile path.join(shared, 'hog.py'), strategy, (err) ->
			return done err if err

			docker.createContainer containerOptions, (err, container) ->
				return done err if err

				container.attach attachOptions, (err, stream) ->
					return done err if err

					chunksRead = 0
					timedOut = false
					truncated = false

					output = ""
					outputStream = new MemoryStream()
					outputStream.on "data", (chunk) ->
						output += chunk
						if ++chunksRead > runnerConfig.maxLength
							logger.warn "#{id}: Output truncated"
							truncated = true
							stream.destroy()

					container.modem.demuxStream stream, outputStream, outputStream

					container.start startOptions, (err, data) ->
						return done err if err

						timeout = setTimeout ( ->
							logger.warn "#{id}: Code timed out"
							timedOut = true
							stream.destroy()
						), runnerConfig.timeout

						stream.on "end", ->
							clearTimeout timeout

							container.inspect (err, inspection) ->
								return done err if err

								response = 
									status:
										exitCode: inspection.State.ExitCode
										timedOut: timedOut
										truncated: truncated
									output: output
									env:
										container: container
										volume: shared

								return done null, response


removeContainer = (container, volume, done) ->
	if container
		container.remove force: true, (err, data) =>
			logger.warn "Failed to remove container #{container}" if err

	fs.remove volume, (err) ->
		logger.warn "Failed to remove tmp directory #{volume}" if err

	done null


exports.getWinrate = getWinrate
exports.removeContainer = removeContainer