import XCTest
@testable import MechSound

final class KeyMonitorTests: XCTestCase {

    // MARK: - Key Code Mapping

    func testSpecialKeyCodes() {
        XCTAssertEqual(KeyCode.space.rawValue, 49)
        XCTAssertEqual(KeyCode.return.rawValue, 36)
        XCTAssertEqual(KeyCode.numReturn.rawValue, 76)
        XCTAssertEqual(KeyCode.delete.rawValue, 51)
    }

    func testRegularIndexMapping() {
        // All keycodes map to 0-11 via modulo
        for code: UInt16 in 0..<128 {
            let idx = KeyCode.regularIndex(for: code)
            XCTAssertTrue(idx >= 0 && idx < 12, "keyCode \(code) mapped to \(idx)")
        }
    }

    func testRegularIndexDeterministic() {
        // Same keycode always maps to same index
        let idx1 = KeyCode.regularIndex(for: 42)
        let idx2 = KeyCode.regularIndex(for: 42)
        XCTAssertEqual(idx1, idx2)
    }

    // MARK: - Pool Index Constants

    func testPoolIndexValues() {
        XCTAssertEqual(PoolIndex.space, 12)
        XCTAssertEqual(PoolIndex.enter, 13)
        XCTAssertEqual(PoolIndex.backspace, 14)
        XCTAssertEqual(PoolIndex.count, 15)
    }

    func testPoolIndexCountCoversAll() {
        // 12 regular + space + enter + backspace = 15
        XCTAssertEqual(PoolIndex.count, 12 + 3)
    }
}
