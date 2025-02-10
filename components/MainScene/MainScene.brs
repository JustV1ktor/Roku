sub init()
    ' slideShowView = CreateObject("roSGNode", "SlideShowView")
    ' m.top.appendChild(slideShowView)

    ' slideShowView.setFocus(true)
    ContentListScene = CreateObject("roSGNode", "ContentListScene")
    m.top.appendChild(ContentListScene)

    ContentListScene.setFocus(true)
end sub