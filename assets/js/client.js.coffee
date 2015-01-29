$ -> 
	editor = CodeMirror.fromTextArea document.getElementById("code"), 
		mode:
			name: "python"
			version: 3
			singleLineStringErrors: false
		lineNumbers: true
		indentUnit: 4
		matchBrackets: true

	editor.setValue '# Paste your final_strategy into this box, along with any helper functions you need.\n\ndef final_strategy(score, opponent_score):\n    """*** YOUR CODE HERE ***"""\n    return 5 # Replace this statement\n\n\n'

	running = false
	getWinrate = () ->
		return if running

		running = true
		NProgress.start()

		params = JSON.stringify
			strategy: editor.getValue()

		$.ajax
			type: 'POST'
			contentType: "application/json"
			url: "/winrate"
			dataType: "json"
			data: params
			success: (res) ->
				console.log res.data
				if res.data.status == 'success'
					winrate = res.data.winrate

					counter = new countUp 'winrate', 0, winrate, 2, 4, 
						useEasing: true
						decimal: '.'
						suffix: '%'

					counter.start()
				else
					$('#winrate').text 'error!'
					$('#unhelpfulMessage').text 'check below for details'


				NProgress.done()
				running = false
			error: (res) ->

				NProgress.done()
				running = false

	$('#getWinrate').click (e) ->
		console.log 'test'
		
		getWinrate()


