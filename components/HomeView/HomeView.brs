sub init()
    _findAndPopulate()
end sub

sub _findAndPopulate()
    m.top.isLoading = false
    m._userName = m.top.findNode("userName")
    m._userNickName = m.top.findNode("userNickName")
    m._userPassword = m.top.findNode("userPassword")
    m._userEmail = m.top.findNode("userEmail")

    buttonShowContentListView = m.top.findNode("buttonShowContentListView")
    buttonShowCustomKeyGridView = m.top.findNode("buttonShowCustomKeyGridView")
    buttonShowSlideShowView = m.top.findNode("buttonShowSlideShowView")
    buttonLogOut = m.top.findNode("buttonLogOut")
    m._buttonGroup = m.top.findNode("buttonGroup")

    buttonShowContentListView.observeFieldScoped("buttonSelected", "_onButtonShowContentListView")
    buttonShowCustomKeyGridView.observeFieldScoped("buttonSelected", "_onButtonShowCustomKeyGridView")
    buttonShowSlideShowView.observeFieldScoped("buttonSelected", "_onButtonShowSlideShowView")
    buttonLogOut.observeFieldScoped("buttonSelected", "_onButtonLogOut")
    m.top.observeFieldScoped("userData", "_populateUserData")

    m._currentButton = 0

    m.top.observeFieldScoped("focusedChild" , "_onFocusedChild")
end sub

sub _onFocusedChild()
    if m.top.hasFocus() then m._buttonGroup.getChild(m._currentButton).setFocus(true)
end sub

sub _populateUserData()
    m._userName.text = m.top.userData.userName
    m._userNickName.text = m.top.userData.userNickName
    m._userPassword.text = m.top.userData.userPassword
    m._userEmail.text = m.top.userData.userEmail
end sub

sub _onButtonShowContentListView()
    m.top.showContentListView = true
end sub

sub _onButtonShowCustomKeyGridView()
    m.top.showCustomKeyGridView = true
end sub

sub _onButtonShowSlideShowView()
    m.top.showSlideShowView = true
end sub

sub _onButtonLogOut()
    sec = CreateObject("roRegistrySection", "userData")

    sec.Delete("userName")
    sec.Delete("userNickName")
    sec.Delete("userPassword")

    m.top.isUserLogedOut = true
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "up"
            m._currentButton--
            if m._currentButton = -1 then m._currentButton = m._buttonGroup.getChildCount() - 1
            result = true
        else if key = "down"
            m._currentButton++
            if m._currentButton = m._buttonGroup.getChildCount() then m._currentButton = 0
            result = true
        end if
        m._buttonGroup.getChild(m._currentButton).setFocus(true)
    end if
    return result
end function
