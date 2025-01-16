sub init()
    m.top.setFocus(true)
    m.top.backgroundColor = "0x662D91"
    
    m.button = m.top.findNode("buttonCount")
    m.button.observeField("buttonSelected", "count")
    m.button.setFocus(true)

    m.label = m.top.findNode("labelText")

    m.x = 0
end sub

' function OnkeyEvent(key as String, press as Boolean) as Boolean
'     result = false
'     if key = "OK"
        
'         result = true
'     end if
'     return result
' end function

sub count() 
    m.x = m.x + 1
    m.label.text = "count " + m.x.toStr()
end sub