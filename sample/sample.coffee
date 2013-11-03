###
Sample usage
###
jQuery ->
	$(window).load(() ->
		for i, index in [600, 300, 150, 75, 38, 19]
			$("body").append "<canvas style='border-radius: #{i * 0.1}px;' id='gauge#{index}' width='#{i}px' height='#{i}px'></canvas>"
			gauge = new TankGauge canvas: $("#gauge#{index}")[0], bgColor: "#ee2e24", fgColor: "#40c8f4", startAngle: 120, endAngle:60
			gauge.setValue Math.random()
			gauge.draw()
			console.log "hi"
	)