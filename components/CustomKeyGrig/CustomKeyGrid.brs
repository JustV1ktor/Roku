sub init()
    m.mainArea = m.top.findNode("mainArea")
    m.arrayKeysText = ["1","2","3","4","5","6","7","8","9","0","a","v","q","w","u","g","d","A"]

    setKeys()
    m.mainArea.setFocus(true)
end sub

sub setKeys()
    numRows = 0
    numButtons = 0

    m.mainArea.createChild("LayoutGroup")
    m.mainArea.getChild(numRows).layoutDirection = "horiz"

    for each item in m.arrayKeysText
        if m.mainArea.getChild(numRows).getChildCount() = 4
            m.mainArea.createChild("LayoutGroup")
            numRows++
            m.mainArea.getChild(numRows).layoutDirection = "horiz"
            numButtons = 0
        end if

        m.mainArea.getChild(numRows).createChild("Button")
        m.mainArea.getChild(numRows).getChild(numButtons).text = item
        m.mainArea.getChild(numRows).getChild(numButtons).height = 50
        m.mainArea.getChild(numRows).getChild(numButtons).maxWidth = 50
        numButtons++
    end for
end sub