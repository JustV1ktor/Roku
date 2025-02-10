sub init()
    ' slideShowView = CreateObject("roSGNode", "SlideShowView")
    ' m.top.appendChild(slideShowView)

    ' slideShowView.setFocus(true)
    ContentListScene = CreateObject("roSGNode", "ContentListScene")
    m.top.appendChild(ContentListScene)

    ContentListScene.setFocus(true)

    ' CustomKeyGrid = CreateObject("roSGNode", "CustomKeyGrid")
    ' m.top.appendChild(CustomKeyGrid)

    ' CustomKeyGrid.setFocus(true)
end sub