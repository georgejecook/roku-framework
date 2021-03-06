
' The MIT License (MIT)

' Copyright (c) 2015 Karim Kawambwa

' Author Karim Kawambwa

' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:

' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.

' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.

function UILabel(options)
    
    if options["bg:opacity"] = invalid then options["bg:opacity"] = "0"
    if options["bg:color"] = invalid then options["bg:color"] = "white"
    
    this = UIView(options, {
        type  : "UILabel"
        text  : if_else(options.text <> invalid, options.text, "")
        size  : if_else(options.size <> invalid, toInt(options.size), 10)
        font  : invalid 'Will be loaded
        color : ColorWithName(options.color)
        colorname : options.color
        fontname : options.font
    })
    
    this.font = FontWithNameAndSize(this.fontname, this.size)
    
    ' @Override UIVIew init
    this.base_view_Init = this.init
    this.init = function()
        if m.font = invalid then print "Font Failed to Load : ", m.id
        
        m.sizeToFit()
        
        'FIX : ROKU BUG FOR TEXT DRAWING ON BITMAP
        m.backgroundColor = ColorWithName(m.colorname, ColorOpacity(0))
        
        m.base_view_Init()
        
        m.drawText()
    end function
    
    this.drawText = function()
        bitmap =  m.sprites.sprite(0).GetRegion().GetBitmap()
        if m.font <> invalid then
            drewText = bitmap.DrawText(m.text, 0, 0, m.color, m.font)
            if not drewText then print "Error : Failed to draw text '"+m.text+"' in label ["+m.id+"]"
        end if
    end function
    
    ' @Override UIVIew prepareForLayout
    this.base_view_prepareForLayout = this.prepareForLayout
    this.prepareForLayout = function()
        m.sizeToFit()
        
        m.base_view_prepareForLayout()
    end function
    
    ' @Override UIVIew didLayout
    this.base_view_didLayout = this.didLayout
    this.didLayout = function()
        m.base_view_didLayout()
    end function
    
    this.sizeToFit = function() as Void
        if m.font = invalid then return
        
        m.setWidth(GetFontWidth(m.font, m.text))
        m.setHeight(GetFontHeight(m.font))
    end function
    
    this.base_view_Draw = this.draw
    this.draw = function(component as Object) as Boolean
        m.base_view_Draw(component)
        
        m.drawText()
        return true
    end function
    
    return this
end function