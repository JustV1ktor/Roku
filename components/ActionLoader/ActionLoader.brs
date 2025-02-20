sub init()
    _findAndPopulate()
end sub

sub _findAndPopulate()
    firstRectangleAnimation = m.top.findNode("firstRectangleAnimation")
    m._secondRectangleAnimation = m.top.findNode("secondRectangleAnimation")
    m._thirdRectangleAnimation = m.top.findNode("thirdRectangleAnimation")
    m._fourthRectangleAnimation = m.top.findNode("fourthRectangleAnimation")
    m._fifthRectangleAnimation = m.top.findNode("fifthRectangleAnimation")

    firstRectangleAnimation.control = "start"

    m._secondAnimationStartTimer = CreateObject("roSGNode", "timer")
    m._thirdAnimationStartTimer = CreateObject("roSGNode", "timer")
    m._fourthAnimationStartTimer = CreateObject("roSGNode", "timer")
    m._fifthAnimationStartTimer = CreateObject("roSGNode", "timer")

    m._secondAnimationStartTimer.duration = 0.3
    m._thirdAnimationStartTimer.duration = 0.6
    m._fourthAnimationStartTimer.duration = 0.9
    m._fifthAnimationStartTimer.duration = 1.2

    m._secondAnimationStartTimer.observeFieldScoped("fire", "secondAnimationStart")
    m._thirdAnimationStartTimer.observeFieldScoped("fire", "thirdAnimationStart")
    m._fourthAnimationStartTimer.observeFieldScoped("fire", "fourthAnimationStart")
    m._fifthAnimationStartTimer.observeFieldScoped("fire", "fifthAnimationStart")

    m._secondAnimationStartTimer.control = "start"
    m._thirdAnimationStartTimer.control = "start"
    m._fourthAnimationStartTimer.control = "start"
    m._fifthAnimationStartTimer.control = "start"

    m.top.setFocus(true)
end sub

sub secondAnimationStart()
    m._secondRectangleAnimation.control = "start"
end sub

sub thirdAnimationStart()
    m._thirdRectangleAnimation.control = "start"
end sub

sub fourthAnimationStart()
    m._fourthRectangleAnimation.control = "start"
end sub

sub fifthAnimationStart()
    m._fifthRectangleAnimation.control = "start"
end sub
