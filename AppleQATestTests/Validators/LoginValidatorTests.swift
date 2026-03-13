import XCTest
@testable import AppleQATest

final class LoginValidatorTests: XCTestCase {

    func testValidCredentialsReturnTrue() {
        XCTAssertTrue(LoginValidator.validate(email: "test@test.com", password: "123456"))
    }

    func testInvalidEmailReturnsFalse() {
        XCTAssertFalse(LoginValidator.validate(email: "bademail", password: "123456"))
    }

    func testShortPasswordReturnsFalse() {
        XCTAssertFalse(LoginValidator.validate(email: "test@test.com", password: "123"))
    }

    func testTrimmingWhitespace() {
        XCTAssertTrue(LoginValidator.validate(email: " test@test.com ", password: " 123456 "))
    }
}
