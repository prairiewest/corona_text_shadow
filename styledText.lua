-- styledText
--
-- Copyright 2013 Todd Trann
--
-- Sample usage:
--
--  local styledText = require("styledText")
--	local myText = styledText.newText({
--		text = "Hello World", 
--		textColor = {255,255,255,255},
--		x = 160,
--		y = 200, 
--		font = "Arial", 
--		size = 24,
--		shadowOffset = 2,
--		shadowColor = {0,0,0,80},
--		glowOffset = 1,
--		glowColor = {120,0,0,180}
--	})
--
-- Colors can be specified using the new scale (0.0-1.0) or the old scale (0-255)
--
-- List of all parameters that can be passed in:
--
--   text:      the string to be displayed [default: " "]
--   textColor: the color of the text [default: white]
--   size:      the text size [default: 24 points]
--   font:      the name of the font face to use [default: native.systemFontBold]
--
--   width:     the max width (in pixels); this is needed if you want multi-line text [default: nil]
--   align:     a string describing text alignment when width is supplied [default: "left"]
--
--   x:       the x coordinate [default: 160]
--   y:       the y coordinate [default: 240]
--   anchorX: the X anchor (0.0 - 1.0) [default: 0.5]
--   anchorY: the Y anchor (0.0 - 1.0) [default: 0.5]
--
--   shadowColor:  the color of the shadow effect [default: black (0,0,0,0.5)]
--   shadowOffset: the distance that the shadow is offset from the text [default: 0]
--   blurShadow:   0=do not blur the shadow; 1=blur the shadow [default=1]
--
--   glowColor:  the color of the glow around the text [default: grey (0.5,0.5,0.5,1.0)]
--   glowOffset: the width of the glow around the text, in pixels [default: 0]
--   blurGlow    0=do not blur the glow; 1=blur the glow [default=1]
--
--   embossDepth: integer, the number of pixels to raise or lower the emboss effect. Negative means raised instead. [default: 0]
--
-- Note that to remove the text you must call its clear() function first:
--   myText:clear()
--   display:remove(myText)
--



local M = {}

