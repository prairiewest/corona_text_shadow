-- styledText
--
-- Copyright 2013 Todd Trann
-- MIT License
--
-- Sample usage:
--
--  local styledText = require("styledText")
--
--	local myText = styledText.newText({
--		text = "Hello World", 
--		textColor = {1.0, 1.0, 1.0, 1.0},
--		x = 160,
--		y = 200, 
--		font = "Arial",
--		id = "myText1",
--		size = 24,
--		shadowOffset = 2,
--		shadowColor = {0, 0, 0, 0.40},
--		glowOffset = 1,
--		glowColor = {0.5, 0, 0, 0.75},
--		callback = myFunction
--	})
--
-- Colors can be specified using floating point (0.0-1.0) or old style integer (0-255)
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
--   embossDepth: integer, the number of pixels to raise or lower the emboss effect. Negative means raised. [default: 0]
--
--   id: if supplied, the final object will be assigned this id
--   callback: if supplied, this function will be called after the text is rendered, with the final output as the argument
--
-- To remove the text once created, you must have kept a reference to it:
--   myText:removeSelf()


local M = {}

M.cachedLayers = {}

M.cacheToFilesystem = function(layerToSave)
    display.save(layerToSave, {filename=layerToSave.cacheFileName, baseDir=system.TemporaryDirectory} )
    table.insert(M.cachedLayers, layerToSave)
end

M.onSystemEvent = function( event )
    if (event.type=="applicationResume") then
        for i,v in ipairs(M.cachedLayers) do
            if v ~= nil then
                -- Remove all previously rendered objects, since their textures have been purged and can't be redrawn
                while v.numChildren and v.numChildren > 0 do
                    local child = v[1]
                    if child then child:removeSelf() end
                end
                if v.cacheFileName and v.cacheWidth and v.cacheHeight then
                    -- Reload from cache
                    local cachedImage = display.newImageRect(v,v.cacheFileName,system.TemporaryDirectory, v.cacheWidth, v.cacheHeight)
                end
            end
        end
    elseif (event.type == "applicationExit") then
        -- Clean up cached images from temp folder
        for i,v in ipairs(M.cachedLayers) do
            if v.cacheFileName ~= nil then
                os.remove(system.pathForFile(v.cacheFileName, system.TemporaryDirectory ))
                v.cacheFileName = nil
            end
        end
    end
end

M.startCapture = function(layerOutput, layer1, layer2, labelText, args)
    local output1, output2
    local nextIndex = #labelText + 1

    if (args.shadowOffset > 1 or args.embossDepth ~= 0) then
        output1 = display.capture(layer1)
        if (args.blurShadow == 1) then
            output1.fill.effect = "filter.blurGaussian"
            output1.fill.effect.horizontal.blurSize = 2
            output1.fill.effect.horizontal.sigma = 1.5
            output1.fill.effect.vertical.blurSize = 2
            output1.fill.effect.vertical.sigma = 1.5
        end
        output1.x = args.shadowOffset
        output1.y = args.shadowOffset
        layerOutput:insert(output1)
    end

    if (args.glowOffset > 1) then
        output2 = display.capture(layer2)
        if (args.blurGlow == 1) then
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
    
    local styleO = {
        parent   = layerOutput,
        text     = args.text, 
        font     = args.font, 
        fontSize = args.size
    }
    if (type(args.width) == "number") then
        styleO.width = args.width; styleO.align = args.align
    end
    labelText[nextIndex] = display.newText(styleO)
    labelText[nextIndex].x = 0; labelText[nextIndex].y = 0
    labelText[nextIndex]:setFillColor( args.textColor[1], args.textColor[2], args.textColor[3], args.textColor[4] )
    nextIndex = nextIndex + 1
    if (type(args.anchorX) == "number") then
        layerOutput.anchorX = args.anchorX
    end
    if (type(args.anchorY) == "number") then
        layerOutput.anchorY = args.anchorY
    end
    layerOutput.x=args.x; layerOutput.y=args.y

    if args.id then layerOutput.id = args.id end
    local bounds = layerOutput.contentBounds
    layerOutput.cacheWidth = bounds.xMax - bounds.xMin
    layerOutput.cacheHeight = bounds.yMax - bounds.yMin
    if args.callback then args.callback(layerOutput) end
end

