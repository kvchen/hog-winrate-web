exports.winrate = (req, res) ->
	res.status(200).json 
		data:
			status: 'success'
			winrate: 54.3823

exports.index = (req, res) ->
	res.render 'index'