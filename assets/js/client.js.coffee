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
		"Tab": function(cm){
			cm.replaceSelection("	", "end");
		}
	editor.focus()

	running = false
	getWinrate = ->
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
					winrate = res.winrate * 100

					counter = new countUp 'winrate', 0, winrate, 2, 4, 
						useEasing: true
						decimal: '.'
						suffix: '%'

					counter.start () ->
						$('#unhelpfulMessage').text res.message
				else
					if res.error.type == 'KeyError'
						setError 'your code doesn\'t always return an integer between 0 and 10.'
					else if res.error.type == 'TimeoutError'
						setError 'Your code timed out!\nCheck for infinite loops.'
					else
						setError 'oops! your code has a ' + res.error.type + '.'

			complete: (res) ->
				NProgress.done()
				running = false
				
			error: (res) ->
				setError 'rip server'

	setOutput = (winrate, msg) ->
		$('#winrate').text winrate
		$('#unhelpfulMessage').text msg

	setError = (msg) ->
		setOutput ';___;', msg

	$('#getWinrate').click (e) ->
		getWinrate()

	$("#getWinrate").mouseup ->
		$(this).blur()

