sub onActionResponse(event)
    if type(event) = "roSGNodeEvent"
        textToShow = event.getData()
    else
        textToShow = event
    end if
    m.isResponseDialogOpened = true

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
        text: textToShow,
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