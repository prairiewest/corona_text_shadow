--
-- This is a demo for the styledText module.
-- Blog tutorial is here: http://prairiewest.net/blog/2013/12/text-shadow-glow-corona-sdk/
--
-- Please see the styledText source code for usage
--
-- Todd Trann
--

local function main()

	local styledText = require("styledText")
	local spacing = 60

	local background = display.newImageRect("background.jpg",570,570)
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	local textObjects = {}
	local animate, animate2

	animate = function()
		transition.to( textObjects[5], { time=6000, y=textObjects[5].y+100, onComplete=animate2} )
	end

	animate2 = function()
		transition.to( textObjects[5], { time=2000, rotation=360} )
		textObjects[1]:removeSelf()  -- Show how to remove text
	end

	local registerObject = function(o)
		table.insert(textObjects, o)
		print("Registered text object #" .. #textObjects)
		if (o.id) then print("id of this object: " .. o.id) end

		if o.id and o.id == "text5" then
			animate()
		end
	end

	styledText.newText({
		text = "Unstyled",
		id = "text1",
		textColor = {0.15, 0.70, 0.5, 1.0},
		x = display.contentWidth / 2,
		y = spacing, 
		font = "Arial", 
		size = 32,
		callback = registerObject
	})

	styledText.newText({
		text = "Glow Black",
		id = "text2",
		textColor = {0.15, 0.70, 0.5, 1.0},
		x = display.contentWidth / 2,
		y = spacing*2, 
		font = "Arial", 
		size = 34,
		glowOffset = 1,
		glowColor = {0, 0, 0, 0.5},
		callback = registerObject
	})

	styledText.newText({
		text = "Glow White",
		id = "text3", 
		textColor = {0.15, 0.70, 0.5, 1.0},
		x = display.contentWidth / 2,
		y = spacing*3, 
		font = native.systemFontBold, 
		size = 36,
		glowOffset = 1,
		glowColor = {1, 1, 1, 0.5},
		callback = registerObject
	})

	styledText.newText({
		text = "Shadow Black",
		id = "text4",
		textColor = {0.15, 0.70, 0.5, 1.0},
		x = display.contentWidth / 2,
		y = spacing*4, 
		size = 38,
		shadowOffset = 3,
		shadowColor = {0,0,0,180},
		callback = registerObject
	})

	styledText.newText({
		text = "White On Blue",
		id = "text5",
		textColor = {1.0, 1.0, 1.0, 1.0},
		x = display.contentWidth / 2,
		y = spacing*5, 
		font = "Arial", 
		size = 40,
		shadowOffset = 3,
		shadowColor =  {0.3,0.3,1.0,0.8},
		callback = registerObject
	})

	styledText.newText({
		text = "Shadow and Red Glow", 
		textColor = {1.0, 1.0, 1.0, 1.0},
		x = 160,
		y = display.contentHeight - 14, 
		font = "Arial", 
		size = 24,
		shadowOffset = 2,
		shadowColor = {0, 0, 0, 0.40},
		glowOffset = 1,
		glowColor = {0.5, 0, 0, 0.75},
		callback = registerObject
	})

end

main()
