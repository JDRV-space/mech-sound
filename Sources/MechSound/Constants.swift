import Foundation

// MARK: - Key Codes

enum KeyCode: UInt16 {
    case space     = 49
    case `return`  = 36
    case numReturn = 76
    case delete    = 51

    static func regularIndex(for keyCode: UInt16) -> Int {
        Int(keyCode) % 12
    }
}

// MARK: - Pool Indices

enum PoolIndex {
    static let space     = 12
    static let enter     = 13
    static let backspace = 14
    static let count     = 15
}

// MARK: - Configuration

enum AppConfig {
    static let poolSize: Int     = 6
    static let volumeStep: Float = 0.1
    static let volumeMax: Float  = 1.5
    static let volumeMin: Float  = 0.0
    static let volumeDefault: Float = 1.0

    static let regularFiles: [String] = (1...12).map { "\($0)real.wav" }
    static let spaceFile     = "space.wav"
    static let enterFile     = "enter.wav"
    static let backspaceFile = "backspace.wav"

    static let bundleID = "com.mechsound"
    static let appName  = "MechSound"
}
