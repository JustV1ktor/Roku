sub init()
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
    
    m.poster.setField("width", (1920 / 2) - 10)
    m.poster.setField("height", (1080 / 2) - 10)

    rectangleWidth = (1920 - (10 * 4)) / 4
    rectangleheight = (1080 - (10 * 2)) / 2

    m.rectangleOne.setField("width", rectangleWidth)
    m.rectangleTwo.setField("width", rectangleWidth)
    m.rectangleThree.setField("width", rectangleWidth)
    m.rectangleFour.setField("width", rectangleWidth)

    m.rectangleOne.setField("height", rectangleheight)
    m.rectangleTwo.setField("height", rectangleheight)
    m.rectangleThree.setField("height", rectangleheight)
    m.rectangleFour.setField("height", rectangleheight)

    buttonHeight = ((1080 / 2) - 10) / 3
    buttonWidth = (1920 / 2) - 10

    m.buttonNext.setField("height", buttonHeight)
    m.buttonPrevious.setField("height", buttonHeight)
    m.buttonSlideShow.setField("height", buttonHeight)
    
    m.buttonNext.setField("minWidth", buttonWidth)
    m.buttonPrevious.setField("minWidth", buttonWidth)
    m.buttonSlideShow.setField("minWidth", buttonWidth)

    m.photoArray = rawPhoto()
    m.colorsArray = rawColors()

    m.poster.setField("uri", m.photoArray[0])

    m.buttons = [m.buttonSlideShow, m.buttonNext, m.buttonPrevious]
    m.rectangles = [m.rectangleOne, m.rectangleTwo, m.rectangleThree, m.rectangleFour]

    m.time = 0
    m.currentButton = 2
    m.currentPhoto = 0
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