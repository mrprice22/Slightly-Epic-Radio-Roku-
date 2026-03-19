Sub init()
    if CanDecodeAudio()
        loadContent()
    else
        supportDialog()
        m.top.Dialog.observeField("wasClosed", "loadContent")
    end if
End Sub

Sub loadContent()
    m.count = 0
    m.Video = m.top.findNode("Video")
    m.RowList = m.top.findNode("RowList")
    m.BottomBar = m.top.findNode("BottomBar")
    m.ShowBar = m.top.findNode("ShowBar")
    m.HideBar = m.top.findNode("HideBar")
    m.Hint = m.top.findNode("Hint")
    m.Timer = m.top.findNode("Timer")
    m.StationPoster = m.top.findNode("StationPoster")
    m.NowPlayingLabel = m.top.findNode("NowPlayingLabel")
    m.NowPlayingBar = m.top.findNode("NowPlayingBar")

    showHint()
    m.array = loadContentFeed()
    m.stationCount = m.array.count()
    m.repeats = 100
    m.midPoint = int(m.repeats / 2) * m.stationCount

    m.LoadTask = createObject("roSGNode", "RowListContentTask")
    m.LoadTask.observeField("content", "rowListContentChanged")
    m.LoadTask.control = "RUN"

    ' Create the now-playing metadata polling task
    m.NowPlayingTask = createObject("roSGNode", "NowPlayingTask")
    m.NowPlayingTask.observeField("nowPlaying", "onNowPlayingChanged")

    m.Video.setFocus(true)

    m.Timer.observeField("fire", "hideHint")
    m.RowList.observeField("rowItemSelected", "ChannelChange")
End Sub

Sub hideHint()
    m.Hint.visible = false
End Sub

Sub showHint()
    m.Hint.visible = true
    m.Timer.control = "start"
End Sub

Sub optionsMenu()
    if m.global.Options = 0
        m.ShowBar.control = "start"
        m.RowList.setFocus(true)
        hideHint()
    else
        m.HideBar.control = "start"
        m.Video.setFocus(true)
        showHint()
    End if
End Sub

Function CanDecodeAudio() as Boolean
    dev_info = createObject("roDeviceInfo")
    return dev_info.CanDecodeAudio({"Codec":"eac3"}).result
End Function

Function supportDialog()
    dialog = createObject("roSGNode", "Dialog")
    dialog.title = "Warning"
    dialog.message = "Your current setup is unable to decode Dolby Digital Plus Audio. No audio may be heard if you proceed with playback."
    dialog.buttons = ["Press back to dismiss and play anyways"]
    m.top.dialog = dialog
End Function

Function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
        if press
            if key="up" and m.global.Options = 1
                m.global.Options = 0
                optionsMenu()
            else if key = "down" and m.global.Options <> 1
                m.global.Options = 1
                optionsMenu()
            end if
            handled = true
        end if
    return handled
End Function

Function ChannelChange()
    m.Video.content = m.RowList.content.getChild(m.RowList.rowItemFocused[0]).getChild(m.RowList.rowItemFocused[1])
    m.Video.control = "play"
    m.global.options = 1
    OptionsMenu()

    ' Map the repeated list index back to real station index
    index = m.RowList.rowItemFocused[1] MOD m.stationCount
    saveLastStation(index)
    updateStationDisplay(index)
End Function

Sub rowListContentChanged()
    m.RowList.content = m.LoadTask.content
    if m.count = 0
        ' Resume the last listened station, or default to the first one
        lastStation = getLastStation()
        if lastStation < 0 or lastStation >= m.stationCount
            lastStation = 0
        end if

        ' With floatingFocus, focus floats to the right edge of visible items.
        ' First jump far right to prime the float position, then jump back
        ' so the starting station appears visually centered.
        startIndex = m.midPoint + lastStation
        m.RowList.jumpToRowItem = [0, startIndex + 100]
        m.RowList.jumpToRowItem = [0, startIndex]
        m.Video.content = m.RowList.content.getChild(0).getChild(startIndex)
        m.Video.control = "play"
        m.count = 1

        ' Show poster and start metadata for the resumed station
        updateStationDisplay(lastStation)
    end if
End Sub

Sub updateStationDisplay(index as Integer)
    if index < m.array.count()
        station = m.array[index]

        ' Show the station artwork
        m.StationPoster.uri = station.Logo

        ' Stop previous metadata task and start a new one
        m.NowPlayingTask.control = "STOP"
        m.NowPlayingLabel.text = ""
        m.currentStationTitle = station.Title  'sp1
        m.NowPlayingLabel.text = station.Title  'sp1

        m.NowPlayingBar.visible = true  'sp2
        if station.MetaType <> "none" and station.MetaUrl <> ""
            m.NowPlayingTask = createObject("roSGNode", "NowPlayingTask")
            m.NowPlayingTask.observeField("nowPlaying", "onNowPlayingChanged")
            m.NowPlayingTask.metaUrl = station.MetaUrl
            m.NowPlayingTask.metaType = station.MetaType
            m.NowPlayingTask.streamUrl = station.Stream
            m.NowPlayingTask.control = "RUN"
            m.NowPlayingBar.visible = true
        else
            m.NowPlayingBar.visible = false
        end if
    end if
End Sub

Sub onNowPlayingChanged()
    title = m.NowPlayingTask.nowPlaying
    if title <> ""
        m.NowPlayingLabel.text = m.currentStationTitle + chr(10) + title  'sp3
        m.NowPlayingBar.visible = true
    end if
End Sub

Sub saveLastStation(index as Integer)
    sec = createObject("roRegistrySection", "SlightlyEpicRadio")
    sec.write("lastStation", index.toStr())
    sec.flush()
End Sub

Function getLastStation() as Integer
    sec = createObject("roRegistrySection", "SlightlyEpicRadio")
    if sec.exists("lastStation")
        return sec.read("lastStation").toInt()
    end if
    return 0
End Function
