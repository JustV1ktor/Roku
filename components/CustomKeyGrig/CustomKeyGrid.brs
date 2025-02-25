sub init()
    _findAndPopulate()
end sub

sub _findAndPopulate()
    m._customKeyArea = m.top.findNode("customKeyArea")
    m._textEditBox = m.top.findNode("textEditBox")
    arrayKeysText = ["1","2","3","4","5","6","7","8","9","0","a","v","q","w","u","r","g","d","A","Clear","Space","Enter"]
    
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
        m._customKeyArea.getChild(numRows).getChild(numButtons).text = item
        numButtons++
    end for

    totalCountRows = m._customKeyArea.getChildCount() - 1

    m._islastRowColumnFull = true

    if m._customKeyArea.getChild(totalCountRows).getChildCount() < m._rowButtonsLength
        m._islastRowColumnFull = false
        m._lastRowColumnCount = m._customKeyArea.getChild(totalCountRows).getChildCount() - 1
    end if 

    m.top.observeFieldScoped("focusedChild" , "_onFocusedChild")
end sub

sub _onFocusedChild()
    if m.top.hasFocus() then m._customKeyArea.getChild(0).getChild(0).setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "options"
            if m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).hasFocus() = true AND m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).text = "Clear"
                m._textEditBox.text = ""
            else if m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).hasFocus() = true AND m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).text = "Space"
                m._textEditBox.text = m._textEditBox.text + " "
            else if m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).hasFocus() = true AND m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).text = "Enter"
                onActionResponse(m._textEditBox.text)
                m._textEditBox.text = ""
            else if m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).hasFocus() = true
                m._textEditBox.text = m._textEditBox.text + m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).text
            end if
            result = true
        else if key = "right"
            m._currentColumn++
            if m._currentColumn = m._rowButtonsLength then m._currentColumn = 0
            result = true
        else if key = "left"
            m._currentColumn--
            if m._currentColumn = -1 then m._currentColumn = m._rowButtonsLength -1
            result = true
        else if key = "up"
            m._currentRow--
            if m._currentRow = -1 then m._currentRow = m._customKeyArea.getChildCount() - 1
            result = true
        else if key = "down"
            m._currentRow++
            if m._currentRow = m._customKeyArea.getChildCount() then m._currentRow = 0
            result = true
        end if
    end if
    
    if m._islastRowColumnFull = false AND m._currentRow = m._customKeyArea.getChildCount() - 1 AND m._currentColumn > m._lastRowColumnCount then m._currentColumn = m._lastRowColumnCount

    m._customKeyArea.getChild(m._currentRow).getChild(m._currentColumn).setFocus(true)

    return result
end function