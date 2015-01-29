runner = require "../libs/runner"
Joi = require "joi"

exports.winrate = (req, res) ->
	schema = Joi.object().keys
		strategy: Joi.string().required()

	Joi.validate req.body, schema, (err, value) ->
		if err
			res.status(406).json
				status: "failure"
				message: err.message
		else
			runner.getWinrate req.body.strategy, (err, output) ->
				if err
					console.log err
					res.status(500).json
						status: "failure"
						message: err.message
				else
					if output.timedOut
						res.status(200).json
							status: "failure"
							message: "timeout"

						

exports.index = (req, res) ->
	res.render 'index'