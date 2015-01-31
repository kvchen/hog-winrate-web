runner = require "../libs/runner"
Joi = require "joi"

winrate = (req, res) ->
	schema = Joi.object().keys
		strategy: Joi.string().required()

	Joi.validate req.body, schema, (err, value) ->
		if err
			res.status(406).json
				status: "failure"
				error: err.message
		else
			runner.getWinrate req.body.strategy, (err, output) ->
				if err
					console.log err
					res.status(500).json
						status: "failure"
						error: err.message
				else
					if output.winrate
						output.message = getMessage winrate*100
					res.status(200).json output


getMessage = (winrate) ->
	if winrate > 64
		messages = ['that\'s it!', 'nothing left to do.', 'you solved it!']
	else if winrate > 60
		messages = ['now we\'re talking', 'keep optimizing', 'push it to the limit']
	else if winrate >= 56
		messages = ['you did it!', 'congrats!', 'top-tier work!', 'awesome!']
	else if winrate > 55
		messages = ['so close!', 'almost there...', 'just a bit more']
	else if winrate > 53
		messages = ['getting there...', 'keep at it!', 'keep going!']
	else if winrate > 49
		messages = ['just about even']
	else if winrate > 40
		messages = ['could be a bit better', 'keep trying!', 'try something different!']
	else if winrate > 30
		messages = ['darnit', 'something\'s not right', 'something\'s off...']
	else if winrate > 20
		messages = ['huh...', 'that\'s kinda low...', 'need a boost?']
	else
		messages = [';_____;', ':(', '...']

	return messages[Math.floor (Math.random() * messages.length)]


module.exports = winrate