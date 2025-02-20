sub onActionResponse(event)
    if type(event) = "roSGNodeEvent" then _textToShow = event.getData() else _textToShow = event
    m._isResponseDialogOpened = true

    m._timer = CreateObject("roSGNode", "timer")
    m._timer.duration = 3
    m._timer.observeFieldScoped("fire" , "_onActionEnd")

    m._labelLayout = CreateObject("roSGNode", "LayoutGroup")
    m._labelLayout.update({
        translation: [960, 540],
        horizAlignment: "center",
        vertAlignment: "center"
    }, true)

    m._shadowLayout = CreateObject("roSGNode", "LayoutGroup")
    m._shadowLayout.update({
        translation: [960, 540],
        horizAlignment: "center",
        vertAlignment: "center"
    }, true)

    label = CreateObject("roSGNode", "Label")
    label.update({
        text: _textToShow,
        horizAlign: "center",
        vertAlign: "center"
    }, true)

    shadow = CreateObject("roSGNode", "Rectangle")
    shadow.update({
        color: "0x000000AA",
        blendingEnabled: "true",
        width: label.boundingRect().width + 25,
        height: label.boundingRect().height + 25
    },true)

    m._labelLayout.insertChild(label, 0)
    m._shadowLayout.insertChild(shadow, 0)
    m.top.appendChild(m._shadowLayout)
    m.top.appendChild(m._labelLayout)
    m._timer.control = "start"
end sub

sub _onActionEnd()
    m._timer.unObserveFieldScoped("fire")
    m.top.removeChild(m._timer)
    m.top.removeChild(m._labelLayout)
    m.top.removeChild(m._shadowLayout)
    m._timer = invalid
    m._labelLayout = invalid
    m._shadowLayout = invalid

    m._isResponseDialogOpened = false
end sub