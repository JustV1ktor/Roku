function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "OK"
            m.top.buttonSelected = true
            result = true
        end if
    end if
    return result
end function