M.newText = function(options)
    local labelText = {}
    local args = {
    	align        = "left", 
    	anchorX      = 0.5,
    	anchorY      = 0.5,
    	blurGlow     = 1,
    	blurShadow   = 1, 
    	callback    = nil,
    	embossDepth  = 0, 
    	font         = native.systemFontBold, 
    	glowColor    = { 0.5,0.5,0.5,1.0 }, 
    	glowOffset   = 0,
    	shadowColor  = { 0, 0, 0, 0.5 }, 
    	shadowOffset = 0, 
    	size         = 24, 
    	text         = " ",
    	textColor    = { 1.0,1.0,1.0,1.0 }, 
    	width        = nil,
    	x            = display.contentWidth/2, 
    	y            = display.contentHeight/2
    }
    local nextIndex = 1
	local layer1 = display.newGroup()
	layer1.x, layer1.y = display.contentWidth/2, display.contentHeight/2
	local layer2 = display.newGroup()
	layer2.x, layer2.y = display.contentWidth/2, display.contentHeight/2
	local layerOutput = display.newGroup()
    math.randomseed(os.clock()*1000000000)
	layerOutput.cacheFileName = math.random(100000000, 999999999) .. ".png"

	if ( options.align        and type(options.align) == "string")         then args.align        = options.align end
	if ( options.anchorX      and type(options.anchorX) == "number")       then args.anchorX      = options.anchorX end
	if ( options.anchorY      and type(options.anchorY) == "number")       then args.anchorY      = options.anchorY end
	if ( options.blurGlow     and type(options.blurGlow) == "number")      then args.blurGlow     = options.blurGlow end
	if ( options.blurShadow   and type(options.blurShadow) == "number")    then args.blurShadow   = options.blurShadow end
	if ( options.callback     and type(options.callback) == "function")    then args.callback     = options.callback end
	if ( options.embossDepth  and type(options.embossDepth) == "number")   then args.embossDepth  = options.embossDepth end
	if ( options.font         and (type(options.font) == "string" 
		                      or  type(options.font) == "userdata"))       then args.font         = options.font end
	if ( options.glowColor    and type(options.glowColor) == "table")      then args.glowColor    = options.glowColor end
	if ( options.glowOffset   and type(options.glowOffset) == "number")    then args.glowOffset   = options.glowOffset end
	if ( options.shadowColor  and type(options.shadowColor) == "table")    then args.shadowColor  = options.shadowColor end
	if ( options.shadowOffset and type(options.shadowOffset) == "number")  then args.shadowOffset = options.shadowOffset end
	if ( options.size         and type(options.size) == "number" )         then args.size         = options.size end
	if ( options.text         and type(options.text) == "string")          then args.text         = options.text end
	if ( options.id           and type(options.id) == "string")            then args.id           = options.id end
	if ( options.textColor    and type(options.textColor) == "table")      then args.textColor    = options.textColor end
	if ( options.width        and type(options.width) == "number" )        then args.width        = options.width end
	if ( options.x            and type(options.x) == "number" )            then args.x            = options.x end
	if ( options.y            and type(options.y) == "number" )            then args.y            = options.y end

	local function applyColorScale(a)
		if type(a[1]) == "number" then
			if (a[1] > 1.0 or a[2] > 1.0 or a[3] > 1.0 or a[4] > 1.0) then
				a[1] = a[1] / 255
				a[2] = a[2] / 255
				a[3] = a[3] / 255
				a[4] = a[4] / 255
			end
		end 
	end

	applyColorScale(args.textColor)
	applyColorScale(args.shadowColor)
	applyColorScale(args.glowColor)
	
	if (args.embossDepth ~= 0) then args.shadowOffset = 0; args.glowOffset = 0; args.textColor={ 0.5,0.5,0.5,1.0 } end
	if (args.glowOffset == 1) then args.glowOffset = 1.5 end -- compensate for loss due to blur
	local style1 = {
		parent   = layer1,
		text     = args.text,
		font     = args.font, 
		fontSize = args.size
	}
	local style2 = {
		parent   = layer2,
		text     = args.text,
		font     = args.font, 
		fontSize = args.size
	}
	if (type(args.width) == "number") then
		style1.width = args.width; style2.width = args.width
		style1.align = args.align; style2.align = args.align
	end

	if (args.shadowOffset > 0) then
		if (args.glowOffset > 0) then
			for xo = -args.glowOffset,args.glowOffset,1 do
				for yo = -args.glowOffset,args.glowOffset,1 do
					labelText[nextIndex] = display.newText(style1)
					labelText[nextIndex].x = args.shadowOffset+xo; labelText[nextIndex].y = args.shadowOffset+yo
					labelText[nextIndex]:setFillColor( args.shadowColor[1], args.shadowColor[2], args.shadowColor[3], args.shadowColor[4] )
					nextIndex = nextIndex + 1
				end 
			end
		else
			labelText[nextIndex] = display.newText(style1)
			labelText[nextIndex].x = args.shadowOffset; labelText[nextIndex].y = args.shadowOffset
			labelText[nextIndex]:setFillColor( args.shadowColor[1], args.shadowColor[2], args.shadowColor[3], args.shadowColor[4] )
			nextIndex = nextIndex + 1
		end
	end

	if (args.embossDepth < 0) then
		for yo = -args.embossDepth,args.embossDepth,args.embossDepth do
			labelText[nextIndex] = display.newText(style1)
			labelText[nextIndex].x = 0; labelText[nextIndex].y = yo
			if (yo < 0) then 
				labelText[nextIndex]:setFillColor( 0, 0, 0, 80 )
			else 
				labelText[nextIndex]:setFillColor( 255,255,255,80 )
			end
			nextIndex = nextIndex + 1
		end
	elseif (args.embossDepth > 0) then
		for yo = args.embossDepth,-args.embossDepth,-args.embossDepth do
			labelText[nextIndex] = display.newText(style1)
			labelText[nextIndex].x = 0; labelText[nextIndex].y = yo
			if (yo < 0) then 
				labelText[nextIndex]:setFillColor( 255,255,255,80)
			else 
				labelText[nextIndex]:setFillColor( 0,0,0,80 )
			end
			nextIndex = nextIndex + 1
		end
	end

	if (args.glowOffset > 0) then
		for xo = -args.glowOffset,args.glowOffset,1 do
			for yo = -args.glowOffset,args.glowOffset,1 do
				labelText[nextIndex] = display.newText(style2)
				labelText[nextIndex].x = xo; labelText[nextIndex].y = yo
				labelText[nextIndex]:setFillColor( args.glowColor[1], args.glowColor[2], args.glowColor[3], args.glowColor[4] )
				nextIndex = nextIndex + 1
			end 
		end
	end

  	timer.performWithDelay( 200, function()
  		M.startCapture(layerOutput, layer1, layer2, labelText, args)
  	end)

    if system.getInfo("platform") == "android" then
        timer.performWithDelay( 300, function()
            M.cacheToFilesystem(layerOutput)
        end)
    end
    return layerOutput -- WARNING: may not yet be fully rendered
end

if system.getInfo("platform") == "android" then
    Runtime:addEventListener( "system", M.onSystemEvent )
end

return M
