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
    m.KeyHolder = m.top.findNode("KeyHolder")
    m.NowPlayingLabel = m.top.findNode("NowPlayingLabel")
    m.NowPlayingBar = m.top.findNode("NowPlayingBar")

    ' Edit panel nodes
    m.EditBg = m.top.findNode("EditBg")
    m.EditList = m.top.findNode("EditList")
    m.EditHighlightTop = m.top.findNode("EditHighlightTop")
    m.EditHighlightBottom = m.top.findNode("EditHighlightBottom")
    m.EditHighlightLeft = m.top.findNode("EditHighlightLeft")
    m.EditHighlightRight = m.top.findNode("EditHighlightRight")

    m.editMode = false
    m.editRow = 0
    m.editCol = 1
    m.editRowHeight = 46
    m.editListTopY = 160
    m.editListLeftX = 80
    m.editRowWidth = 1760
    ' Per-column x and width used to position the selection highlight.
    m.editColX = [0, 100, 1520, 1620]
    m.editColW = [80, 1400, 80, 80]

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

    m.KeyHolder.setFocus(true)

    m.Timer.observeField("fire", "hideHint")
    m.RowList.observeField("rowItemSelected", "ChannelChange")

    m.LongPressTimer = m.top.findNode("LongPressTimer")
    m.LongPressTimer.observeField("fire", "onLongPressFire")
    m.okHeld = false
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
        m.KeyHolder.setFocus(true)
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
    ' Long-press OK opens the station edit panel. OK only reaches the scene
    ' when Video has focus; the RowList consumes its own OK for selection.
    if key = "OK" and not m.editMode
        if press
            if not m.okHeld
                m.okHeld = true
                m.LongPressTimer.control = "stop"
                m.LongPressTimer.control = "start"
            end if
            return false
        else
            m.okHeld = false
            m.LongPressTimer.control = "stop"
            return false
        end if
    end if

    if not press then return false

    if m.editMode
        return handleEditKey(key)
    end if

    handled = false
    if key = "up" and m.global.Options = 1
        m.global.Options = 0
        optionsMenu()
        handled = true
    else if key = "down" and m.global.Options <> 1
        m.global.Options = 1
        optionsMenu()
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
    saveLastStation(m.array[index].Id)
    updateStationDisplay(index)
End Function

Sub rowListContentChanged()
    m.RowList.content = m.LoadTask.content
    if m.count = 0
        ' Resume the last listened station by Id, or default to the first one
        lastId = getLastStation()
        lastStation = 0
        for i = 0 to m.stationCount - 1
            if m.array[i].Id = lastId
                lastStation = i
                exit for
            end if
        end for

        startIndex = m.midPoint + lastStation
        m.RowList.jumpToRowItem = [0, startIndex + 100]
        m.RowList.jumpToRowItem = [0, startIndex]
        m.Video.content = m.RowList.content.getChild(0).getChild(startIndex)
        m.Video.control = "play"
        m.count = 1

        updateStationDisplay(lastStation)
    end if
End Sub

Sub updateStationDisplay(index as Integer)
    if index < m.array.count()
        station = m.array[index]

        m.StationPoster.uri = station.Logo

        m.NowPlayingTask.control = "STOP"
        m.NowPlayingLabel.text = ""
        m.currentStationTitle = station.Title
        m.NowPlayingLabel.text = station.Title

        m.NowPlayingBar.visible = true
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
        m.NowPlayingLabel.text = m.currentStationTitle + chr(10) + title
        m.NowPlayingBar.visible = true
    end if
End Sub

Sub saveLastStation(stationId as Integer)
    sec = createObject("roRegistrySection", "SlightlyEpicRadio")
    sec.write("lastStationId", stationId.toStr())
    sec.flush()
End Sub

Function getLastStation() as Integer
    sec = createObject("roRegistrySection", "SlightlyEpicRadio")
    ' Prefer station Id; fall back to legacy index for older installs.
    if sec.exists("lastStationId")
        return sec.read("lastStationId").toInt()
    end if
    if sec.exists("lastStation")
        return sec.read("lastStation").toInt()
    end if
    return 0
