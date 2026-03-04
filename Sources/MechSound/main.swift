import Cocoa

// Resolve sound directory: CLI arg → bundle resource → default fallback
let soundDir: String = {
    if CommandLine.arguments.count > 1 {
        return CommandLine.arguments[1]
    }
    if let bundled = Bundle.main.resourcePath {
        let bundledSounds = "\(bundled)/sounds/opera-gx"
        if FileManager.default.fileExists(atPath: bundledSounds) {
            return bundledSounds
        }
    }
    return "\(NSHomeDirectory())/mechvibes_custom/opera-gx"
}()

let delegate = AppDelegate(soundDir: soundDir)
let app = NSApplication.shared
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
