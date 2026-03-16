Sub Init()
    m.top.functionName = "pollMetadata"
End Sub

Sub onControlChange()
    if m.top.control = "RUN"
        m.top.functionName = "pollMetadata"
    end if
End Sub

Sub pollMetadata()
    while true
        metaUrl = m.top.metaUrl
        metaType = m.top.metaType
        streamUrl = m.top.streamUrl

        if metaUrl <> "" and metaType <> "none"
            title = fetchNowPlaying(metaUrl, metaType, streamUrl)
            if title <> ""
                m.top.nowPlaying = title
            end if
        end if

        sleep(20000)
    end while
End Sub

Function fetchNowPlaying(metaUrl as String, metaType as String, streamUrl as String) as String
    http = CreateObject("roUrlTransfer")
    http.SetUrl(metaUrl)
    http.SetCertificatesFile("common:/certs/ca-bundle.crt")
    http.InitClientCertificates()
    http.EnableHostVerification(false)
    http.EnablePeerVerification(false)
    http.SetPort(CreateObject("roMessagePort"))
    http.AddHeader("User-Agent", "SlightlyEpicRadio/1.0")

    if http.AsyncGetToString()
        msg = wait(5000, http.GetPort())
        if msg <> invalid
            code = msg.GetResponseCode()
            if code = 200
                body = msg.GetString()
                if metaType = "icecast"
                    return parseIcecastJson(body, streamUrl)
                else if metaType = "shoutcast"
                    return parseShoutcast7html(body)
                end if
            end if
        end if
    end if

    return ""
End Function

Function parseIcecastJson(body as String, streamUrl as String) as String
    json = ParseJSON(body)
    if json = invalid then return ""

    icestats = json.icestats
    if icestats = invalid then return ""

    source = icestats.source
    if source = invalid then return ""

    ' source can be a single object or an array of mount points
    if type(source) = "roArray"
        ' Find the source matching our stream URL
        for each s in source
            listenurl = ""
            if s.listenurl <> invalid then listenurl = s.listenurl
            if listenurl = streamUrl or listenurl = "" ' fallback to first if no match
                return getTitleFromSource(s)
            end if
        end for
        ' If no match found, use first source
        if source.count() > 0
            return getTitleFromSource(source[0])
        end if
    else
        return getTitleFromSource(source)
    end if

    return ""
End Function

Function getTitleFromSource(source as Object) as String
    ' Prefer yp_currently_playing (often "Artist - Title"), then title, then display-title
    if source["yp_currently_playing"] <> invalid and source["yp_currently_playing"] <> ""
        return source["yp_currently_playing"]
    end if
    if source["title"] <> invalid and source["title"] <> ""
        return source["title"]
    end if
    if source["display-title"] <> invalid and source["display-title"] <> ""
        return source["display-title"]
    end if
    return ""
End Function

Function parseShoutcast7html(body as String) as String
    ' Format: <html>...<body>X,X,X,X,X,X,Song Title<br /></body></html>
    ' Extract the song title after the 6th comma
    r = CreateObject("roRegex", "<body>\d+,\d+,\d+,-?\d+,\d+,\d+,(.*?)<", "i")
    match = r.Match(body)
    if match.count() > 1
        return match[1]
    end if
    return ""
End Function
