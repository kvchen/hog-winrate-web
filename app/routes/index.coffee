winrate = require './winrate'
visualize = require './visualize'

exports.winrate = winrate
exports.visualize = visualize


exports.index = (req, res) ->
	res.render 'index'

