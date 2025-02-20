sub init()
    _findAndPopulate()
end sub

sub _findAndPopulate()
    m._poster = m.top.findNode("poster")
    m._title = m.top.findNode("title")
    m._description = m.top.findNode("description")
    m._rowList = m.top.findNode("rowList")
    m._averageRating = m.top.findNode("averageRating")
    m._releaseDate = m.top.findNode("releaseDate")
    m._devider = m.top.findNode("devider")

    _getContent()

    m._isActionLoaderOpened = false
    m._isResponseDialogOpened = false
    m._poster.observeFieldScoped("loadStatus", "_showActionLoader")
    m._rowList.observeFieldScoped("rowItemFocused", "_checkAndPopulateElements")

    m._poster.update({
        width:  (1920 / 2) - 10,
        height: (1080 / 2) - 10
    }, true)

    m._title.width = (1920 / 2) - 10

    m._devider.width = (1920 / 2) - 10

    m._description.width = (1920 / 2) - 10

    m._averageRating.width =  ((1920 / 2) / 2) - 10

    m._releaseDate.width = ((1920 / 2) / 2) - 10
end sub

sub _getContent()
    m._contentRead = CreateObject("roSGNode", "ContentReader")
    m._contentRead.observeFieldScoped("content", "_setContent")
    m._contentRead.contenturi = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=true&language=en-US&page=1&sort_by=popularity.desc"
    m._contentRead.control = "run"
end sub

sub _setContent()
    m._rowList.content = m._contentRead.content

    firstElement = m._rowList.content.getChild(0).getChild(0)
    m._poster.uri = firstElement.HDPosterUrl
    m._title.text = firstElement.title
    m._description.text = firstElement.description
    m._averageRating.text = firstElement.averageRating
    m._releaseDate.text = firstElement.releaseDate
end sub

sub _showActionLoader(event)
    m._isActionLoaderOpened = true
    if event.getData() = "loading"
        m.top.isLoading = true
    else if event.getData() = "ready"
        m.top.isLoading = false
        m._rowList.setFocus(true)
        m._isActionLoaderOpened = false
    end if
end sub

sub _checkAndPopulateElements(event)
    indices = event.getData()
    itemContent = m._rowList.content.getChild(indices[0]).getChild(indices[1])
    m._poster.uri = itemContent.HDPosterUrl
    
    m._title.text = itemContent.title

    m._description.height = ((1080 / 2) - 10) - m._title.boundingRect().height - m._averageRating.boundingRect().height - m._devider.height - (20 * 3)

    m._description.text = itemContent.description

    m._averageRating.text = "Average Rating: " + itemContent.averageRating.toStr()

    m._releaseDate.text = "Release date: " + itemContent.releaseDate.toStr()
    m.top.observeFieldScoped("focusedChild" , "_onFocusedChild")
end sub

sub _onFocusedChild()
    if m.top.hasFocus() then m._rowList.setFocus(true)
end sub

sub _appendDialog()
    m._dialog = CreateObject("roSGNode", "CustomDialog")
    
    m._dialog.observeFieldScoped("action", "_ActionResponse")
    m._dialog.title = "title Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vitae tortor purus. Mauris ultrices rutrum nunc eu sollicitudin. Sed congue augue sed tempus vulputate. Integer ultricies ligula eget semper interdum. Mauris a tristique urna. Sed dignissim, diam ac gravida iaculis, eros arcu elementum dolor, eu malesuada velit mauris ac metus. Proin feugiat pellentesque mi vel semper. Quisque eget arcu ligula. Aenean porta eu ipsum sed molestie. Vestibulum accumsan efficitur ipsum eu egestas. Vivamus sed dui ultrices, ultrices sapien eget, vestibulum nunc."
    m._dialog.description = "description Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas vitae tortor purus. Mauris ultrices rutrum nunc eu sollicitudin. Sed congue augue sed tempus vulputate. Integer ultricies ligula eget semper interdum. Mauris a tristique urna. Sed dignissim, diam ac gravida iaculis, eros arcu elementum dolor, eu malesuada velit mauris ac metus. Proin feugiat pellentesque mi vel semper. Quisque eget arcu ligula. Aenean porta eu ipsum sed molestie. Vestibulum accumsan efficitur ipsum eu egestas. Vivamus sed dui ultrices, ultrices sapien eget, vestibulum nunc."
    m._dialog.buttonsText = ["accept!", "cancel?"]

    m.top.appendChild(m._dialog)
    m._dialog.setFocus(true)
end sub

sub _ActionResponse(event)
    onActionResponse(event)
    _removeDialog()
end sub

sub _removeDialog()
    m._rowList.setFocus(true)
    m.top.removeChild(m._dialog)
    m._dialog = invalid
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "options" AND m._isActionLoaderOpened = false
            if m._isResponseDialogOpened = false then _appendDialog()
            result = true
        else if key = "replay"
            _removeDialog()
            result = true
        end if
    end if
    return result
end function
