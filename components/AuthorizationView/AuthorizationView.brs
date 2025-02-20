sub init()
    _findAndPopulate()
end sub

sub _findAndPopulate()
    m._mainArea = m.top.findNode("mainArea")
    m._emailTextEditBox = m.top.findNode("emailTextEditBox")
    m._passwordTextEditBox = m.top.findNode("passwordTextEditBox")
    buttonAuthorization = m.top.findNode("buttonAuthorization")

    m._scene = m.top.getScene()

    m._emailValidation = CreateObject("roRegex","[\w-\.]+@([\w-]+\.)+[\w]{2,4}","")
    m._passwordValidation = CreateObject("roRegex","(?=.+[a-z])(?=.+[A-Z]).{8,}","")
    
    m._currentElement = 0

    m._emailTextEditBox.text = "exampleMail@gmail.com"
    m._passwordTextEditBox.text = "FOrExamplE"

    m._emailTextEditBox.observeFieldScoped("focusedChild", "_highlightEmailTextBox")
    m._passwordTextEditBox.observeFieldScoped("focusedChild", "_highlightPasswordTextBox")
    buttonAuthorization.observeFieldScoped("focusedChild", "_hideTextBoxs")
    buttonAuthorization.observeFieldScoped("buttonSelected", "_checkEmailAndPassword")
    m.top.observeFieldScoped("focusedChild" , "_onFocusedChild")
end sub

sub _onFocusedChild()
    if m.top.hasFocus() then m._mainArea.getChild(m._currentElement).setFocus(true)
end sub

sub _highlightEmailTextBox()
    m._emailTextEditBox.textColor = "0x2288ffff"

    m._passwordTextEditBox.textColor = "0xffffff"
end sub

sub _highlightPasswordTextBox()
    m._passwordTextEditBox.textColor = "0x2288ffff"

    m._emailTextEditBox.textColor = "0xffffff"
end sub

sub _hideTextBoxs()
    m._passwordTextEditBox.textColor = "0xffffff"

    m._emailTextEditBox.textColor = "0xffffff"
end sub

sub _checkEmailAndPassword()
    if m._emailTextEditBox.text = "" OR m._passwordTextEditBox.text = ""
        onActionResponse("Please enter email and password!")
    else
        if m._emailValidation.isMatch(m._emailTextEditBox.text) AND m._passwordValidation.isMatch(m._passwordTextEditBox.text)
            m._authorizationTask = CreateObject("roSGNode", "AuthorizationTask")
            m.top.isLoading = true
            
            m._authorizationTask.email = m._emailTextEditBox.text
            m._authorizationTask.password = m._passwordTextEditBox.text

            m._authorizationTask.control = "run"

            m._authorizationTask.observeFieldScoped("response", "_setResponse")
        else
            onActionResponse("email or password is incorrect")
        end if
    end if
end sub

sub _setResponse()
    if m._authorizationTask.response.success = true
        sec = CreateObject("roRegistrySection", "userData")
    
        sec.WriteMulti({
            "userName": m._authorizationTask.response.name,
            "userNickName": m._authorizationTask.response.userName,
            "userPassword": m._passwordTextEditBox.text,
            "userEmail": m._emailTextEditBox.text
        })		
        m.top.isLoginSuccess = true
    else
        onActionResponse("something went wrong, request is not success")
    end if 
end sub

sub _onButtonDialogPressed(event)
    if event.getData() = 0
        if m._mainArea.getChild(m._currentElement).id = "emailTextEditBox"
            m._emailTextEditBox.text = m._keyBoard.text
        else if m._mainArea.getChild(m._currentElement).id = "passwordTextEditBox"
            m._passwordTextEditBox.text = m._keyBoard.text
        end if
    end if
    m._scene.dialog = ""
    m._keyBoard.unobserveFieldScoped("buttonSelected")
    m._keyBoard = ""
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "up"
            m._currentElement--
            if m._currentElement = -1 then m._currentElement = 2
            result = true
        else if key = "down"
            m._currentElement++
            if m._currentElement = 3 then m._currentElement = 0
            result = true
        else if key = "OK"
            if m._mainArea.getChild(m._currentElement).hasFocus() = true
                textEditBoxSelected = m._mainArea.getChild(m._currentElement).hintText
                m._keyBoard = CreateObject("roSGNode", "StandardKeyboardDialog")

                if m._mainArea.getChild(m._currentElement).id = "emailTextEditBox" then m._keyBoard.text = m._emailTextEditBox.text

                m._keyBoard.title = textEditBoxSelected
                messageText = "please enter your " + textEditBoxSelected
                m._keyBoard.message = [messageText]
                m._keyBoard.buttons = ["OK", "cancel"]

                m._keyBoard.observeFieldScoped("buttonSelected", "_onButtonDialogPressed")

                m._scene.dialog = m._keyBoard
            end if
        end if
    end if

    m._mainArea.getChild(m._currentElement).setFocus(true)
    return result
end function
