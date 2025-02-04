sub init()
    findANdPopulate()
    setElementsTranslation()
end sub

sub findANdPopulate()
    m.poster = m.top.findNode("photoPoster")
    m.title = m.top.findNode("titleText")
    m.description = m.top.findNode("descriptionText")
    m.rowList = m.top.findNode("rowList")
    m.averageRating = m.top.findNode("averageRating")
    m.releaseDate = m.top.findNode("releaseDate")

    m.contentRead = CreateObject("roSGNode", "contentReader")
    m.contentRead.observeField("content", "setcontent")
    m.contentRead.contenturi = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=true&language=en-US&page=1&sort_by=popularity.desc"
    m.contentRead.control = "run"

    m.dialog = CreateObject("roSGNode", "customDialog")
    
    m.dialog.dialogTitleText = "title Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vitae tortor purus. Mauris ultrices rutrum nunc eu sollicitudin. Sed congue augue sed tempus vulputate. Integer ultricies ligula eget semper interdum. Mauris a tristique urna. Sed dignissim, diam ac gravida iaculis, eros arcu elementum dolor, eu malesuada velit mauris ac metus. Proin feugiat pellentesque mi vel semper. Quisque eget arcu ligula. Aenean porta eu ipsum sed molestie. Vestibulum accumsan efficitur ipsum eu egestas. Vivamus sed dui ultrices, ultrices sapien eget, vestibulum nunc."
    m.dialog.dialogDescriptionText = "description Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vitae tortor purus. Mauris ultrices rutrum nunc eu sollicitudin. Sed congue augue sed tempus vulputate. Integer ultricies ligula eget semper interdum. Mauris a tristique urna. Sed dignissim, diam ac gravida iaculis, eros arcu elementum dolor, eu malesuada velit mauris ac metus. Proin feugiat pellentesque mi vel semper. Quisque eget arcu ligula. Aenean porta eu ipsum sed molestie. Vestibulum accumsan efficitur ipsum eu egestas. Vivamus sed dui ultrices, ultrices sapien eget, vestibulum nunc."
    m.dialog.dialogButtonsText = ["accept!", "cancel?", "third button"]

    m.rowList.observeField("rowItemFocused", "checkAndPopulateElements")
end sub

sub setcontent()
    m.rowList.content = m.contentRead.content

    firstElement = m.rowList.content.getChild(0).getChild(0)
    m.poster.uri = firstElement.HDPosterUrl
    m.title.text = firstElement.title
    m.description.text = firstElement.description
    m.averageRating.text = firstElement.averageRating
    m.releaseDate.text = firstElement.releaseDate
end sub

sub setElementsTranslation()
    m.poster.update({
        width:  (1920 / 2) - 10,
        height: (1080 / 2) - 10
    }, true)

    m.title.update({
        width:  ((1920 / 2) - 10),
    }, true)

    m.averageRating.update({
        width:  (((1920 / 2) / 2) - 10)
    }, true)

    m.releaseDate.update({
        width:  (((1920 / 2) / 2) - 10)
    }, true)

    m.description.update({
        width:  ((1920 / 2) - 10),
        height: ((1080 / 2) - 10) - m.title.boundingRect().height - m.averageRating.boundingRect().height
    }, true)
end sub

sub checkAndPopulateElements(event)
    indices = event.getData()
    itemContent = m.rowList.content.getChild(indices[0]).getChild(indices[1])
    m.poster.update ({
        uri: itemContent.HDPosterUrl
    })
    
    m.title.update ({
        text: itemContent.title
    })

    m.description.update ({
        text: itemContent.description
    })

    m.averageRating.update ({
        text: "Average Rating: " + itemContent.averageRating.toStr()
    })

    m.releaseDate.update ({
        text: "Release date: " + itemContent.releaseDate.toStr()
    })

end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "options"
            m.top.appendChild(m.dialog)
            m.dialog.dialogButtonsSetFocus = true
            m.dialog.setFocus(true)
            result = true
        else if key = "replay"
            m.top.removeChild(m.dialog)
            m.dialog.dialogButtonsSetFocus = false
            m.rowList.setFocus(true)
            result = true
        end if
    end if
    return result
end function