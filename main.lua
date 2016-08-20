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

	local myText1 = styledText.newText({
		text = "Unstyled", 
		textColor = {40,180,120,255},
		x = display.contentWidth / 2,
		y = spacing, 
		font = "Arial", 
		size = 40
	})

	local myText2 = styledText.newText({
		text = "Glow Black", 
		textColor = {40,180,120,255},
		x = display.contentWidth / 2,
		y = spacing*2, 
		font = "Arial", 
		size = 40,
		glowOffset = 1,
		glowColor = {0,0,0,120}
	})

	local myText3 = styledText.newText({
		text = "Glow White", 
		textColor = {40,180,120,255},
		x = display.contentWidth / 2,
		y = spacing*3, 
		font = "Arial", 
		size = 40,
		glowOffset = 1,
		glowColor = {255,255,255,120}
	})

	local myText4 = styledText.newText({
		text = "Shadow Black", 
		textColor = {40,180,120,255},
		x = display.contentWidth / 2,
		y = spacing*4, 
		font = "Arial", 
		size = 40,
		shadowOffset = 3,
		shadowColor = {0,0,0,180}
	})

end

main()
