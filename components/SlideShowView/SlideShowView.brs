sub init()
    findAndObserveNodes()
    setElementsTranslation()

    m.photoArray = rawPhoto()
    m.colorsArray = rawColors()

    m.poster.setField("uri", m.photoArray[0])

    m.buttons = [m.buttonSlideShow, m.buttonNext, m.buttonPrevious]
    m.rectangles = [m.rectangleOne, m.rectangleTwo, m.rectangleThree, m.rectangleFour]

    m.time = 0
    m.currentButton = 2
    m.currentPhoto = 0
end sub

sub findAndObserveNodes()
    m.buttonPrevious = m.top.findNode("buttonPrevious")
    m.buttonNext = m.top.findNode("buttonNext")
    m.buttonSlideShow = m.top.findNode("buttonSlideShow")

    m.buttonPrevious.observeField("buttonSelected", "onPreviousButtonSelected")
    m.buttonNext.observeField("buttonSelected", "onNextButtonSelected")
    m.buttonSlideShow.observeField("buttonSelected", "onSlideShowButtonSelected")

    m.poster = m.top.findNode("posterPhoto")

    m.rectangleOne = m.top.findNode("RectangleOne")
    m.rectangleTwo = m.top.findNode("RectangleTwo")
    m.rectangleThree = m.top.findNode("RectangleThree")
    m.rectangleFour = m.top.findNode("RectangleFour")

    m.timer = m.top.findNode("timer")
    m.timer.observeField("fire", "onFirePhotoChanges")
end sub

sub setElementsTranslation()
    m.poster.update({
        width:  (1920 / 2) - 10,
        height: (1080 / 2) - 10
    }, true)

    rectangleWidth = (1920 - (10 * 4)) / 4
    rectangleheight = (1080 - (10 * 2)) / 2

    m.rectangleOne.update({
        width: rectangleWidth,
        height: rectangleheight
    }, true)
    m.rectangleTwo.update({
        width: rectangleWidth,
        height: rectangleheight
    }, true)
    m.rectangleThree.update({
        width: rectangleWidth,
        height: rectangleheight
    }, true)
    m.rectangleFour.update({
        width: rectangleWidth,
        height: rectangleheight
    }, true)
    

    buttonHeight = ((1080 / 2) - 10) / 3
    buttonWidth = (1920 / 2) - 10

    m.buttonNext.update({
        minWidth: buttonWidth,
        height: buttonHeight
    }, true)
    m.buttonPrevious.update({
        minWidth: buttonWidth,
        height: buttonHeight
    }, true)
    m.buttonSlideShow.update({
        minWidth: buttonWidth,
        height: buttonHeight
    }, true)
end sub

sub onPreviousButtonSelected()
    m.timer.control = "stop"
    m.currentPhoto = m.currentPhoto - 1
    if m.currentPhoto = -1
        m.currentPhoto = m.photoArray.Count() - 1
    end if
    m.poster.uri = m.photoArray[m.currentPhoto]
end sub

sub onNextButtonSelected()
    m.timer.control = "stop"
    m.currentPhoto = m.currentPhoto + 1
    if m.currentPhoto >= m.photoArray.Count()
        m.currentPhoto = 0
    end if
    m.poster.uri = m.photoArray[m.currentPhoto]
end sub

sub onSlideShowButtonSelected()
    m.timer.control = "start"
end sub

sub onFirePhotoChanges()
    m.currentPhoto = m.currentPhoto + 1
    if m.currentPhoto = m.photoArray.Count()
        m.currentPhoto = 0
    end if
    m.poster.uri = m.photoArray[m.currentPhoto]
    for each rectangle in m.rectangles
        random = Rnd(m.colorsArray.Count())
        if random = m.colorsArray.Count()
            random = 0
        end if
        rectangle.color = m.colorsArray[random]
    end for
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "up"
            if NOT m.currentButton = 2
                m.currentButton = m.currentButton + 1
                m.buttons[m.currentButton].setFocus(true)
            end if
        else if key = "down"
            if NOT m.currentButton = 0
                m.currentButton = m.currentButton - 1
                m.buttons[m.currentButton].setFocus(true)
            end if
        end if
    end if
    return result
end function