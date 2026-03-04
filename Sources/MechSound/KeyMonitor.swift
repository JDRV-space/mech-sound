import Cocoa

final class KeyMonitor {
    private var monitor: Any?
    private let engine: SoundEngine
    var isEnabled: Bool = true

    init(engine: SoundEngine) {
        self.engine = engine
    }

    func start() {
        guard monitor == nil else { return }
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self, self.isEnabled else { return }
            self.engine.playForKeyCode(event.keyCode)
        }
    }

    func stop() {
        if let m = monitor {
            NSEvent.removeMonitor(m)
            monitor = nil
        }
    }

    deinit {
        stop()
    }
}
