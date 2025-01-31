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
        width:  ((1920 / 2) - 10)
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