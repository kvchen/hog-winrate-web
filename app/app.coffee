express    = require "express"
bodyParser = require "body-parser"
connectAssets = require "connect-assets"

logger = require "./libs/logger"
routes = require "./routes"

# Define the Express app
app = express()

app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"

app.disable "x-powered-by"

app.use express.static __dirname + "/assets"
app.use connectAssets
	compress: true
	gzip: true

app.use bodyParser.json()

# View endpoints
app.get '/', routes.index

# API endpoints
app.post '/winrate', routes.winrate

# Export app for other modules to use
module.exports = app