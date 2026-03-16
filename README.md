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

| Station | Genre |
|---------|-------|
| **Slightly Epic Mashups** | Mashups / Multi-genre |
| **EDM Techno Forever** | EDM / Techno |
| **Electronic Dance Radio** | EDM |
| **The Epic Channel** | Progressive Rock |
| **Classical Public Domain Radio** | Classical |
| **Cafe HD** | Various |
| **Zen Garden** | New Age / Ambient |
| **Alternative** | Alternative Rock |

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
