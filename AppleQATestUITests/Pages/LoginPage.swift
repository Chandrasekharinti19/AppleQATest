import XCTest

final class LoginPage {

    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var screen: XCUIElement {
        app.otherElements["login.screen"]
    }

    var emailField: XCUIElement {
        app.textFields["login.emailTextField"]
    }

    var passwordField: XCUIElement {
        app.secureTextFields["login.passwordTextField"]
    }

    var loginButton: XCUIElement {
        app.buttons["login.loginButton"]
    }

    func waitForScreen(timeout: TimeInterval = 3) {
        XCTAssertTrue(screen.waitForExistence(timeout: timeout))
        XCTAssertTrue(emailField.waitForExistence(timeout: timeout))
        XCTAssertTrue(passwordField.waitForExistence(timeout: timeout))
    }

    func login(email: String, password: String) {
        waitForScreen()

        emailField.tap()
        emailField.typeText(email)

        passwordField.tap()
        passwordField.typeText(password)

        dismissKeyboardIfPresent()

        XCTAssertTrue(loginButton.waitForExistence(timeout: 2))
        loginButton.tap()
    }

    private func dismissKeyboardIfPresent() {
        let returnKey = app.keyboards.buttons["Return"]
        if returnKey.exists {
            returnKey.tap()
        } else {
            app.tap()
        }
    }
}
