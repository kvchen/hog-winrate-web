app    = require "./app/app"
logger = require "./app/libs/logger"

server = app.listen app.get("port"), ->
  logger.info "Server listening on port " + server.address().port