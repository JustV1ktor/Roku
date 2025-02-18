sub init()
    m.top.functionName = "post"
end sub

sub post()
    m.port = CreateObject("roMessagePort")
	m.transfer = CreateObject("roURLTransfer")
	m.transfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
	m.transfer.InitClientCertificates()
	m.transfer.setMessagePort(m.port)

	m.transfer.setURL("https://91097ac0-7860-41d9-875f-2973004e7ece.mock.pstmn.io/login")

    body = {
        login: m.top.email,
        password: m.top.password
    }

    m.transfer.AsyncPostFromString(FormatJson(body))

    while true
        message = Wait(3000, m.port)
        messageType = type(message)
        if messageType = "roUrlEvent"
            responseCode = message.getResponseCode()
            if responseCode = 200
                responseString = message.getString()
                resposnseObject = ParseJson(responseString)

                response = {
                    success: resposnseObject.success,
                    name: resposnseObject.name,
                    userName: resposnseObject.userName,
                }
                m.top.response = response
            end if
        end if
    end while
end sub
