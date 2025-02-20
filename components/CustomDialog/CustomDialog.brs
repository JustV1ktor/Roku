sub init()
    _findAndPopulate()
end sub

sub _findAndPopulate()
    m._backGroundLayout = m.top.findNode("backGroundLayout")
    m._backGroundDialog = m.top.findNode("backGroundDialog")
    m._dialogElement = m.top.findNode("dialogElement")
    m._sideCard = m.top.findNode("sideCard")
    m._mainDialogElement = m.top.findNode("mainDialogElement")
    m._dialogShadow = m.top.findNode("dialogShadow")

    m._firstButton = m.top.findNode("firstButton")
    m._secondButton = m.top.findNode("secondButton")
    
    m._firstButton.observeFieldScoped("buttonSelected", "_onFirstButtonSelected")
    m._secondButton.observeFieldScoped("buttonSelected", "_onSecondButtonSelected")

    m._mainDialogElement.translation = [960 - (m._mainDialogElement.itemSpacings[0] / 2), 540]
    m.top.observeFieldScoped("focusedChild" , "_onFocusedChild")
end sub

sub _onFocusedChild()
    if m.top.hasFocus() then m._firstButton.setFocus(true)
end sub

sub _onFirstButtonSelected()
    m.top.action = "success!"
end sub

sub _onSecondButtonSelected()
    m.top.action = "canceled"
end sub

sub setElements()
    m._firstButton.text = m.top.buttonsText[0]
    m._secondButton.text = m.top.buttonsText[1]

    m._backGroundDialog.setFields({
        width: m._dialogElement.boundingRect().width + m._mainDialogElement.itemSpacings[0] * 2,
        height: m._dialogElement.boundingRect().height * 1.2
    })

    m._dialogShadow.setFields({
        width: m._backGroundDialog.width + 25,
        height: m._backGroundDialog.height + 25
    })

    m._backGroundLayout.translation = [960 + m._dialogElement.translation[0] - (m._mainDialogElement.itemSpacings[0] / 2), 540]

    if m._sideCard.loadStatus = "ready" then _setBoundingRect() else m._sideCard.observeFieldScoped("loadStatus" , "_setSideCardBoundingRect")
    m._dialogElement.observeFieldScoped("translation" , "_setbackGroundLayoutOffset")
end sub

sub _setSideCardBoundingRect(event)
    if event.getData() = "ready"
        _setBoundingRect()
        m._sideCard.unobserveFieldScoped("loadStatus")
    end if
end sub

sub _setBoundingRect()
    m._sideCard.setFields({
        width: m._sideCard.bitmapWidth * (m._backGroundDialog.height / m._sideCard.bitmapHeight),
        height: m._backGroundDialog.height,
        loadWidth: m._sideCard.bitmapWidth * (m._backGroundDialog.height / m._sideCard.bitmapHeight),
        LoadHeight: m._backGroundDialog.height
    })

    m._dialogShadow.width = m._sideCard.width + m._backGroundDialog.width + 25
end sub

sub _setbackGroundLayoutOffset()
    m._backGroundLayout.translation = [960 + m._dialogElement.translation[0] - (m._mainDialogElement.itemSpacings[0] / 2), 540]
    m._backGroundLayout.unobserveFieldScoped("translation")
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "right"
            m._secondButton.setFocus(true)
            result = true
        else if key = "left"
            m._firstButton.setFocus(true)
            result = true
        end if
    end if
    return result
end function
