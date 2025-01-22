sub init()
    m.poster = m.top.findNode("itemPoster") 
end sub

sub showContent()
    m.poster.uri = m.top.itemContent.HDPosterUrl
end sub