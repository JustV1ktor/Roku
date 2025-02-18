sub init()
    m.poster = m.top.findNode("itemPoster") 
end sub

sub showContent(event as Object)
    m.poster.uri = event.getData().FHDPosterUrl
end sub