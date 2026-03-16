Function loadContentFeed() as Object
    arr = [
        {
            Title: "Slightly Epic Mashups"
            streamFormat: "mp3"
            Logo: "pkg:/images/SlightlyEpicMashups.jpg"
            Stream: "https://a6.asurahosting.com:6520/radio.mp3"
            MetaUrl: "https://a6.asurahosting.com:6520/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "EDM Techno Forever"
            streamFormat: "mp3"
            Logo: "pkg:/images/EDMTechnoForever.jpg"
            Stream: "http://ec1.yesstreaming.net:3500/stream"
            MetaUrl: "http://ec1.yesstreaming.net:3500/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Electronic Dance Radio"
            streamFormat: "mp3"
            Logo: "pkg:/images/EDR.jpg"
            Stream: "http://mpc1.mediacp.eu:18000/stream"
            MetaUrl: "http://mpc1.mediacp.eu:18000/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "The Epic Channel"
            streamFormat: "mp3"
            Logo: "pkg:/images/TheEpicChannel.jpg"
            Stream: "http://fra-pioneer08.dedicateware.com:1100/stream"
            MetaUrl: "http://fra-pioneer08.dedicateware.com:1100/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Classical Public Domain Radio"
            streamFormat: "mp3"
            Logo: "pkg:/images/ClassicalPublicDomainRadio.jpg"
            Stream: "http://relay.publicdomainradio.org/classical.mp3"
            MetaUrl: ""
            MetaType: "none"
        },
        {
            Title: "Cafe HD"
            streamFormat: "mp3"
            Logo: "pkg:/images/CafeHD.jpg"
            Stream: "http://live.playradio.org:9090/CafeHD"
            MetaUrl: "http://live.playradio.org:9090/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Zen Garden"
            streamFormat: "mp3"
            Logo: "pkg:/images/ZenGarden.jpg"
            Stream: "https://kathy.torontocast.com:3250/stream"
            MetaUrl: "https://kathy.torontocast.com:3250/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Alternative"
            streamFormat: "aac"
            Logo: "pkg:/images/Alternative.jpg"
            Stream: "http://stream.xrm.fm:8000/xrm-alt.aac"
            MetaUrl: "http://stream.xrm.fm:8000/7.html"
            MetaType: "shoutcast"
        }
    ]
    return arr
End Function
