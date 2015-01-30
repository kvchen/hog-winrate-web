$ -> 
	editor = CodeMirror.fromTextArea document.getElementById("code"), 
		mode:
			name: "python"
			version: 3
			singleLineStringErrors: false
		lineNumbers: true
		indentUnit: 4
		matchBrackets: true
		lineWrapping: true

	editor.setValue '# Paste your final_strategy into this box, along with any helper functions you need.\n\ndef final_strategy(score, opponent_score):\n    """*** YOUR CODE HERE ***"""\n    return 5 # Replace this statement\n\n\n'
	editor.setOption "extraKeys",
		"Ctrl-Enter": (cm) ->
			getWinrate()
		"Cmd-Enter": (cm) ->
			getWinrate()
	editor.focus()

	running = false
	getWinrate = () ->
		return if running

		running = true
		NProgress.start()

		$('#winrate').text '...'
		$('#unhelpfulMessage').text 'calculating...'

		params = JSON.stringify
			strategy: editor.getValue()

		$.ajax
			type: 'POST'
			contentType: "application/json"
			url: "/winrate"
			dataType: "json"
			data: params
			success: (res) ->
				if res.status == 'success'
					output = res.output.output.split(/\r?\n/)
					results = jQuery.parseJSON output[output.length - 2]

					if results.error
						$('#winrate').text 'error!'
						$('#unhelpfulMessage').text 'looks like your code has a bug :('
					else
						winrate = results.winrate * 100

						counter = new countUp 'winrate', 0, winrate, 2, 4, 
							useEasing: true
							decimal: '.'
							suffix: '%'

						counter.start () ->
							if winrate <= 53
								$('#unhelpfulMessage').text 'lots of room for progress...'
							if winrate > 53
								$('#unhelpfulMessage').text 'we\'re getting there...'
							else if winrate > 55
								$('#unhelpfulMessage').text 'almost there...'
							else if winrate > 56
								$('#unhelpfulMessage').text 'you did it!'
				else
					$('#winrate').text 'error!'
					$('#unhelpfulMessage').text 'something broke :('

			complete: (res) ->
				NProgress.done()
				running = false
				
			error: (res) ->
				$('#winrate').text 'error!'
				$('#unhelpfulMessage').text 'something broke :('

	$('#getWinrate').click (e) ->
		getWinrate()

	$("#getWinrate").mouseup () ->
		$(this).blur()

