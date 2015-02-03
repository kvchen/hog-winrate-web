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

	editor.setValue '# Paste your final_strategy into this box, along with any helper functions you need. Use Ctrl+Enter or Cmd+Enter to generate a plot!\n\ndef final_strategy(score, opponent_score):\n    """*** YOUR CODE HERE ***"""\n    return 5 # Replace this statement\n\n\n'
	editor.setOption "extraKeys",
		"Ctrl-Enter": (cm) ->
			drawStrategy()
		"Cmd-Enter": (cm) ->
			drawStrategy()
		"Tab": (cm) ->
			cm.replaceSelection("    " , "end");
		"Shift-Tab": (cm) ->
			cm.indentSelection("subtract")

	editor.focus()

	running = false
	drawStrategy = ->
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
				console.log res

				if res.status == 'success'
					plotMoveset res.moves
				else
					console.log res.error.type

			complete: (res) ->
				NProgress.done()
				running = false
				
			error: (res) ->
				console.log res


