import AVFoundation

final class SoundEngine {
    private var regularPools: [[AVAudioPlayer]] = []
    private var spacePools: [AVAudioPlayer] = []
    private var enterPools: [AVAudioPlayer] = []
    private var backspacePools: [AVAudioPlayer] = []
    private var poolIndex: [Int] = Array(repeating: 0, count: PoolIndex.count)

    private(set) var volume: Float = AppConfig.volumeDefault

    let soundDir: String

    init(soundDir: String) {
        self.soundDir = soundDir
    }

    // MARK: - Setup

    func loadSounds() {
        for file in AppConfig.regularFiles {
            regularPools.append(makePool(file: file))
        }
        spacePools     = makePool(file: AppConfig.spaceFile)
        enterPools     = makePool(file: AppConfig.enterFile)
        backspacePools = makePool(file: AppConfig.backspaceFile)
    }

    private func makePool(file: String) -> [AVAudioPlayer] {
        let url = URL(fileURLWithPath: "\(soundDir)/\(file)")
        var pool: [AVAudioPlayer] = []
        for _ in 0..<AppConfig.poolSize {
            guard let player = try? AVAudioPlayer(contentsOf: url) else { continue }
            player.prepareToPlay()
            player.volume = volume
            pool.append(player)
        }
        return pool
    }

    // MARK: - Playback

    func playForKeyCode(_ keyCode: UInt16) {
        switch keyCode {
        case KeyCode.space.rawValue:
            play(pool: spacePools, index: PoolIndex.space)
        case KeyCode.return.rawValue, KeyCode.numReturn.rawValue:
            play(pool: enterPools, index: PoolIndex.enter)
        case KeyCode.delete.rawValue:
            play(pool: backspacePools, index: PoolIndex.backspace)
        default:
            let idx = KeyCode.regularIndex(for: keyCode)
            guard idx < regularPools.count else { return }
            play(pool: regularPools[idx], index: idx)
        }
    }

    private func play(pool: [AVAudioPlayer], index: Int) {
        guard !pool.isEmpty else { return }
        let i = poolIndex[index] % pool.count
        poolIndex[index] = i + 1
        pool[i].currentTime = 0
        pool[i].play()
    }

    // MARK: - Volume

    func volumeUp() {
        volume = min(volume + AppConfig.volumeStep, AppConfig.volumeMax)
        applyVolume()
    }

    func volumeDown() {
        volume = max(volume - AppConfig.volumeStep, AppConfig.volumeMin)
        applyVolume()
    }

    var volumePercent: Int {
        Int(volume * 100)
    }

    private func applyVolume() {
        let allPools = regularPools + [spacePools, enterPools, backspacePools]
        for pool in allPools {
            for player in pool {
                player.volume = volume
            }
        }
    }

    // MARK: - Testable helpers

    static func clampVolume(_ v: Float) -> Float {
        min(max(v, AppConfig.volumeMin), AppConfig.volumeMax)
    }

    static func wrapPoolIndex(_ index: Int, poolSize: Int) -> Int {
        guard poolSize > 0 else { return 0 }
        return index % poolSize
    }

    static func poolForKeyCode(_ keyCode: UInt16) -> Int {
        switch keyCode {
        case KeyCode.space.rawValue:                         return PoolIndex.space
        case KeyCode.return.rawValue, KeyCode.numReturn.rawValue: return PoolIndex.enter
        case KeyCode.delete.rawValue:                        return PoolIndex.backspace
        default:                                             return KeyCode.regularIndex(for: keyCode)
        }
    }
}