local function newText(options)
    local labelText = {}, shadowOffset, shadowColor, glowOffset, glowColor, blurShadow, blurGlow
    local text, size, font, textColor, x, y, embossDepth, width, align, anchorX, anchorY
    local i = 1
	local layer1 = display.newGroup()
	layer1.x = display.contentWidth/2
	layer1.y = display.contentHeight/2
	local layer2 = display.newGroup()
	layer2.x = display.contentWidth/2
	layer2.y = display.contentHeight/2
	local layerOutput = display.newGroup()
	local output1, output2

	if ( options.size and type(options.size) == "number" ) then size=options.size else size=24 end
	if ( options.font ) then font=options.font else font=native.systemFontBold end
	if ( options.x and type(options.x) == "number" ) then x=options.x else x=160 end
	if ( options.y and type(options.y) == "number" ) then y=options.y else y=240 end
	if ( options.anchorX and type(options.anchorX) == "number" ) then anchorX=options.anchorX end
	if ( options.anchorY and type(options.anchorY) == "number" ) then anchorY=options.anchorY end
	if ( options.width and type(options.width) == "number" ) then width=options.width end
	if ( options.align) then align=options.align else align="left" end
	if ( options.textColor ) then textColor=options.textColor else textColor={ 1.0,1.0,1.0,1.0 } end
	if ( options.shadowColor ) then shadowColor=options.shadowColor else shadowColor={ 0, 0, 0, 0.5 } end
	if ( options.shadowOffset and type(options.shadowOffset) == "number" ) then shadowOffset=options.shadowOffset else shadowOffset = 0 end
	if ( options.glowColor ) then glowColor=options.glowColor else glowColor={ 0.5,0.5,0.5,1.0 } end
	if ( options.glowOffset and type(options.glowOffset) == "number" ) then glowOffset=options.glowOffset else glowOffset = 0 end
	if ( options.embossDepth and type(options.embossDepth) == "number" ) then embossDepth=options.embossDepth else embossDepth = 0 end
	if ( options.blurGlow and type(options.blurGlow) == "number" ) then blurGlow=options.blurGlow else blurGlow = 1 end
	if ( options.blurShadow and type(options.blurShadow) == "number" ) then blurShadow=options.blurShadow else blurShadow = 1 end
	if ( options.text) then text = options.text else text = " " end
	
	local function applyNewColorScale(a)
		if type(a[1]) == "number" then
			if (a[1] > 1.0 or a[2] > 1.0 or a[3] > 1.0 or a[4] > 1.0) then
				a[1] = a[1] / 255
				a[2] = a[2] / 255
				a[3] = a[3] / 255
				a[4] = a[4] / 255
			end
		end 
	end
		
	applyNewColorScale(textColor)
	applyNewColorScale(shadowColor)
	applyNewColorScale(glowColor)
	
	if (embossDepth ~= 0) then shadowOffset = 0; glowOffset = 0;textColor={ 0.5,0.5,0.5,1.0 } end
	if (glowOffset == 1) then glowOffset = 1.5 end -- compensate for loss due to blur
	
	if (shadowOffset > 0) then
		if (glowOffset > 0) then
			for xo = -glowOffset,glowOffset,1 do
				for yo = -glowOffset,glowOffset,1 do
					local style = {
						parent=layer1,
						text=text, 
						font=font, 
						fontSize=size
					}
					if (type(width) == "number") then
						style.width = width
						style.align = align
					end
					labelText[i] = display.newText(style)
					labelText[i].x = shadowOffset+xo; labelText[i].y = shadowOffset+yo
					labelText[i]:setFillColor( shadowColor[1], shadowColor[2], shadowColor[3], shadowColor[4] )
					i = i + 1
				end 
			end
		else
			local style = {
				parent=layer1,
				text=text,
				font=font, 
				fontSize=size
			}
			if (type(width) == "number") then
				style.width = width
				style.align = align
			end
			labelText[i] = display.newText(style)
			labelText[i].x = shadowOffset; labelText[i].y = shadowOffset
			labelText[i]:setFillColor( shadowColor[1], shadowColor[2], shadowColor[3], shadowColor[4] )
			i = i + 1
		end
	end

	if (embossDepth < 0) then
		for yo = -embossDepth,embossDepth,embossDepth do
			local style = {
				parent=layer1,
				text=text, 
				font=font, 
				fontSize=size
			}
			if (type(width) == "number") then
				style.width = width
				style.align = align
			end
			labelText[i] = display.newText(style)
			labelText[i].x = 0; labelText[i].y = yo
			if (yo < 0) then 
				labelText[i]:setFillColor( 0, 0, 0, 80 )
			else 
				labelText[i]:setFillColor( 255,255,255,80 )
			end
			i = i + 1
		end
	elseif (embossDepth > 0) then
		for yo = embossDepth,-embossDepth,-embossDepth do
			local style = {
				parent=layer1,
				text=text, 
				font=font, 
				fontSize=size 
			}
			if (type(width) == "number") then
				style.width = width
				style.align = align
			end
			labelText[i] = display.newText(style)
			labelText[i].x = 0; labelText[i].y = yo
			if (yo < 0) then 
				labelText[i]:setFillColor( 255,255,255,80)
			else 
				labelText[i]:setFillColor( 0,0,0,80 )
			end
			i = i + 1
		end
	end

	if (glowOffset > 0) then
		for xo = -glowOffset,glowOffset,1 do
			for yo = -glowOffset,glowOffset,1 do
				local style = {
					parent=layer2,
					text=text, 
					font=font, 
					fontSize=size
				}
				if (type(width) == "number") then
					style.width = width
					style.align = align
				end
				labelText[i] = display.newText(style)
				labelText[i].x = xo; labelText[i].y = yo
				labelText[i]:setFillColor( glowColor[1], glowColor[2], glowColor[3], glowColor[4] )
				i = i + 1
			end 
		end
	end
	
	if (shadowOffset > 1 or embossDepth ~= 0) then
		output1 = display.capture(layer1)
		if (blurShadow == 1) then
			output1.fill.effect = "filter.blurGaussian"
			output1.fill.effect.horizontal.blurSize = 2
			output1.fill.effect.horizontal.sigma = 1.5
			output1.fill.effect.vertical.blurSize = 2
			output1.fill.effect.vertical.sigma = 1.5
		end
		output1.x = shadowOffset
		output1.y = shadowOffset
		layerOutput:insert(output1)
	end
	if (glowOffset > 1) then
		output2 = display.capture(layer2)
		if (blurGlow == 1) then
			output2.fill.effect = "filter.blurGaussian"
			output2.fill.effect.horizontal.blurSize = 2
			output2.fill.effect.horizontal.sigma = 1.5
			output2.fill.effect.vertical.blurSize = 2
			output2.fill.effect.vertical.sigma = 1.5
		end
		layerOutput:insert(output2)
	end
	for i, v in ipairs(labelText) do
		labelText[i]:removeSelf()
		labelText[i] = nil
	end
	layer1:removeSelf(); layer1 = nil
	layer2:removeSelf(); layer2 = nil
	
	local style = {
		parent=layerOutput,
		text=text, 
		font=font, 
		fontSize=size
	}
	if (type(width) == "number") then
		style.width = width
		style.align = align
	end
	labelText[i] = display.newText(style)
	labelText[i].x = 0; labelText[i].y = 0
	labelText[i]:setFillColor( textColor[1], textColor[2], textColor[3], textColor[4] )
	i = i + 1
	if (type(anchorX) == "number") then
		layerOutput.anchorX = anchorX
	end
	if (type(anchorY) == "number") then
		layerOutput.anchorY = anchorY
	end
	layerOutput.x=x; layerOutput.y=y

	function layerOutput:clear()
		for i=1,layerOutput.numChildren do
			if (layerOutput[i] ~= nil) then
			    layerOutput[i]:removeSelf()
			end
		end
	end
		
	return layerOutput
end
M.newText = newText

return M