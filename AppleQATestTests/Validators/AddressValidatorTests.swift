import XCTest
@testable import AppleQATest

final class AddressValidatorTests: XCTestCase {

    func testValidAddressReturnsTrue() {
        XCTAssertTrue(AddressValidator.isValid("1 Apple Park Way, Cupertino, CA"))
    }

    func testEmptyAddressReturnsFalse() {
        XCTAssertFalse(AddressValidator.isValid(""))
    }

    func testWhitespaceOnlyReturnsFalse() {
        XCTAssertFalse(AddressValidator.isValid("   \n  "))
    }

    func testTrimsWhitespaceAndNewlines() {
        XCTAssertTrue(AddressValidator.isValid("  1 Infinite Loop  \n"))
    }
}
