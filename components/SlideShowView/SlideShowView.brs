sub init()
    _findAndPopulate()
end sub

sub _findAndPopulate()
    buttonPrevious = m.top.findNode("buttonPrevious")
    buttonNext = m.top.findNode("buttonNext")
    buttonSlideShow = m.top.findNode("buttonSlideShow")

    buttonPrevious.observeFieldScoped("buttonSelected", "_onPreviousButtonSelected")
    buttonNext.observeFieldScoped("buttonSelected", "_onNextButtonSelected")
    buttonSlideShow.observeFieldScoped("buttonSelected", "_onSlideShowButtonSelected")

    m._poster = m.top.findNode("poster")

    rectangleOne = m.top.findNode("rectangleOne")
    rectangleTwo = m.top.findNode("rectangleTwo")
    rectangleThree = m.top.findNode("rectangleThree")
    rectangleFour = m.top.findNode("rectangleFour")

    m._timer = m.top.findNode("timer")
    m._timer.observeFieldScoped("fire", "_onFirePhotoChanges")

    m._poster.update({
        width:  (1920 / 2) - 10,
        height: (1080 / 2) - 10
    }, true)

    rectangleWidth = (1920 - (10 * 4)) / 4
    rectangleheight = (1080 - (10 * 2)) / 2

    rectangleOne.update({
        width: rectangleWidth,
        height: rectangleheight
    }, true)
    rectangleTwo.update({
        width: rectangleWidth,
        height: rectangleheight
    }, true)
    rectangleThree.update({
        width: rectangleWidth,
        height: rectangleheight
    }, true)
    rectangleFour.update({
        width: rectangleWidth,
        height: rectangleheight
    }, true)
    
    buttonHeight = ((1080 / 2) - 10) / 3
    buttonWidth = (1920 / 2) - 10

    buttonNext.update({
        minWidth: buttonWidth,
        height: buttonHeight
    }, true)
    buttonPrevious.update({
        minWidth: buttonWidth,
        height: buttonHeight
    }, true)
    buttonSlideShow.update({
        minWidth: buttonWidth,
        height: buttonHeight
    }, true)

    m._photoArray = rawPhoto()
    m._colorsArray = rawColors()

    m._poster.setField("uri", m._photoArray[0])

    m._buttons = [buttonSlideShow, buttonNext, buttonPrevious]
    m._rectangles = [rectangleOne, rectangleTwo, rectangleThree, rectangleFour]

    m._currentButton = 2
    m._currentPhoto = 0
    m.top.observeFieldScoped("focusedChild" , "_onFocusedChild")
end sub

sub _onFocusedChild()
    if m.top.hasFocus() then m._buttons[m._currentButton].setFocus(true)
end sub

sub _onPreviousButtonSelected()
    m._timer.control = "stop"
    m._currentPhoto = m._currentPhoto - 1
    if m._currentPhoto = -1 then m._currentPhoto = m._photoArray.Count() - 1
    m._poster.uri = m._photoArray[m._currentPhoto]
end sub

sub _onNextButtonSelected()
    m._timer.control = "stop"
    m._currentPhoto = m._currentPhoto + 1
    if m._currentPhoto >= m._photoArray.Count() then m._currentPhoto = 0
    m._poster.uri = m._photoArray[m._currentPhoto]
end sub

sub _onSlideShowButtonSelected()
    m._timer.control = "start"
end sub

sub _onFirePhotoChanges()
    m._currentPhoto = m._currentPhoto + 1
    if m._currentPhoto = m._photoArray.Count() then m._currentPhoto = 0
    m._poster.uri = m._photoArray[m._currentPhoto]
    for each rectangle in m._rectangles
        random = Rnd(m._colorsArray.Count())
        if random = m._colorsArray.Count() then random = 0
        rectangle.color = m._colorsArray[random]
    end for
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "up"
            if NOT m._currentButton = 2
                m._currentButton = m._currentButton + 1
                m._buttons[m._currentButton].setFocus(true)
            end if
        else if key = "down"
            if NOT m._currentButton = 0
                m._currentButton = m._currentButton - 1
                m._buttons[m._currentButton].setFocus(true)
            end if
        end if
    end if
    return result
end function