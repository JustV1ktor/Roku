sub init()
    ' slideShowView = CreateObject("roSGNode", "SlideShowView")
    ' m.top.appendChild(slideShowView)

    ' slideShowView.setFocus(true)

    ' ContentListScene = CreateObject("roSGNode", "ContentListScene")
    ' m.top.appendChild(ContentListScene)

    ' ContentListScene.setFocus(true)

    ' AuthorizationView = CreateObject("roSGNode", "AuthorizationView")
    ' m.top.appendChild(AuthorizationView)

    ' AuthorizationView.setFocus(true)

    ' CustomKeyGrid = CreateObject("roSGNode", "CustomKeyGrid")
    ' m.top.appendChild(CustomKeyGrid)

    ' CustomKeyGrid.setFocus(true)
    m.top.ComponentController = m.top.findNode("ComponentController")

    m.sec = CreateObject("roRegistrySection", "userData")
    if m.sec.Exists("userName")
        showHomeView()
    else
        ShowAuthorizationView()
    end if
end sub

sub ShowAuthorizationView()
    m.AuthorizationView = CreateObject("roSGNode", "AuthorizationView")

    m.AuthorizationView.observeFieldScoped("isLoginSuccess", "showHomeView")

    m.top.ComponentController.callFunc("show", {
        view: m.AuthorizationView
    })
end sub

sub showHomeView()
    if m.AuthorizationView <> invalid
        m.AuthorizationView.isLoginSuccess = false
    end if

    m.homeView = CreateObject("roSGNode", "HomeView")
    m.homeView.userData = {
        userName: m.sec.Read("userName"),
        userNickName: m.sec.Read("userNickName"),
        userPassword: m.sec.Read("userPassword")
    }

    m.homeView.observeFieldScoped("showNextView", "showContentListView")
    m.homeView.observeFieldScoped("isUserLogedOut", "ShowAuthorizationView")

    m.top.ComponentController.callFunc("show", {
        view: m.homeView
    })
end sub

sub showContentListView()
    m.homeView.showNextView = false
    ContentListView = CreateObject("roSGNode", "ContentListView")

    m.top.ComponentController.callFunc("show", {
        view: ContentListView
    })
end sub