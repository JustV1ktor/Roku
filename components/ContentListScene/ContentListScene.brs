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

    m.isResponseDialogOpened = false
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

    m.description.width = (1920 / 2) - 10

    m.averageRating.width =  ((1920 / 2) / 2) - 10

    m.releaseDate.width = ((1920 / 2) / 2) - 10
end sub

sub checkAndPopulateElements(event)
    indices = event.getData()
    itemContent = m.rowList.content.getChild(indices[0]).getChild(indices[1])
    m.poster.uri = itemContent.HDPosterUrl
    
    m.title.text = itemContent.title

    m.description.height = ((1080 / 2) - 10) - m.title.boundingRect().height - m.averageRating.boundingRect().height - m.devider.height - (20 * 3)

    m.description.text = itemContent.description

    m.averageRating.text = "Average Rating: " + itemContent.averageRating.toStr()

    m.releaseDate.text = "Release date: " + itemContent.releaseDate.toStr()
end sub

sub onActionResponse(event)
    removeDialog()
    m.isResponseDialogOpened = true

    m.timer = CreateObject("roSGNode", "timer")
    m.timer.duration = 10
    m.timer.observeFieldScoped("fire" , "onActionEnd")

    m.labelLayout = CreateObject("roSGNode", "LayoutGroup")
    m.labelLayout.update({
        translation: [960, 540],
        horizAlignment: "center",
        vertAlignment: "center"
    }, true)

    m.shadowLayout = CreateObject("roSGNode", "LayoutGroup")
    m.shadowLayout.update({
        translation: [960, 540],
        horizAlignment: "center",
        vertAlignment: "center"
    }, true)

    m.label = CreateObject("roSGNode", "label")
    m.label.update({
        text: event.getData(),
        horizAlign: "center",
        vertAlign: "center"
    }, true)

    m.shadow = CreateObject("roSGNode", "Rectangle")

    m.shadow.update({
        color: "0x000000AA",
        blendingEnabled: "true",
        width: m.label.boundingRect().width + 25,
        height: m.label.boundingRect().height + 25
    },true)

    m.labelLayout.insertChild(m.label, 0)
    m.shadowLayout.insertChild(m.shadow, 0)
    m.top.appendChild(m.shadowLayout)
    m.top.appendChild(m.labelLayout)
    m.timer.control = "start"
end sub

sub onActionEnd()
    m.timer.unObserveFieldScoped("fire")
    m.top.removeChild(m.timer)
    m.top.removeChild(m.labelLayout)
    m.top.removeChild(m.shadowLayout)
    m.timer = invalid
    m.labelLayout = invalid
    m.shadowLayout = invalid

    m.isResponseDialogOpened = false
end sub

sub appendDialog()
    m.dialog = CreateObject("roSGNode", "CustomDialog")
    
    m.dialog.observeField("action", "onActionResponse")
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
            if m.isResponseDialogOpened = false then appendDialog()
            result = true
        else if key = "replay"
            removeDialog()
            result = true
        end if
    end if
    return result
end function