End Function

' ---------------------------------------------------------------------------
' Station edit panel
' ---------------------------------------------------------------------------

Sub openEditPanel()
    m.editStations = loadAllStationsOrdered()
    settings = loadStationSettings()
    m.editHidden = {}
    for each id in settings.hidden
        m.editHidden[id.toStr()] = true
    end for
    m.editRow = 0
    m.editCol = 1
    ' Remember which node was focused so we can restore it later.
    if m.RowList.hasFocus()
        m.editPrevFocus = "RowList"
    else
        m.editPrevFocus = "Video"
    end if
    buildEditRows()
    updateEditHighlight()
    m.EditBg.visible = true
    m.EditBg.setFocus(true)
    m.editMode = true
End Sub

Sub closeEditPanel()
    ' Build order from current editStations and hidden set, then persist.
    order = []
    for each s in m.editStations
        order.push(s.Id)
    end for
    hidden = []
    for each key in m.editHidden
        if m.editHidden[key] = true
            hidden.push(key.toInt())
        end if
    end for
    saveStationSettings(order, hidden)

    m.EditBg.visible = false
    m.EditHighlightTop.visible = false
    m.EditHighlightBottom.visible = false
    m.EditHighlightLeft.visible = false
    m.EditHighlightRight.visible = false
    m.editMode = false

    ' Restore focus to whichever node had it before the edit panel opened.
    if m.editPrevFocus = "RowList"
        m.RowList.setFocus(true)
    else
        m.KeyHolder.setFocus(true)
    end if

    ' Rebuild the playback list from updated settings.
    m.array = loadContentFeed()
    m.stationCount = m.array.count()
    m.midPoint = int(m.repeats / 2) * m.stationCount
    m.count = 0
    m.LoadTask = createObject("roSGNode", "RowListContentTask")
    m.LoadTask.observeField("content", "rowListContentChanged")
    m.LoadTask.control = "RUN"
End Sub

Sub buildEditRows()
    ' Remove any existing children from EditList.
    while m.EditList.getChildCount() > 0
        m.EditList.removeChildIndex(0)
    end while

    for i = 0 to m.editStations.count() - 1
        station = m.editStations[i]
        isHidden = m.editHidden.DoesExist(station.Id.toStr())

        row = createObject("roSGNode", "Group")
        row.translation = [0, i * m.editRowHeight]

        ' Checkbox background
        checkBg = createObject("roSGNode", "Rectangle")
        checkBg.translation = [22, 5]
        checkBg.width = 36
        checkBg.height = 36
        if isHidden
            checkBg.color = "0x333333FF"
        else
            checkBg.color = "0xFFCC00FF"
        end if
        row.appendChild(checkBg)

        ' Check mark
        check = createObject("roSGNode", "Label")
        check.translation = [22, 5]
        check.width = 36
        check.height = 36
        check.horizAlign = "center"
        check.vertAlign = "center"
        check.font = "font:MediumBoldSystemFont"
        check.color = "0x000000FF"
        if isHidden
            check.text = ""
        else
            check.text = "X"
        end if
        row.appendChild(check)

        ' Station title
        titleLabel = createObject("roSGNode", "Label")
        titleLabel.translation = [100, 0]
        titleLabel.width = m.editColW[1]
        titleLabel.height = m.editRowHeight
        titleLabel.vertAlign = "center"
        titleLabel.font = "font:MediumSystemFont"
        if isHidden
            titleLabel.color = "0x888888FF"
        else
            titleLabel.color = "0xFFFFFFFF"
        end if
        titleLabel.text = station.Title
        row.appendChild(titleLabel)

        ' Up arrow
        upLabel = createObject("roSGNode", "Label")
        upLabel.translation = [m.editColX[2], 0]
        upLabel.width = m.editColW[2]
        upLabel.height = m.editRowHeight
        upLabel.horizAlign = "center"
        upLabel.vertAlign = "center"
        upLabel.font = "font:MediumBoldSystemFont"
        upLabel.color = "0xFFFFFFFF"
        upLabel.text = "UP"
        row.appendChild(upLabel)

        ' Down arrow
        dnLabel = createObject("roSGNode", "Label")
        dnLabel.translation = [m.editColX[3], 0]
        dnLabel.width = m.editColW[3]
        dnLabel.height = m.editRowHeight
        dnLabel.horizAlign = "center"
        dnLabel.vertAlign = "center"
        dnLabel.font = "font:MediumBoldSystemFont"
        dnLabel.color = "0xFFFFFFFF"
        dnLabel.text = "DN"
        row.appendChild(dnLabel)

        m.EditList.appendChild(row)
    end for
