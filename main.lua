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
	local animate1_1, animate1_2, animate5_1, animate5_2

    animate1_1 = function()
        textObjects[1].numCycles = textObjects[1].numCycles + 1
        if textObjects[1].numCycles < 9 then
            transition.to( textObjects[1], { time=500, alpha=0, onComplete=animate1_2} )
        end
    end
    animate1_2 = function()
        transition.to( textObjects[1], { time=500, alpha=1, onComplete=animate1_1} )
    end
    
	animate5_1 = function()
		transition.to( textObjects[5], { time=6000, y=textObjects[5].y+100, onComplete=animate5_2} )
	end
	animate5_2 = function()
		transition.to( textObjects[5], { time=2000, rotation=360} )
	end
	
	local objectReady = function(o)
		if o.id then 
            print("Object ready: " .. o.id)
        		if o.id == "text5" then
        			animate5_1()
        		end
            if o.id == "text1" then
                animate1_1()
            end
    		end
	end

	textObjects[1] = styledText.newText({
		text = "Unstyled",
		id = "text1",
		textColor = {0.15, 0.70, 0.5, 1.0},
		x = display.contentWidth / 2,
		y = spacing, 
		font = "Arial", 
		size = 32,
		callback = objectReady
	})
	textObjects[1].numCycles = 0

	textObjects[2] = styledText.newText({
		text = "Glow Black",
		id = "text2",
		textColor = {0.15, 0.70, 0.5, 1.0},
		x = display.contentWidth / 2,
		y = spacing*2, 
		font = "Arial", 
		size = 34,
		glowOffset = 1,
		glowColor = {0, 0, 0, 0.5},
		callback = objectReady
	})

	textObjects[3] = styledText.newText({
		text = "Glow White",
		id = "text3", 
		textColor = {0.15, 0.70, 0.5, 1.0},
		x = display.contentWidth / 2,
		y = spacing*3, 
		font = native.systemFontBold, 
		size = 36,
		glowOffset = 1,
		glowColor = {1, 1, 1, 0.5},
		callback = objectReady
	})

	textObjects[4] = styledText.newText({
		text = "Shadow Black",
		id = "text4",
		textColor = {0.15, 0.70, 0.5, 1.0},
		x = display.contentWidth / 2,
		y = spacing*4, 
		size = 38,
		shadowOffset = 3,
		shadowColor = {0,0,0,180},
		callback = objectReady
	})

	textObjects[5] = styledText.newText({
		text = "White On Blue",
		id = "text5",
		textColor = {1.0, 1.0, 1.0, 1.0},
		x = display.contentWidth / 2,
		y = spacing*5, 
		font = "Arial", 
		size = 40,
		shadowOffset = 3,
		shadowColor =  {0.3,0.3,1.0,0.8},
		callback = objectReady
	})

	textObjects[6] = styledText.newText({
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
		callback = objectReady
	})

end

main()
