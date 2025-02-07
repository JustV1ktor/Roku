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
    m.devider = m.top.findNode("devider")

    getContent()

    m.isDialogSceneOpened = false
    m.rowList.observeField("rowItemFocused", "checkAndPopulateElements")
end sub

sub getContent()
    m.contentRead = CreateObject("roSGNode", "ContentReader")
    m.contentRead.observeField("content", "setContent")
    m.contentRead.contenturi = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=true&language=en-US&page=1&sort_by=popularity.desc"
    m.contentRead.control = "run"
end sub

sub setContent()
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

    m.title.width = (1920 / 2) - 10

    m.devider.width = (1920 / 2) - 10

    m.description.update({
        width:  (1920 / 2) - 10,
        height: ((1080 / 2) - 10) - m.title.boundingRect().height - m.averageRating.boundingRect().height - m.devider.height - (20 * 3)
    }, true)

    m.averageRating.width =  ((1920 / 2) / 2) - 10

    m.releaseDate.width = ((1920 / 2) / 2) - 10
end sub

sub checkAndPopulateElements(event)
    indices = event.getData()
    itemContent = m.rowList.content.getChild(indices[0]).getChild(indices[1])
    m.poster.uri = itemContent.HDPosterUrl
    
    m.title.text = itemContent.title

    m.description.text = itemContent.description

    m.averageRating.text = "Average Rating: " + itemContent.averageRating.toStr()

    m.releaseDate.text = "Release date: " + itemContent.releaseDate.toStr()
end sub

sub appendDialog()
    m.dialog = CreateObject("roSGNode", "CustomDialog")
    
    m.dialog.title = "title Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vitae tortor purus. Mauris ultrices rutrum nunc eu sollicitudin. Sed congue augue sed tempus vulputate. Integer ultricies ligula eget semper interdum. Mauris a tristique urna. Sed dignissim, diam ac gravida iaculis, eros arcu elementum dolor, eu malesuada velit mauris ac metus. Proin feugiat pellentesque mi vel semper. Quisque eget arcu ligula. Aenean porta eu ipsum sed molestie. Vestibulum accumsan efficitur ipsum eu egestas. Vivamus sed dui ultrices, ultrices sapien eget, vestibulum nunc."
    m.dialog.description = "description Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vitae tortor purus. Mauris ultrices rutrum nunc eu sollicitudin. Sed congue augue sed tempus vulputate. Integer ultricies ligula eget semper interdum. Mauris a tristique urna. Sed dignissim, diam ac gravida iaculis, eros arcu elementum dolor, eu malesuada velit mauris ac metus. Proin feugiat pellentesque mi vel semper. Quisque eget arcu ligula. Aenean porta eu ipsum sed molestie. Vestibulum accumsan efficitur ipsum eu egestas. Vivamus sed dui ultrices, ultrices sapien eget, vestibulum nunc."
    m.dialog.buttonsText = ["accept!", "cancel?", "third button"]

    m.top.appendChild(m.dialog)
    m.dialog.setFocus(true)
end sub

sub removeDialog()
    m.rowList.setFocus(true)
    m.top.removeChild(m.dialog)
    m.dialog = invalid
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "options"
            if m.isDialogSceneOpened = false then appendDialog()
            m.isDialogSceneOpened = true
            result = true
        else if key = "replay"
            if m.isDialogSceneOpened = true then removeDialog()
            m.isDialogSceneOpened = false
            result = true
        end if
    end if
    return result
end function