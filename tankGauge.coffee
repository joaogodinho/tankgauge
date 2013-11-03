###
tankGauge v1.0
Created by João Godinho
November 2013
###
class @TankGauge
	@degreeToRad: (degree) -> degree * Math.PI / 180
	@calcAngle: (start, end, value) ->
		start + ((Math.PI * 2 - Math.abs(start - end)) * value)

	constructor: (defaultParameters = {}) ->
		@_ctx = defaultParameters.canvas.getContext("2d") or undefined
		@_fgColor = defaultParameters.fgColor or "#000"
		@_bgColor = defaultParameters.bgColor or "#FFF"
		@_startAngle = TankGauge.degreeToRad(defaultParameters.startAngle) or 0
		@_endAngle = TankGauge.degreeToRad(defaultParameters.endAngle) or Math.PI * 2
		@_width = defaultParameters.canvas.width;
		@_height = defaultParameters.canvas.height;
		@_lineWidth = defaultParameters.lineWidth or 0.04 * @_width # 4% of canvas width, assuming square canvas
		@_counterClockwise = defaultParameters.counterClockwise or false
		@_radius = defaultParameters.radius or 0.275 * @_width # 27.5% of canvas width, assuming square canvas
		@_currentValue = 0.5
		@_handleColor = defaultParameters.handleColor or "#FFF"
		@_handleRadius = defaultParameters.handleRadius or 0.0625 * @_width / 2 # 6.25% of canvas width, assuming square canvas
		@_amplitude = Math.PI * 2 - Math.abs(@_startAngle - @_endAngle)

	setValue: (value) ->
		@_currentValue = value

	draw: ->
		centerX = @_width / 2
		centerY = @_height / 2

		# draw background arc
		@_ctx.clearRect(0, 0, @_width, @_height)
		@_ctx.beginPath()
		@_ctx.strokeStyle = @_bgColor
		@_ctx.lineWidth = @_lineWidth - 1
		@_ctx.lineCap = "round"
		@_ctx.arc(centerX, centerY, @_radius, @_startAngle, @_endAngle, @_counterClockwise)
		@_ctx.stroke()
		
		# draw current value arc
		@_ctx.beginPath()
		@_ctx.strokeStyle = @_fgColor
		@_ctx.lineWidth = @_lineWidth
		@_ctx.lineCap = "round"
		@_ctx.arc(centerX, centerY, @_radius, @_startAngle, TankGauge.calcAngle(@_startAngle, @_endAngle, @_currentValue), @_counterClockwise)
		@_ctx.stroke()
		
		# draw handle
		@_ctx.beginPath()
		@_ctx.fillStyle = @_handleColor
		handleX = @_radius * Math.cos(Math.PI * 2 - TankGauge.calcAngle(@_startAngle, @_endAngle, @_currentValue))
		handleY = @_radius * -Math.sin(Math.PI * 2 - TankGauge.calcAngle(@_startAngle, @_endAngle, @_currentValue))
		@_ctx.arc(centerX + handleX, centerY + handleY, @_handleRadius, 0, 2 * Math.PI, no)
		@_ctx.shadowColor = "#000"
		@_ctx.shadowBlur = @_width * 0.004 # 0.4% of canvas width
		@_ctx.fill()
		
		# draw text
		@_ctx.shadowBlur = 0
		@_ctx.textAlign = "center"
		@_ctx.fillStyle = "#777777"
		@_ctx.font = "#{0.04 * @_width}px 'NeoTechAlt'" # 2% of canvas width
		
		# text "0"
		fontX = (@_radius + 0.08 * @_width) * Math.cos(@_startAngle)
		fontY = (@_radius + 0.08 * @_width) * Math.sin(@_startAngle)
		@_ctx.fillText("0", centerX + fontX, centerY + fontY)
		
		# text "1/4"
		fontX = (@_radius + 0.08 * @_width) * Math.cos(@_startAngle + @_amplitude / 4)
		fontY = (@_radius + 0.08 * @_width) * Math.sin(@_startAngle + @_amplitude / 4)
		@_ctx.fillText("1/4", centerX + fontX, centerY + fontY)
		
		# text "1/2"
		fontX = (@_radius + 0.08 * @_width) * Math.cos(@_startAngle + @_amplitude / 2)
		fontY = (@_radius + 0.08 * @_width) * Math.sin(@_startAngle + @_amplitude / 2)
		@_ctx.fillText("1/2", centerX + fontX, centerY + fontY)
		
		# text "3/4"
		fontX = (@_radius + 0.08 * @_width) * Math.cos(@_endAngle - @_amplitude / 4)
		fontY = (@_radius + 0.08 * @_width) * Math.sin(@_endAngle - @_amplitude / 4)
		@_ctx.fillText("3/4", centerX + fontX, centerY + fontY)
		
		# text "1"
		fontX = (@_radius + 0.08 * @_width) * Math.cos(@_endAngle)
		fontY = (@_radius + 0.08 * @_width) * Math.sin(@_endAngle)
		@_ctx.fillText("1", centerX + fontX, centerY + fontY)
