# Corona Text Shadow and Glow
This is the source code for the tutorial at http://prairiewest.net/blog/2013/12/text-shadow-glow-corona-sdk/


Sample usage:
```
  local styledText = require("styledText")
  local myText

  local registerObject = function(o)
      myText = o
  end

  styledText.newText({
		text = "Hello World", 
		textColor = {255,255,255,255},
		x = 160,
		y = 200, 
		font = "Arial", 
		size = 24,
		shadowOffset = 2,
		shadowColor = {0,0,0,80},
		glowOffset = 1,
		glowColor = {120,0,0,180},
      callback = registerObject
	})
```

Colors can be specified using floating point (0.0-1.0) or old style integer (0-255)

List of all parameters that can be passed in:
```
   text:      the string to be displayed [default: " "]
   textColor: the color of the text [default: white]
   size:      the text size [default: 24 points]
   font:      the name of the font face to use [default: native.systemFontBold]

   width:     the max width (in pixels); this is needed if you want multi-line text [default: nil]
   align:     a string describing text alignment when width is supplied [default: "left"]

   x:       the x coordinate [default: 160]
   y:       the y coordinate [default: 240]
   anchorX: the X anchor (0.0 - 1.0) [default: 0.5]
   anchorY: the Y anchor (0.0 - 1.0) [default: 0.5]

   shadowColor:  the color of the shadow effect [default: black (0,0,0,0.5)]
   shadowOffset: the distance that the shadow is offset from the text [default: 0]
   blurShadow:   0=do not blur the shadow; 1=blur the shadow [default=1]

   glowColor:  the color of the glow around the text [default: grey (0.5,0.5,0.5,1.0)]
   glowOffset: the width of the glow around the text, in pixels [default: 0]
   blurGlow    0=do not blur the glow; 1=blur the glow [default=1]

   embossDepth: integer, the number of pixels to raise or lower the emboss effect. Negative means raised. [default: 0]

   id: if supplied, the final object will be assigned this id
   callback: if supplied, this function will be called after the text is rendered, with the final output as the argument
```

To remove the text once created, you must have kept a reference to it with the callback function:
   textObjectReference:removeSelf()


Copyright 2013 Todd Trann


LICENSE

The MIT License (MIT)

Copyright (c) 2014 Gaspare Sganga

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
