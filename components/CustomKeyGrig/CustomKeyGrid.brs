sub init()
    setKeys()
end sub

sub setKeys()
    m.mainArea = m.top.findNode("mainArea")
    m.arrayKeysText = ["1","2","3","4","5","6","7","8","9","0","a","v","q","w","u","g","d","A"]

    m.currentRow = 0
    m.currentColumn = 0

    m.numRows = 0
    numButtons = 0

    m.mainArea.createChild("LayoutGroup")
    m.mainArea.getChild(m.numRows).layoutDirection = "horiz"

    for each item in m.arrayKeysText
        if m.mainArea.getChild(m.numRows).getChildCount() = 4
            m.mainArea.createChild("LayoutGroup")
            numRows++
            m.mainArea.getChild(m.numRows).layoutDirection = "horiz"
            numButtons = 0
        end if

        m.mainArea.getChild(m.numRows).createChild("Button")
        m.mainArea.getChild(m.numRows).getChild(numButtons).text = item
        m.mainArea.getChild(m.numRows).getChild(numButtons).height = 50
        m.mainArea.getChild(m.numRows).getChild(numButtons).maxWidth = 50
        numButtons++
    end for



    m.mainArea.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "right"
            if m.currentColumn = 4
                m.currentColumn++
            end if
            result = true
        else if key = "left"
            m.currentColumn--
            result = true
        else if key = "up"
            m.currentRow++
            result = true
        else if key = "down"
            m.currentRow--
            result = true
        end if
    end if

    m.mainArea.getChild(m.currentRow).getChild(m.currentColumn).setFocus(true)

    return result
end function