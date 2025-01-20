sub init()
    m.top.backgroundColor = "0x662D91"
    slideShowView = CreateObject("roSGNode", "SlideShowView")
    m.top.appendChild(slideShowView)

    slideShowView.setFocus(true)
end sub