End Sub

Sub updateEditHighlight()
    if m.editStations = invalid or m.editStations.count() = 0 then return
    x = m.editListLeftX + m.editColX[m.editCol]
    y = m.editListTopY + m.editRow * m.editRowHeight
    w = m.editColW[m.editCol]
    h = m.editRowHeight

    m.EditHighlightTop.translation = [x, y]
    m.EditHighlightTop.width = w
    m.EditHighlightTop.visible = true

    m.EditHighlightBottom.translation = [x, y + h - 2]
    m.EditHighlightBottom.width = w
    m.EditHighlightBottom.visible = true

    m.EditHighlightLeft.translation = [x, y]
    m.EditHighlightLeft.height = h
    m.EditHighlightLeft.visible = true

    m.EditHighlightRight.translation = [x + w - 2, y]
    m.EditHighlightRight.height = h
    m.EditHighlightRight.visible = true
End Sub

Sub onLongPressFire()
    if m.okHeld and not m.editMode
        m.okHeld = false
        openEditPanel()
    end if
End Sub

Function handleEditKey(key as String) as Boolean
    if key = "back"
        closeEditPanel()
        return true
    end if

    if key = "up"
        if m.editRow > 0
            m.editRow = m.editRow - 1
            updateEditHighlight()
        end if
        return true
    end if
    if key = "down"
        if m.editRow < m.editStations.count() - 1
            m.editRow = m.editRow + 1
            updateEditHighlight()
        end if
        return true
    end if
    if key = "left"
        if m.editCol > 0
            m.editCol = m.editCol - 1
            updateEditHighlight()
        end if
        return true
    end if
    if key = "right"
        if m.editCol < 3
            m.editCol = m.editCol + 1
            updateEditHighlight()
        end if
        return true
    end if
    if key = "OK"
        performEditAction()
        return true
    end if
    return true
End Function

Sub performEditAction()
    if m.editStations = invalid or m.editStations.count() = 0 then return
    station = m.editStations[m.editRow]
    idKey = station.Id.toStr()

    if m.editCol = 0
        ' Toggle visibility, but never hide the last visible station.
        if m.editHidden.DoesExist(idKey)
            m.editHidden.Delete(idKey)
        else
            visibleCount = m.editStations.count()
            for each k in m.editHidden
                if m.editHidden[k] = true
                    visibleCount = visibleCount - 1
                end if
            end for
            if visibleCount > 1
                m.editHidden[idKey] = true
            end if
        end if
        buildEditRows()
        updateEditHighlight()
        return
    end if

    if m.editCol = 2
        ' Move up
        if m.editRow > 0
            tmp = m.editStations[m.editRow - 1]
            m.editStations[m.editRow - 1] = m.editStations[m.editRow]
            m.editStations[m.editRow] = tmp
            m.editRow = m.editRow - 1
            buildEditRows()
            updateEditHighlight()
        end if
        return
    end if

    if m.editCol = 3
        ' Move down
        if m.editRow < m.editStations.count() - 1
            tmp = m.editStations[m.editRow + 1]
            m.editStations[m.editRow + 1] = m.editStations[m.editRow]
            m.editStations[m.editRow] = tmp
            m.editRow = m.editRow + 1
            buildEditRows()
            updateEditHighlight()
        end if
        return
    end if
End Sub
