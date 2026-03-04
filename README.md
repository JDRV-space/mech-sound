<div align="center">

# MechSound

**Native macOS keyboard sounds. No Electron. No iohook. Just Swift.**

[![Swift](https://img.shields.io/badge/Swift-5.9+-F05138?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![macOS](https://img.shields.io/badge/macOS-13+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos)
[![Apple Silicon](https://img.shields.io/badge/Apple_Silicon-Native-333333?style=for-the-badge&logo=apple&logoColor=white)](https://support.apple.com/en-us/116943)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

</div>

---

## Why MechSound?

I switched from Opera GX to [Brave](https://brave.com) for better privacy and security. I miss the mechanical keyboard sounds that came with Opera GX. Every alternative I tried was broken on Apple Silicon:

- **Mechvibes** depends on `iohook`, which is x64-only. Dead on M1+.
- **rustyvibes** uses `CGEventTap`, which macOS 15+ revokes without an entitlement most open-source apps cannot get.
- **Electron-based apps** are 200MB+ for something that should play a WAV file when you press a key.

MechSound is 15 files of Swift. It uses `NSEvent.addGlobalMonitorForEvents`, which works with standard Accessibility permissions. No Electron runtime, no native module compilation, no entitlement hacks.

## Features

| Feature | Details |
|---------|---------|
| Native Swift | No Electron, no Node, no Rust FFI |
| Apple Silicon | arm64 native, zero Rosetta |
| Low latency | Pre-loaded AVAudioPlayer pools (6 per key class) |
| Menu bar control | Toggle on/off, volume up/down, quit |
| Auto-start | launchd agent with RunAtLoad + KeepAlive |
| Custom sounds | Point to any directory of WAV files |
| Tiny footprint | Single binary + WAV files |

## Install

```bash
git clone https://github.com/JDRV-space/mech-sound.git
cd mech-sound
make install
```

After install, grant Accessibility access:

> System Settings > Privacy & Security > Accessibility > enable **MechSound**

## Build Only

```bash
make build          # compile release binary
make run            # build and run (without installing)
make test           # run unit tests
make clean          # remove build artifacts
```

## Uninstall

```bash
make uninstall
```

This removes the app from `/Applications` and the launchd agent.

## Architecture

```
                    +-----------------+
                    |   main.swift    |
                    |  (entry point)  |
                    +--------+--------+
                             |
                    +--------v--------+
                    |  AppDelegate    |
                    |  (menu bar UI)  |
                    +---+--------+----+
                        |        |
              +---------v--+  +--v-----------+
              | KeyMonitor |  | SoundEngine  |
              | (NSEvent)  |  | (AVAudio)    |
              +------------+  +---------+----+
                                        |
                              +---------v----+
                              |  Constants   |
                              |  (config)    |
                              +--------------+
```

**KeyMonitor** listens for global `keyDown` events via `NSEvent.addGlobalMonitorForEvents`. Each keypress is routed to **SoundEngine**, which maintains pre-loaded audio player pools for low-latency playback. Special keys (space, return, delete) have dedicated sound files; all other keys are distributed across 12 regular sound pools using modulo mapping.

## Sound Packs

MechSound ships with the Opera GX mechanical keyboard sound pack. To use a custom pack, pass the directory as a CLI argument:

```bash
.build/release/MechSound /path/to/your/sounds
```

Your sound directory should contain:
- `1real.wav` through `12real.wav` (regular keys)
- `space.wav`
- `enter.wav`
- `backspace.wav`

## Requirements

- macOS 13+ (Ventura or later)
- Swift 5.9+
- Accessibility permission (for global key monitoring)

## License

[MIT](LICENSE)
