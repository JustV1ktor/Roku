sub init()
	m.mainArea = m.top.findNode("mainArea")
	m.emailTextEditBox = m.top.findNode("emailTextEditBox")
	m.passwordTextEditBox = m.top.findNode("passwordTextEditBox")
	m.buttonUserAuthorization = m.top.findNode("userAuthorization")

	m.scene = m.top.getScene()

	m.emailValidation = CreateObject("roRegex","[\w-\.]+@([\w-]+\.)+[\w]{2,4}","")
	m.passwordValidation = CreateObject("roRegex","(?=.+[a-z])(?=.+[A-Z]).{8,}","")
	
	m.currentElement = 0

	m.emailTextEditBox.text = "exampleMail@gmail.com"
	m.passwordTextEditBox.text = "FOrExamplE"

	m.emailTextEditBox.observeFieldScoped("focusedChild", "highlightEmailTextBox")
	m.passwordTextEditBox.observeFieldScoped("focusedChild", "highlightPasswordTextBox")
	m.buttonUserAuthorization.observeFieldScoped("focusedChild", "hideTextBoxs")
	m.buttonUserAuthorization.observeFieldScoped("buttonSelected", "checkEmailAndPassword")
	m.top.observeFieldScoped("focusedChild" , "onFocusedChild")
end sub

sub onFocusedChild()
    if m.top.hasFocus() then m.mainArea.getChild(m.currentElement).setFocus(true)
end sub

sub highlightEmailTextBox()
	m.emailTextEditBox.textColor = "0x2288ffff"

	m.passwordTextEditBox.textColor = "0xffffff"
end sub

sub highlightPasswordTextBox()
	m.passwordTextEditBox.textColor = "0x2288ffff"

	m.emailTextEditBox.textColor = "0xffffff"
end sub

sub hideTextBoxs()
	m.passwordTextEditBox.textColor = "0xffffff"

	m.emailTextEditBox.textColor = "0xffffff"
end sub

sub checkEmailAndPassword()
	if m.emailTextEditBox.text = "" OR m.passwordTextEditBox.text = ""
		onActionResponse("Please enter email and password!")
	else
		if m.emailValidation.isMatch(m.emailTextEditBox.text) AND m.passwordValidation.isMatch(m.passwordTextEditBox.text)
			onActionResponse("email and password are valid!")
		else
			onActionResponse("email or password is incorrect")
		end if
	end if
end sub

sub onButtonDialogPressed(event)
	if event.getData() = 0
		if m.mainArea.getChild(m.currentElement).id = "emailTextEditBox"
			m.emailTextEditBox.text = m.keyBoard.text
		else if m.mainArea.getChild(m.currentElement).id = "passwordTextEditBox"
			m.passwordTextEditBox.text = m.keyBoard.text
		end if
	end if
	m.scene.dialog = ""
	m.keyBoard.unobserveFieldScoped("buttonSelected")
	m.keyBoard = ""
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
	result = false
	if press 
		if key = "up"
			m.currentElement--
			if m.currentElement = -1 then m.currentElement = 2
			result = true
		else if key = "down"
			m.currentElement++
			if m.currentElement = 3 then m.currentElement = 0
			result = true
		else if key = "OK"
			if m.mainArea.getChild(m.currentElement).hasFocus() = true
				textEditBoxSelected = m.mainArea.getChild(m.currentElement).hintText
				m.keyBoard = CreateObject("roSGNode", "StandardKeyboardDialog")

				if m.mainArea.getChild(m.currentElement).id = "emailTextEditBox" then m.keyBoard.text = m.emailTextEditBox.text

				m.keyBoard.title = textEditBoxSelected
				messageText = "please enter your " + textEditBoxSelected
				m.keyBoard.message = [messageText]
				m.keyBoard.buttons = ["OK", "cancel"]

				m.keyBoard.observeFieldScoped("buttonSelected", "onButtonDialogPressed")

				m.scene.dialog = m.keyBoard
			end if
		end if
	end if

	m.mainArea.getChild(m.currentElement).setFocus(true)
	return result
end function