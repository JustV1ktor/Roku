sub init()
    findAndPopulate()
end sub

sub findAndPopulate()
    firstRectangleAnimation = m.top.FindNode("firstRectangleAnimation")
    m.secondRectangleAnimation = m.top.FindNode("secondRectangleAnimation")
    m.thirdRectangleAnimation = m.top.FindNode("thirdRectangleAnimation")
    m.fourthRectangleAnimation = m.top.FindNode("fourthRectangleAnimation")
    m.fifthRectangleAnimation = m.top.FindNode("fifthRectangleAnimation")

    firstRectangleAnimation.control = "start"

    m.secondAnimationStartTimer = CreateObject("roSGNode", "timer")
    m.thirdAnimationStartTimer = CreateObject("roSGNode", "timer")
    m.fourthAnimationStartTimer = CreateObject("roSGNode", "timer")
    m.fifthAnimationStartTimer = CreateObject("roSGNode", "timer")

    m.secondAnimationStartTimer.duration = 0.3
    m.thirdAnimationStartTimer.duration = 0.6
    m.fourthAnimationStartTimer.duration = 0.9
    m.fifthAnimationStartTimer.duration = 1.2

    m.secondAnimationStartTimer.observeFieldScoped("fire", "secondAnimationStart")
    m.thirdAnimationStartTimer.observeField("fire", "thirdAnimationStart")
    m.fourthAnimationStartTimer.observeField("fire", "fourthAnimationStart")
    m.fifthAnimationStartTimer.observeField("fire", "fifthAnimationStart")

    m.secondAnimationStartTimer.control = "start"
    m.thirdAnimationStartTimer.control = "start"
    m.fourthAnimationStartTimer.control = "start"
    m.fifthAnimationStartTimer.control = "start"

    m.top.setFocus(true)
end sub

sub secondAnimationStart()
    m.secondRectangleAnimation.control = "start"
end sub

sub thirdAnimationStart()
    m.thirdRectangleAnimation.control = "start"
end sub

sub fourthAnimationStart()
    m.fourthRectangleAnimation.control = "start"
end sub

sub fifthAnimationStart()
    m.fifthRectangleAnimation.control = "start"
end sub
