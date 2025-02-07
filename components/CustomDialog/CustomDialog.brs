sub init()
    findAndPopulate()
end sub

sub findAndPopulate()
    m.backGroundLayout = m.top.findNode("backGroundLayout")
    m.backGroundDialog = m.top.findNode("backGroundDialog")
    m.dialogElement = m.top.findNode("dialogElement")
    m.sideCard = m.top.findNode("sideCard")
    m.mainDialogElement = m.top.findNode("mainDialogElement")
    m.dialogShadow = m.top.findNode("dialogShadow")
    m.devider = m.top.findNode("devider")

    m.firstButton = m.top.findNode("firstButton")
    m.secondButton = m.top.findNode("secondButton")
    m.firstButton.observeField("buttonSelected", "onFirstButtonSelected")
    m.secondButton.observeField("buttonSelected", "onSecondButtonSelected")

    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.backGroundLayout.translation = [960, 540]
    m.mainDialogElement.translation = [960 - (m.mainDialogElement.itemSpacings[0] / 2), 540]
    m.top.observeField("focusedChild" , "onFocusedChild")
end sub

sub onFocusedChild(event)
    focusedChild = event.getData()
    if m.top.hasFocus() then m.firstButton.setFocus(true)
end sub

sub onFirstButtonSelected()
    onActionStart("success!")
end sub

sub onSecondButtonSelected()
    onActionStart("canceled")
end sub

sub onActionStart(labeltext)
    m.timer = CreateObject("roSGNode", "timer")
    m.timer.duration = 10
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
        text: labeltext,
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
end sub

sub setButtonsDialog()
    m.firstButton.text = m.top.buttonsText[0]
    m.secondButton.text = m.top.buttonsText[1]
    
    setShadowAndBackGroundBoundingRect()
end sub

sub setShadowAndBackGroundBoundingRect()
    m.backGroundDialog.setFields({
        width: m.dialogElement.boundingRect().width + m.mainDialogElement.itemSpacings[0] * 2,
        height: m.dialogElement.boundingRect().height * 1.2
    })

    m.dialogShadow.setFields({
        width: m.backGroundDialog.width + 25,
        height: m.backGroundDialog.height + 25
    })

    m.backGroundLayout.translation = [960 + m.dialogElement.translation[0] - (m.mainDialogElement.itemSpacings[0] / 2), 540]

    if m.sideCard.loadStatus = "ready"
        setBoundingRect()
    else
        m.sideCard.observeField("loadStatus" , "setSideCardBoundingRect")
    end if
    m.dialogElement.observeField("translation" , "setbackGroundLayoutOffset")
end sub

sub setSideCardBoundingRect(event)
    if event.getData() = "ready"
        setBoundingRect()
        m.sideCard.unobserveField("loadStatus")
    end if
end sub

sub setBoundingRect()
    m.sideCard.setFields({
        width: m.sideCard.bitmapWidth * (m.backGroundDialog.height / m.sideCard.bitmapHeight),
        height: m.backGroundDialog.height,
        loadWidth: m.sideCard.bitmapWidth * (m.backGroundDialog.height / m.sideCard.bitmapHeight),
        LoadHeight: m.backGroundDialog.height
    })

    m.dialogShadow.width = m.sideCard.width + m.backGroundDialog.width + 25
end sub

sub setbackGroundLayoutOffset()
    m.backGroundLayout.translation = [960 + m.dialogElement.translation[0] - (m.mainDialogElement.itemSpacings[0] / 2), 540]
    m.backGroundLayout.unobserveField("translation")
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "right"
            m.secondButton.setFocus(true)
            result = true
        else if key = "left"
            m.firstButton.setFocus(true)
            result = true
        end if
    end if
    return result
end function
