sub init()
    _findAndPopulate()
end sub

sub _findAndPopulate()
    m._videoPlayer = m.top.findNode("videoPlayer")
    m._buttonGroup = m.top.findNode("buttonGroup")
    videoContent = CreateObject("roSGNode", "ContentNode")

    m._duration = m.top.findNode("duration")
    m._position = m.top.findNode("position")
    m._progressBar = m.top.findNode("progressBar")
    m._progression = m.top.findNode("progression")
    m._dot = m.top.findNode("dot")
    m._backGroundGradient = m.top.findNode("backGroundGradient")

    m._buttonRestart = m.top.findNode("restart")
    m._buttonFastRewind = m.top.findNode("fastRewind")
    m._buttonPauseAndResume = m.top.findNode("pauseAndResume")
    m._buttonFastForward = m.top.findNode("fastForward")

    m._buttonRestart.observeFieldScoped("buttonSelected", "_onButtonRestartSelected")
    m._buttonFastRewind.observeFieldScoped("buttonSelected", "_onButtonFastRewindSelected")
    m._buttonPauseAndResume.observeFieldScoped("buttonSelected", "_onButtonPauseAndResumeSelected")
    m._buttonFastForward.observeFieldScoped("buttonSelected", "_onButtonFastForwardSelected")

    m._buttonRestart.observeFieldScoped("focusedChild", "_buttonRestartFocused")
    m._buttonFastRewind.observeFieldScoped("focusedChild", "_buttonFastRewindFocused")
    m._buttonPauseAndResume.observeFieldScoped("focusedChild", "_buttonPauseAndResumeFocused")
    m._buttonFastForward.observeFieldScoped("focusedChild", "_buttonFastForwardFocused")
    
    videoContent.title = "Example Video"
    videoContent.url = "https://roku-webdev-opus.s3.amazonaws.com/public-videos/big+stream+trimmed.mp4"

    m._videoPlayer.content = videoContent
    m._videoPlayer.control = "play"

    m._videoPlayer.observeFieldScoped("position", "_showPosition")

    m._currentButton = 0
    m._currentRow = 2
    m.top.observeFieldScoped("focusedChild" , "_onFocusedChild")
end sub

sub _onFocusedChild()
    if m.top.hasFocus() then m._buttonGroup.getChild(m._currentButton).setFocus(true)
end sub

sub _onButtonRestartSelected()
    m._videoPlayer.seek = 0.0
    m._videoPlayer.position = 0.0
    m._buttonPauseAndResume.uri = "pkg:/images/pause.png"
    m._videoPlayer.control = "resume"
end sub

sub _onButtonFastRewindSelected()
    seconds = m._videoPlayer.position.toStr().split(".")[0]
    result = seconds.toFloat() - 5.0
    if result < 0 
        result = 0
    end if 
    m._videoPlayer.seek = result
    m._videoPlayer.position = result
    m._videoPlayer.control = "pause"
    m._buttonPauseAndResume.uri = "pkg:/images/resume.png"
end sub

sub _onButtonPauseAndResumeSelected()
    if m._videoPlayer.control = "resume" or m._videoPlayer.control = "play"
        m._buttonPauseAndResume.uri = "pkg:/images/resume.png"
        m._videoPlayer.control = "pause"
    else if m._videoPlayer.control = "pause"
        m._buttonPauseAndResume.uri = "pkg:/images/pause.png"
        m._videoPlayer.control = "resume"
    end if
end sub

sub _onButtonFastForwardSelected()
    seconds = m._videoPlayer.position.toStr().split(".")[0]
    result = seconds.toFloat() + 5.0
    if result > m._videoPlayer.duration
        result = m._videoPlayer.duration
    end if 
    m._videoPlayer.seek = result
    m._videoPlayer.position = result
    m._videoPlayer.control = "pause"
    m._buttonPauseAndResume.uri = "pkg:/images/resume.png"
end sub

sub _buttonRestartFocused()
    if m._buttonRestart.hasfocus() = true
        m._buttonRestart.blendColor = "0xffffffff"
    else if m._buttonRestart.hasfocus() = false
        m._buttonRestart.blendColor = "0xffffff33"
    end if
end sub

