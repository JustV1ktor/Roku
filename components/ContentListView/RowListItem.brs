sub init()
    m._poster = m.top.findNode("poster") 
end sub

sub onitemContentPopulate(event as Object)
    m._poster.uri = event.getData().FHDPosterUrl
end sub
