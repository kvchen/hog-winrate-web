winrate = require './winrate'

exports.index = (req, res) ->
	res.render 'index'

exports.winrate = winrate