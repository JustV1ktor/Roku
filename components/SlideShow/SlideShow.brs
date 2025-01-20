sub init()
    m.buttonPrevious = m.top.findNode("buttonPrevious")
    m.buttonNext = m.top.findNode("buttonNext")
    m.buttonSlideShow = m.top.findNode("buttonSlideShow")

    m.buttonPrevious.observeField("buttonSelected", "previousPhoto")
    m.buttonNext.observeField("buttonSelected", "nextPhoto")
    m.buttonSlideShow.observeField("buttonSelected", "slideShow")

    m.poster = m.top.findNode("posterPhoto")

    layoutGroup = m.top.findNode("layoutGroup")

    m.rectangleOne = m.top.findNode("RectangleOne")
    m.rectangleTwo = m.top.findNode("RectangleTwo")
    m.rectangleThree = m.top.findNode("RectangleThree")
    m.rectangleFour = m.top.findNode("RectangleFour")

    m.timer = m.top.findNode("timer")
    m.timer.observeField("fire", "photoChanges")
    
    m.poster.width = (1920 / 2) - 10
    m.poster.height = (1080 / 2) - 10

    m.rectangleOne.width = (1920 - (10 * 4)) / 4
    m.rectangleOne.height = (1080 - (10 * 2)) / 2

    buttonHeight = ((1080 / 2) - 10) / 3
    buttonWidth = (1920 / 2) - 10

    m.buttonNext.height = buttonHeight
    m.buttonPrevious.height = buttonHeight
    m.buttonSlideShow.height = buttonHeight

    m.buttonNext.minWidth = buttonWidth
    m.buttonPrevious.minWidth = buttonWidth
    m.buttonSlideShow.minWidth = buttonWidth

    m.buttons = [m.buttonSlideShow, m.buttonNext, m.buttonPrevious]
    m.photoArray = ["https://cdn.prod.website-files.com/5c6e81f1e965e241a716e966/62e146c34dc6c09ece83d45a_mini%20squares.jpg", 
                    "https://cdn.prod.website-files.com/5c6e81f1e965e241a716e966/60643a544c49f8681ee33326_Mini%20Prints%205x5cm.jpg", 
                    "https://inkifi.com/media/wysiwyg/small-photo-prints-3.jpg", 
                    "https://www.images.photojaanic.com/in/2022/productpage/prints/mini-prints/mini-prints01.jpg"]
    m.colorsArray = ["0x000088FF", "0x888888FF", "0x000000FF", "0x880000FF", "0x880088FF", "0x0000821D", "0x888B00FF", "0x000888FF", "0x888800FF", "0x008888FF"]
    m.rectangles = [m.rectangleOne, m.rectangleTwo, m.rectangleThree, m.rectangleFour]

    m.time = 0
    m.currentButton = 2
    m.currentPhoto = 0
end sub

sub previousPhoto()
    m.timer.control = "stop"
    m.currentPhoto = m.currentPhoto - 1
    if m.currentPhoto = -1
        m.currentPhoto = 3
    end if
    m.poster.uri = m.photoArray[m.currentPhoto]
end sub

sub nextPhoto()
    m.timer.control = "stop"
    m.currentPhoto = m.currentPhoto + 1
    if m.currentPhoto = 4
        m.currentPhoto = 0
    end if
    m.poster.uri = m.photoArray[m.currentPhoto]
end sub

sub slideShow()
    m.timer.control = "start"
end sub

sub photoChanges()
    m.currentPhoto = m.currentPhoto + 1
    if m.currentPhoto = 4
        m.currentPhoto = 0
    end if
    m.poster.uri = m.photoArray[m.currentPhoto]
    for each rectangle in m.rectangles
        random = Rnd(10)
        if random = 10
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