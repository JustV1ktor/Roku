sub init()
    setKeys()
end sub

sub setKeys()
    m.mainArea = m.top.findNode("mainArea")
    m.arrayKeysText = ["1","2","3","4","5","6","7","8","9","0","a","v","q","w","u","r","g","d","A"]
    
    m.rowButtonsLength = 4

    m.currentRow = 0
    m.currentColumn = 0

    m.numRows = 0
    numButtons = 0

    m.mainArea.createChild("LayoutGroup")
    m.mainArea.getChild(m.numRows).layoutDirection = "horiz"

    for each item in m.arrayKeysText
        if m.mainArea.getChild(m.numRows).getChildCount() = m.rowButtonsLength
            m.mainArea.createChild("LayoutGroup")
            m.numRows++
            m.mainArea.getChild(m.numRows).layoutDirection = "horiz"
            numButtons = 0
        end if

        m.mainArea.getChild(m.numRows).createChild("Button")
        m.mainArea.getChild(m.numRows).getChild(numButtons).text = item
        numButtons++
    end for

    createdRows = m.mainArea.getChildCount() - 1

    m.islastRowColumnFull = true

    if m.mainArea.getChild(createdRows).getChildCount() - 1 < m.rowButtonsLength - 1
        m.islastRowColumnFull = false
        m.lastRowColumnCount = m.mainArea.getChild(createdRows).getChildCount() - 1
    end if 

    m.top.observeField("focusedChild" , "onFocusedChild")
end sub

sub onFocusedChild(event)
    if m.top.hasFocus() then m.mainArea.getChild(0).getChild(0).setFocus(true)
end sub

sub onActionResponse(keyText)
    m.timer = CreateObject("roSGNode", "timer")
    m.timer.duration = 3
    m.timer.observeFieldScoped("fire" , "onActionEnd")

    m.labelLayout = CreateObject("roSGNode", "LayoutGroup")
    m.labelLayout.update({
        translation: [960, 540],
        horizAlignment: "center",
        vertAlignment: "center"
    }, true)

    m.shadowLayout = CreateObject("roSGNode", "LayoutGroup")
    m.shadowLayout.update({
        translation: [960, 540],
        horizAlignment: "center",
        vertAlignment: "center"
    }, true)

    m.label = CreateObject("roSGNode", "label")
    m.label.update({
        text: keyText,
        horizAlign: "center",
        vertAlign: "center"
    }, true)

    m.shadow = CreateObject("roSGNode", "Rectangle")

    m.shadow.update({
        color: "0x000000AA",
        blendingEnabled: "true",
        width: m.label.boundingRect().width + 25,
        height: m.label.boundingRect().height + 25
    },true)

    m.labelLayout.insertChild(m.label, 0)
    m.shadowLayout.insertChild(m.shadow, 0)
    m.top.appendChild(m.shadowLayout)
    m.top.appendChild(m.labelLayout)
    m.timer.control = "start"
end sub

sub onActionEnd()
    m.timer.unObserveFieldScoped("fire")
    m.top.removeChild(m.timer)
    m.top.removeChild(m.labelLayout)
    m.top.removeChild(m.shadowLayout)
    m.timer = invalid
    m.labelLayout = invalid
    m.shadowLayout = invalid

    m.isResponseDialogOpened = false
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "options"
            if m.mainArea.getChild(m.currentRow).getChild(m.currentColumn).hasFocus() = true
                onActionResponse(m.mainArea.getChild(m.currentRow).getChild(m.currentColumn).text)
            end if
        else if key = "right"
            m.currentColumn++
            if m.currentColumn = m.rowButtonsLength then m.currentColumn = 0
            result = true
        else if key = "left"
            m.currentColumn--
            if m.currentColumn = -1 then m.currentColumn = m.rowButtonsLength -1
            result = true
        else if key = "up"
            m.currentRow--
            if m.currentRow = -1 then m.currentRow = m.mainArea.getChildCount() - 1
            result = true
        else if key = "down"
            m.currentRow++
            if m.currentRow = m.mainArea.getChildCount() then  m.currentRow = 0
            result = true
        end if
    end if
    
    if m.islastRowColumnFull = false AND m.currentRow = m.mainArea.getChildCount() - 1 AND m.currentColumn > m.lastRowColumnCount
            m.currentColumn = m.lastRowColumnCount
    end if 

    m.mainArea.getChild(m.currentRow).getChild(m.currentColumn).setFocus(true)

    return result
end function