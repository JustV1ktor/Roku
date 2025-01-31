sub init()
    m.top.functionName = "getcontent"
end sub

sub getcontent()
    content = CreateObject("roSGNode", "contentNode")
    port = CreateObject("roMessagePort")
    transfer = CreateObject("roUrlTransfer")
    transfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    transfer.InitClientCertificates()
    transfer.setMessagePort(port)

    transfer.setUrl(m.top.contenturi)

    transfer.setHeaders({
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjZDBlYTljMDZiYmM4NzY2NTRiYzFmM2Y0ZWQwZjhmZiIsIm5iZiI6MTczODIyNjIxNy4xMjgsInN1YiI6IjY3OWIzYTI5Y2ViNDllNjcxZDM0NTgzNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.L2QOP-CUKy3tsiMycmFVfAtHf0mhuwlGs8y0t9uK73Y",
        "accept": "application/json"
    })

    transfer.AsyncGetToString()

    while true
        message = Wait(3000, port)
        mt = type(message)
		if mt="roUrlEvent"
            responseCode = message.getResponseCode()
            if responseCode = 200
                responseString = message.getString()
                resposnseObject = ParseJson(responseString)
                result = resposnseObject.results
            
                content.createChild("ContentNode")
                content.getChild(0).update({
                    title: "section 1"
                }, true)

                for each item in result
                    itemcontent = content.getChild(0).createChild("ContentNode")
                    itemcontent.addField("FHDItemWidth", "float", false)
                    itemcontent.addField("releaseDate", "string", false)
                    itemcontent.addField("averageRating", "float", false)

                    itemcontent.setFields({
                        title: item.["original_title"],
                        description: item.["overview"],
                        FHDPosterUrl: "https://image.tmdb.org/t/p/original" + item.["poster_path"],
                        HDPosterUrl: "https://image.tmdb.org/t/p/original" + item.["backdrop_path"],
                        releaseDate: item.["release_date"],
                        averageRating: item.["vote_average"].toStr().Mid(0, 3),
                        FHDItemWidth: "260"
                    })
                end for

                m.top.content = content
                exit while
            end if
        end if
    end while
end sub