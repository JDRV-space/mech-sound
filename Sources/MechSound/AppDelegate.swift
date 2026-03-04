import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var volumeMenuItem: NSMenuItem!
    private var engine: SoundEngine!
    private var keyMonitor: KeyMonitor!

    private let soundDir: String

    init(soundDir: String) {
        self.soundDir = soundDir
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        engine = SoundEngine(soundDir: soundDir)
        engine.loadSounds()

        keyMonitor = KeyMonitor(engine: engine)
        keyMonitor.start()

        setupMenuBar()
    }

    // MARK: - Menu Bar

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "⌨️"

        let menu = NSMenu()

        let toggleItem = NSMenuItem(title: "Enabled", action: #selector(toggle), keyEquivalent: "")
        toggleItem.target = self
        toggleItem.state = .on
        menu.addItem(toggleItem)

        menu.addItem(.separator())

        volumeMenuItem = NSMenuItem(title: "Volume: \(engine.volumePercent)%", action: nil, keyEquivalent: "")
        volumeMenuItem.isEnabled = false
        menu.addItem(volumeMenuItem)

        let upItem = NSMenuItem(title: "Volume Up", action: #selector(volUp), keyEquivalent: "")
        upItem.target = self
        menu.addItem(upItem)

        let downItem = NSMenuItem(title: "Volume Down", action: #selector(volDown), keyEquivalent: "")
        downItem.target = self
        menu.addItem(downItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    // MARK: - Actions

    @objc private func toggle(_ sender: NSMenuItem) {
        keyMonitor.isEnabled.toggle()
        sender.state = keyMonitor.isEnabled ? .on : .off
        statusItem.button?.title = keyMonitor.isEnabled ? "⌨️" : "🔇"
    }

    @objc private func volUp(_ sender: NSMenuItem) {
        engine.volumeUp()
        volumeMenuItem.title = "Volume: \(engine.volumePercent)%"
    }

    @objc private func volDown(_ sender: NSMenuItem) {
        engine.volumeDown()
        volumeMenuItem.title = "Volume: \(engine.volumePercent)%"
    }

    @objc private func quit(_ sender: NSMenuItem) {
        NSApp.terminate(nil)
    }
}
