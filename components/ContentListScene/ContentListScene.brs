sub init()
    findANdPopulate()
    setElementsTranslation()
end sub

sub findANdPopulate()
    m.poster = m.top.findNode("photoPoster")
    m.title = m.top.findNode("titleText")
    m.description = m.top.findNode("descriptionText")
    m.rowList = m.top.findNode("rowList")

    m.rowList.content = CreateObject("roSGNode", "RowListContent")

    firstElemnt = m.rowList.content.getChild(0).getChild(0)
    m.poster.uri = firstElemnt.HDPosterUrl
    m.title.text = firstElemnt.title
    m.description.text = firstElemnt.description

    m.rowList.observeField("rowItemSelected", "checkAndPopulateElemnts")
end sub

sub setElementsTranslation()
    m.poster.update({
        width:  (1920 / 2) - 10,
        height: (1080 / 2) - 10
    }, true)

    m.title.update({
        width:  ((1920 / 2) - 10),
        height: (((1080 / 2) - 10) / 3)
    })

    m.description.update({
        width:  ((1920 / 2) - 10),
        height: (((1080 / 2) - 10) / 3) * 2
    })
end sub

sub checkAndPopulateElemnts(event)
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
end sub