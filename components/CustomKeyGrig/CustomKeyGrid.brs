sub init()
    _findAndPopulate()
end sub

sub _findAndPopulate()
    m._customKeyArea = m.top.findNode("customKeyArea")
    m._controlKeyArea = m.top.findNode("controlKeyArea")
    m._textEditBox = m.top.findNode("textEditBox")

    m._buttonClear = m.top.findNode("buttonClear")
    m._buttonSpace = m.top.findNode("buttonSpace")
    m._buttonEnter = m.top.findNode("buttonEnter")
    
    m._buttonClear.observeFieldScoped("buttonSelected", "_onButtonClearSelected")
    m._buttonSpace.observeFieldScoped("buttonSelected", "_onButtonSpaceSelected")
    m._buttonEnter.observeFieldScoped("buttonSelected", "_onButtonEnterSelected")

    arrayKeysText = ["1","2","3","4","5","6","7","8","9","0","a","v","q","w","u","r","g","d","A"]
    
    m._rowButtonsLength = 4

    m._currentRow = 0
    m._currentColumn = 0

    numRows = 0
    numButtons = 0

    m._customKeyArea.createChild("LayoutGroup")
    m._customKeyArea.getChild(numRows).layoutDirection = "horiz"

    for each item in arrayKeysText
        if m._customKeyArea.getChild(numRows).getChildCount() = m._rowButtonsLength
            m._customKeyArea.createChild("LayoutGroup")
            numRows++
            m._customKeyArea.getChild(numRows).layoutDirection = "horiz"
            numButtons = 0
        end if

        m._customKeyArea.getChild(numRows).createChild("Button")
        m._customKeyArea.getChild(numRows).getChild(numButtons).minWidth = 180
        m._customKeyArea.getChild(numRows).getChild(numButtons).maxWidth = 180
        m._customKeyArea.getChild(numRows).getChild(numButtons).text = item
        numButtons++
    end for

    m._totalCountRows = m._customKeyArea.getChildCount() - 1

    m._islastRowColumnFull = true

    if m._customKeyArea.getChild(m._totalCountRows).getChildCount() < m._rowButtonsLength
        m._islastRowColumnFull = false
    end if 

    m.top.observeFieldScoped("focusedChild" , "_onFocusedChild")
end sub

sub _onFocusedChild()
    if m.top.hasFocus() then m._customKeyArea.getChild(0).getChild(0).setFocus(true)
end sub

sub _onButtonClearSelected()
    m._textEditBox.text = ""
end sub

sub _onButtonSpaceSelected()
    m._textEditBox.text = m._textEditBox.text + " "
end sub

sub _onButtonEnterSelected()
    onActionResponse(m._textEditBox.text)
    m._textEditBox.text = ""
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "options"
            if m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).hasFocus() = true
                m._textEditBox.text = m._textEditBox.text + m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).text
            end if
        else if key = "right"
            m._currentColumn++
            if m._islastRowColumnFull = false AND m._currentRow = m._totalCountRows AND m._currentColumn = m._customKeyArea.getChild(m._currentRow).getChildCount()
                m._currentColumn = 0
            end if
            if m._currentColumn = m._totalCountRows then m._currentColumn = 0
            m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).setFocus(true)
            result = true
        else if key = "left"
            m._currentColumn--
            if m._islastRowColumnFull = false AND m._currentColumn < 0 AND m._currentRow = m._totalCountRows
                m._currentColumn = m._customKeyArea.getChild(m._currentRow).getChildCount() - 1
            end if
            if m._currentColumn < 0 then m._currentColumn = m._rowButtonsLength - 1
            m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).setFocus(true)
            result = true
        else if key = "up"
            m._currentRow--
            if m._currentRow < 0 
                m._currentRow = 7
                m._controlKeyArea.getChild(m._currentRow - 5).setFocus(true)
            else if m._currentRow <= m._totalCountRows
                m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).setFocus(true)
            else if m._currentRow > m._totalCountRows
                m._controlKeyArea.getChild(m._currentRow - 5).setFocus(true)
            end if
            result = true
        else if key = "down"
            m._currentRow++
            if m._currentRow = m._totalCountRows AND m._currentColumn > m._customKeyArea.getChild(m._currentRow).getChildCount() - 1
                m._currentColumn = m._customKeyArea.getChild(m._currentRow).getChildCount() - 1
            end if
            if m._currentRow > m._totalCountRows + 3
                m._currentRow = 0
                m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).setFocus(true)
            else if m._currentRow > m._totalCountRows
                m._controlKeyArea.getChild(m._currentRow - 5).setFocus(true)
            else if m._currentRow <= m._totalCountRows
                m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).setFocus(true)
            end if
            result = true
        end if
    end if
    return result
end function