sub init()
    findAndPopulate()
end sub

sub findAndPopulate()
    m.userName = m.top.findNode("userName")
    m.userNickName = m.top.findNode("userNickName")
    m.userPassword = m.top.findNode("userPassword")
    m.showNextViewButton = m.top.findNode("showNextView")
    m.onlogOutButton = m.top.findNode("logOut")

    m.showNextViewButton.observeFieldScoped("buttonSelected", "showNextView")
    m.onlogOutButton.observeFieldScoped("buttonSelected", "onLogOut")
    m.top.observeFieldScoped("userData", "Populate")

	m.top.observeFieldScoped("focusedChild" , "onFocusedChild")
end sub

sub onFocusedChild()
    if m.top.hasFocus() then m.showNextViewButton.setFocus(true)
end sub

sub Populate()
    m.userName.text = m.top.userData.userName
    m.userNickName.text = m.top.userData.userNickName
    m.userPassword.text = m.top.userData.userPassword
end sub

sub showNextView()
    m.top.showNextView = true
end sub

sub onLogOut()
    m.sec = CreateObject("roRegistrySection", "userData")

    m.sec.Delete("userName")
    m.sec.Delete("userNickName")
    m.sec.Delete("userPassword")

    m.top.isUserLogedOut = true
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "up"
            m.showNextViewButton.setFocus(true)
            result = true
        else if key = "down"
            m.onlogOutButton.setFocus(true)
            result = true
        end if
    end if
    return result
end function
