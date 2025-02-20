sub init()
    m.top.ComponentController = m.top.findNode("ComponentController")
    m._sec = CreateObject("roRegistrySection", "userData")
    if m._sec.Exists("userName") then _showHomeView() else _ShowAuthorizationView()
end sub

sub _ShowAuthorizationView()
    m._AuthorizationView = CreateObject("roSGNode", "AuthorizationView")

    m._AuthorizationView.observeFieldScoped("isLoginSuccess", "_showHomeView")
    m._AuthorizationView.observeFieldScoped("isLoading", "_showActionLoader")

    m.top.ComponentController.callFunc("show", {
        view: m._AuthorizationView
    })

end sub

sub _showHomeView()
    if m._AuthorizationView <> invalid then m._AuthorizationView.isLoginSuccess = false

    m._homeView = CreateObject("roSGNode", "HomeView")

    _hideActionLoader()
    
    m._homeView.userData = {
        userName: m._sec.Read("userName"),
        userNickName: m._sec.Read("userNickName"),
        userPassword: m._sec.Read("userPassword"),
        userEmail: m._sec.Read("userEmail")
    }

    m._homeView.observeFieldScoped("showContentListView", "_showContentListView")
    m._homeView.observeFieldScoped("showCustomKeyGridView", "_showCustomKeyGridView")
    m._homeView.observeFieldScoped("showSlideShowView", "_showSlideShowView")
    m._homeView.observeFieldScoped("isUserLogedOut", "_ShowAuthorizationView")

    m.top.ComponentController.callFunc("show", {
        view: m._homeView
    })
end sub

sub _showContentListView()
    m._homeView.showContentListView = false
    contentListView = CreateObject("roSGNode", "ContentListView")

    contentListView.observeFieldScoped("isLoading", "_showActionLoader")

    m.top.ComponentController.callFunc("show", {
        view: contentListView
    })
end sub

sub _showCustomKeyGridView()
    m._homeView.showCustomKeyGridView = false
    customKeyGrid = CreateObject("roSGNode", "CustomKeyGrid")

    m.top.ComponentController.callFunc("show", {
        view: customKeyGrid
    })
end sub

sub _showSlideShowView()
    m._homeView.showSlideShowView = false
    slideShowView = CreateObject("roSGNode", "SlideShowView")

    m.top.ComponentController.callFunc("show", {
        view: slideShowView
    })
end sub

sub _showActionLoader(event)
    if event.getData()
        m._actionLoader = CreateObject("roSGNode", "ActionLoader")
        m.top.appendChild(m._actionLoader)
        m._actionLoader.setFocus(true)
    else
        _hideActionLoader()
    end if
end sub

sub _hideActionLoader()
    m.top.removeChild(m._actionLoader)
    m._actionLoader = invalid
end sub