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
            Title: "K.G.L.W. Bootlegger"
            streamFormat: "mp3"
            Logo: "pkg:/images/KGLWbootlegger.png"
            Stream: "https://gizzradio.live/listen/listen/radio.mp3"
            MetaUrl: "https://gizzradio.live/listen/listen/status-json.xsl"
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
            Title: "Classical Public Domain Radio"
            streamFormat: "mp3"
            Logo: "pkg:/images/ClassicalPublicDomainRadio.jpg"
            Stream: "http://relay.publicdomainradio.org/classical.mp3"
            MetaUrl: ""
            MetaType: "none"
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
            Title: "Badlands Classic Rock"
            streamFormat: "aac"
            Logo: "pkg:/images/BadlandsClassicRock.jpg"
            Stream: "http://ec3.yesstreaming.net:2040/stream"
            MetaUrl: "http://ec3.yesstreaming.net:2040/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "UTurn Classic Rock"
            streamFormat: "mp3"
            Logo: "pkg:/images/UTurnClassicRock.jpg"
            Stream: "http://listen.uturnradio.com:7000/classic_rock"
            MetaUrl: "http://listen.uturnradio.com:7000/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Alternative"
            streamFormat: "aac"
            Logo: "pkg:/images/Alternative.jpg"
            Stream: "http://stream.xrm.fm:8000/xrm-alt.aac"
            MetaUrl: "http://stream.xrm.fm:8000/7.html"
            MetaType: "shoutcast"
        },
        {
            Title: "Stacey Radio"
            streamFormat: "mp3"
            Logo: "pkg:/images/Stacey_Radio.jpg"
            Stream: "http://stacey-campbell.com:8001/dadradio.mp3"
            MetaUrl: "http://stacey-campbell.com:8001/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "SOL FM"
            streamFormat: "aac"
            Logo: "pkg:/images/SOL_FM.jpg"
            Stream: "http://radiosolfm.bounceme.net:8002/solfm"
            MetaUrl: "http://radiosolfm.bounceme.net:8002/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Chill Lounge"
            streamFormat: "aac"
            Logo: "pkg:/images/ChillLoungeRadio.jpg"
            Stream: "http://harddanceradio.ddns.is74.ru:8000/lounge"
            MetaUrl: "http://harddanceradio.ddns.is74.ru:8000/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Time 2 Chill Radio"
            streamFormat: "mp3"
            Logo: "pkg:/images/Time2ChillRadio.jpg"
            Stream: "http://ec6.yesstreaming.net:3610/stream"
            MetaUrl: "http://ec6.yesstreaming.net:3610/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Ultimate Chill (Pop)"
            streamFormat: "mp3"
            Logo: "pkg:/images/UltimateChillRadio.jpg"
            Stream: "http://ec1.yesstreaming.net:3290/stream"
            MetaUrl: "http://ec1.yesstreaming.net:3290/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "The Jazz Groove"
            streamFormat: "mp3"
            Logo: "pkg:/images/the_jazz_groove.png"
            Stream: "https://audio-edge-es6pf.mia.g.radiomast.io/8a384ff3-6fd1-4e5d-b47d-0cbefeffe8d7"
            MetaUrl: ""
            MetaType: "none"
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
            Title: "Synthetic FM"
            streamFormat: "mp3"
            Logo: "pkg:/images/synthetic_fm.png"
            Stream: "http://stream.syntheticfm.com:8040/live"
            MetaUrl: "http://stream.syntheticfm.com:8040/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Synthetic FM (ITA)"
            streamFormat: "mp3"
            Logo: "pkg:/images/synthetic_fm_ita.jpg"
            Stream: "http://stream.syntheticfm.com:8030/stream"
            MetaUrl: "http://stream.syntheticfm.com:8030/status-json.xsl"
            MetaType: "icecast"
        },
        {
            Title: "Radio Popolare (ITA)"
            streamFormat: "mp3"
            Logo: "pkg:/images/Radio Popolare Milano.png"
            Stream: "https://livex.radiopopolare.it/radiopop"
            MetaUrl: ""
            MetaType: "none"
        }
    ]
    return arr
End Function
