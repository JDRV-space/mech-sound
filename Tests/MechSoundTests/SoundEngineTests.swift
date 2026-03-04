import XCTest
@testable import MechSound

final class SoundEngineTests: XCTestCase {

    // MARK: - Volume Clamping

    func testClampVolumeAtMax() {
        XCTAssertEqual(SoundEngine.clampVolume(2.0), AppConfig.volumeMax)
    }

    func testClampVolumeAtMin() {
        XCTAssertEqual(SoundEngine.clampVolume(-1.0), AppConfig.volumeMin)
    }

    func testClampVolumeInRange() {
        XCTAssertEqual(SoundEngine.clampVolume(0.5), 0.5)
    }

    func testClampVolumeAtBoundary() {
        XCTAssertEqual(SoundEngine.clampVolume(AppConfig.volumeMax), AppConfig.volumeMax)
        XCTAssertEqual(SoundEngine.clampVolume(AppConfig.volumeMin), AppConfig.volumeMin)
    }

    // MARK: - Pool Index Wrapping

    func testPoolIndexWraps() {
        XCTAssertEqual(SoundEngine.wrapPoolIndex(6, poolSize: 6), 0)
        XCTAssertEqual(SoundEngine.wrapPoolIndex(7, poolSize: 6), 1)
        XCTAssertEqual(SoundEngine.wrapPoolIndex(12, poolSize: 6), 0)
    }

    func testPoolIndexNoWrap() {
        XCTAssertEqual(SoundEngine.wrapPoolIndex(0, poolSize: 6), 0)
        XCTAssertEqual(SoundEngine.wrapPoolIndex(5, poolSize: 6), 5)
    }

    func testPoolIndexEmptyPool() {
        XCTAssertEqual(SoundEngine.wrapPoolIndex(3, poolSize: 0), 0)
    }

    // MARK: - Keycode to Pool Mapping

    func testSpaceKeyMapsToSpacePool() {
        XCTAssertEqual(SoundEngine.poolForKeyCode(49), PoolIndex.space)
    }

    func testReturnKeyMapsToEnterPool() {
        XCTAssertEqual(SoundEngine.poolForKeyCode(36), PoolIndex.enter)
    }

    func testNumpadReturnMapsToEnterPool() {
        XCTAssertEqual(SoundEngine.poolForKeyCode(76), PoolIndex.enter)
    }

    func testDeleteKeyMapsToBackspacePool() {
        XCTAssertEqual(SoundEngine.poolForKeyCode(51), PoolIndex.backspace)
    }

    func testRegularKeyMapsToModuloPool() {
        // keyCode 0 (A) -> 0 % 12 = 0
        XCTAssertEqual(SoundEngine.poolForKeyCode(0), 0)
        // keyCode 13 (W) -> 13 % 12 = 1
        XCTAssertEqual(SoundEngine.poolForKeyCode(13), 1)
        // keyCode 24 -> 24 % 12 = 0
        XCTAssertEqual(SoundEngine.poolForKeyCode(24), 0)
    }
}
