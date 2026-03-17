# Slightly Epic Radio

![](images/SlightlyEpicRadioIcon.jpg)

An internet radio streaming app for Roku. Browse and listen to a curated selection of streaming radio stations directly on your Roku device.

## Features

- Stream internet radio stations in MP3 and AAC formats
- **Now Playing** — live song title and artist info pulled from station metadata (Icecast JSON and Shoutcast endpoints)
- Full-screen playback with station artwork
- **Infinite scrolling** station browser — wraps around seamlessly in both directions
- Simple remote-friendly navigation (UP to browse, DOWN to dismiss)

## Current Stations

| Icon | Station | Genre | Stream URL |
|------|---------|-------|------------|
| ![](images/SlightlyEpicMashups.jpg) | **Slightly Epic Mashups** | Mashups / Multi-genre | https://a6.asurahosting.com:6520/radio.mp3 |
| ![](images/KGLWbootlegger.png) | **K.G.L.W. Bootlegger** | Rock / Live Bootlegs | https://gizzradio.live/listen/listen/radio.mp3 |
| ![](images/EDMTechnoForever.jpg) | **EDM Techno Forever** | EDM / Techno | http://ec1.yesstreaming.net:3500/stream |
| ![](images/EDR.jpg) | **Electronic Dance Radio** | EDM | http://mpc1.mediacp.eu:18000/stream |
| ![](images/TheEpicChannel.jpg) | **The Epic Channel** | Progressive Rock | http://fra-pioneer08.dedicateware.com:1100/stream |
| ![](images/ClassicalPublicDomainRadio.jpg) | **Classical Public Domain Radio** | Classical | http://relay.publicdomainradio.org/classical.mp3 |
| ![](images/CafeHD.jpg) | **Cafe HD** | Various | http://live.playradio.org:9090/CafeHD |
| ![](images/BadlandsClassicRock.jpg) | **Badlands Classic Rock** | Classic Rock | http://ec3.yesstreaming.net:2040/stream |
| ![](images/UTurnClassicRock.jpg) | **UTurn Classic Rock** | Classic Rock | http://listen.uturnradio.com:7000/classic_rock |
| ![](images/Alternative.jpg) | **Alternative** | Alternative Rock | http://stream.xrm.fm:8000/xrm-alt.aac |
| ![](images/ChillLoungeRadio.jpg) | **Chill Lounge** | Chill / Lounge | http://harddanceradio.ddns.is74.ru:8000/lounge |
| ![](images/Time2ChillRadio.jpg) | **Time 2 Chill Radio** | Chill / Ambient | http://ec6.yesstreaming.net:3610/stream |
| ![](images/UltimateChillRadio.jpg) | **Ultimate Chill** | Chill Pop | http://ec1.yesstreaming.net:3290/stream |
| ![](images/ZenGarden.jpg) | **Zen Garden** | New Age / Ambient | https://kathy.torontocast.com:3250/stream |

## Getting Started

1. Enable [Developer Mode](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md) on your Roku device
2. Package or side-load the app to your Roku
3. The default station begins playing automatically — press UP to browse other stations

## Project Structure

```
source/
  main.brs                 - App entry point
components/
  HomeScene.xml            - Main scene layout (video player, row list, now playing bar, animations)
  HomeScene.brs            - Scene logic, key handling, and metadata display
  Config.brs               - Station feed configuration (streams, logos, metadata URLs)
  RowListItems.xml         - Row list item template
  tasks/
    RowListContentTask.brs - Async content loader (with wrap-around repetition)
    RowListContentTask.xml
    NowPlayingTask.brs     - Background metadata poller (Icecast/Shoutcast)
    NowPlayingTask.xml
images/                    - Station logos, splash screen, and icons
manifest                   - Roku channel metadata
```

## License

[Roku Developer Tools License Agreement](https://docs.roku.com/doc/developersdk/en-us)
