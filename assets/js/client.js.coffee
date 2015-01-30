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
				console.log res
				if res.status == 'success'
					console.log res
					winrate = res.winrate

					counter = new countUp 'winrate', 0, winrate, 2, 4, 
						useEasing: true
						decimal: '.'
						suffix: '%'

					counter.start()
				else
					$('#winrate').text 'error!'
					$('#unhelpfulMessage').text 'check below for details'

			complete: (res) ->
				NProgress.done()
				running = false
				
			error: (res) ->
				$('#winrate').text 'error!'
				$('#unhelpfulMessage').text 'something broke :('

	setMessage = (winrate) ->
		if winrate <= 53
			$('#unhelpfulMessage').text 'time to get cracking'
		if winrate > 53
			$('#unhelpfulMessage').text 'making progress...'
		else if winrate > 55
			$('#unhelpfulMessage').text 'almost there...'
		else if winrate > 56
			$('#unhelpfulMessage').text 'you did it!'

	enableWinrate = () ->
		running = false

	$('#getWinrate').click (e) ->
		getWinrate()

	$("#getWinrate").mouseup () ->
		$(this).blur()


