sub init()
    backGroundLayout = m.top.findNode("backGroundLayout")
    m.backGroundDialog = m.top.findNode("backGroundDialog")
    m.dialogElement = m.top.findNode("dialogElement")

    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.buttonGroup = m.top.findNode("buttonGroup")
    backGroundLayout.translation = [960, 540]
    m.dialogElement.translation = [960, 540]
    m.buttonGroup.setFocus(true)
end sub

sub setTextDialog() 
    if m.top.dialogDescriptionText.len() > 132 OR m.top.dialogTitleText.len() > 52
        m.title.width = "800"
        m.description.width = "800"
    end if

    m.title.text = m.top.dialogTitleText
    m.description.text = m.top.dialogDescriptionText
end sub

sub setButtonsDialog()
    result = m.top.dialogButtonsText
    if result.count() > 2
        while result.count() >= 3
            result.pop()
        end while
    end if

    m.buttonGroup.buttons = result

    setBoundingRect()
end sub

sub setBoundingRect()
    m.backGroundDialog.setFields({
        uri: "pkg:/images/rsgde_dlg_bg_hd.9.png"
        width: m.dialogElement.boundingRect().width * 1.2,
        height: m.dialogElement.boundingRect().height * 1.2,
        loadWidth: m.dialogElement.boundingRect().width * 1.2,
        loadHeight: m.dialogElement.boundingRect().height * 1.2,
        loadDisplayMode: "scaleToFill"
    })
end sub

sub setDialogButtonsFocus()
    m.buttonGroup.setFocus(m.top.dialogButtonsSetFocus)
end sub

' function onKeyEvent(key as String, press as Boolean) as Boolean
'     result = false
'     if press 
'         if key = "options"
'             m.buttonGroup.setFocus(true)
'             result = true
'         end if
'     end if
'     return result
' end function