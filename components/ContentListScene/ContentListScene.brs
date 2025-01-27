sub init()
    findANdPopulate()
    setElementsTranslation()
end sub

sub findANdPopulate()
    m.poster = m.top.findNode("photoPoster")
    m.title = m.top.findNode("titleText")
    m.description = m.top.findNode("descriptionText")
    m.rowList = m.top.findNode("rowList")


    content = CreateObject("roSGNode", "RowListContent")
    for i = 0 to content.getChildCount() - 1
        for j = 0 to content.getChild(i).getChildCount() -1
            content.getChild(i).getChild(j).addField("FHDItemWidth", "float", false)
            if j = 0 OR j = 2 OR j = 4
                content.getChild(i).getChild(j).FHDItemWidth = "400"
            else
                content.getChild(i).getChild(j).FHDItemWidth = "704"
            end if
        end for
    end for
    m.rowList.content = content

    firstElement = m.rowList.content.getChild(0).getChild(0)
    m.poster.uri = firstElement.HDPosterUrl
    m.title.text = firstElement.title
    m.description.text = firstElement.description

    m.rowList.observeField("rowItemFocused", "checkAndPopulateElements")
end sub

sub setElementsTranslation()
    m.poster.update({
        width:  (1920 / 2) - 10,
        height: (1080 / 2) - 10
    }, true)

    m.title.update({
        width:  ((1920 / 2) - 10),
    }, true)

    m.description.update({
        width:  ((1920 / 2) - 10),
        height: ((1080 / 2) - 10) - m.title.boundingRect().height
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
end sub