sub _buttonFastRewindFocused()
    if m._buttonFastRewind.hasfocus() = true
        m._buttonFastRewind.blendColor = "0xffffffff"
    else if m._buttonFastRewind.hasfocus() = false
        m._buttonFastRewind.blendColor = "0xffffff33"
    end if
end sub

sub _buttonPauseAndResumeFocused()
    if m._buttonPauseAndResume.hasfocus() = true
        if m._videoPlayer.control = "resume" or m._videoPlayer.control = "play"
            m._buttonPauseAndResume.uri = "pkg:/images/pause.png"
            m._buttonPauseAndResume.blendColor = "0xffffffff"
        else if m._videoPlayer.control = "pause"
            m._buttonPauseAndResume.uri = "pkg:/images/resume.png"
            m._buttonPauseAndResume.blendColor = "0xffffffff"
        end if
    else if m._buttonPauseAndResume.hasfocus() = false
        if m._videoPlayer.control = "resume" or m._videoPlayer.control = "play"
            m._buttonPauseAndResume.uri = "pkg:/images/pause.png"
            m._buttonPauseAndResume.blendColor = "0xffffff33"
        else if m._videoPlayer.control = "pause"
            m._buttonPauseAndResume.uri = "pkg:/images/resume.png"
            m._buttonPauseAndResume.blendColor = "0xffffff33"
        end if
    end if
end sub

sub _buttonFastForwardFocused()
    if m._buttonFastForward.hasfocus() = true
        m._buttonFastForward.blendColor = "0xffffffff"
    else if m._buttonFastForward.hasfocus() = false
        m._buttonFastForward.blendColor = "0xffffff33"
    end if
end sub

sub _showDuration()
    seconds = m._videoPlayer.position.toStr().split(".")[0]
    result = m._videoPlayer.duration - seconds.toInt()
    result = result.toStr()
    if result.len() = 1
        result = "0" + result
    end if
    m._duration.text = "0:" + result
end sub

sub _showPosition()
    if m._videoPlayer.position / m._videoPlayer.duration > 1 
        resultPosition = 1
    else
        resultPosition = m._videoPlayer.position / m._videoPlayer.duration
    end if
    m._progression.width = (1770 * resultPosition) + 30
    m._dot.translation = [(1770 * resultPosition) + 60, 900]
    seconds = m._videoPlayer.position.toStr().split(".")[0]
    if seconds.len() = 1
        seconds = "0" + seconds
    end if
    m._position.text = "0:" + seconds
    _showDuration()
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press 
        if key = "up"
            m._currentRow--

            if m._currentRow < 0 then m._currentRow = 0

            if m._currentRow = 0
                m._duration.setFocus(true)
                m._progressBar.visible = "false"
                m._progression.visible = "false"
                m._dot.visible = "false"
                m._buttonGroup.visible = "false"
                m._backGroundGradient.visible = "false"
                m._position.visible = "false"
                m._duration.visible = "false"
            else if m._currentRow = 1
                m._dot.setFocus(true)
                m._dot.color = "0xff00ffff"
            end if
            result = true
        else if key = "down"
            m._currentRow++

            if m._currentRow > 2 then m._currentRow = 2

            if m._currentRow = 1
                m._dot.setFocus(true)
                m._progressBar.visible = "true"
                m._progression.visible = "true"
                m._dot.visible = "true"
                m._buttonGroup.visible = "true"
                m._backGroundGradient.visible = "true"
                m._position.visible = "true"
                m._duration.visible = "true"
            else if m._currentRow = 2
                m._buttonGroup.getChild(m._currentButton).setFocus(true)
                m._dot.color = "0xffffffff"
            end if

            result = true
        else if key = "left"
            if m._dot.hasFocus() = true 
                _onButtonFastRewindSelected()
            else
                m._currentButton--
                if m._currentButton = -1 then m._currentButton = 3
                m._buttonGroup.getChild(m._currentButton).setFocus(true)
            end if
            result = true
        else if key = "right"
            if m._dot.hasFocus() = true 
                _onButtonFastForwardSelected()
            else
                m._currentButton++
                if m._currentButton = 4 then m._currentButton = 0
                m._buttonGroup.getChild(m._currentButton).setFocus(true)
            end if
            result = true
        end if
    end if
    return result
end function
