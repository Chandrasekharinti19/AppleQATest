import XCTest

final class ProfileAddressPersistenceTests: BaseUITestCase {

    func testUserCanSaveProfileAndItPersists() {
        // Login
        let login = LoginPage(app: app)
        login.login(email: "test@test.com", password: "123456")

        dismissIfPresent(buttonTitle: "Not Now", timeout: 2)
        dismissIfPresent(buttonTitle: "Not Now", timeout: 2)
        dismissIfPresent(buttonTitle: "Cancel", timeout: 1)


        // Products
        let products = ProductListPage(app: app)
        products.waitForScreen()

        // Open Profile
        let profileButton = app.buttons["products.profileButton"]
        XCTAssertTrue(profileButton.waitForExistence(timeout: 2))
        profileButton.tap()

        // Profile fields
        let firstNameField = app.textFields["profile.firstNameField"]
        XCTAssertTrue(firstNameField.waitForExistence(timeout: 2))
        firstNameField.tap()
        firstNameField.typeText("Tim")

        let lastNameField = app.textFields["profile.lastNameField"]
        XCTAssertTrue(lastNameField.waitForExistence(timeout: 2))
        lastNameField.tap()
        lastNameField.typeText("Cook")

        let phoneField = app.textFields["profile.phoneField"]
        XCTAssertTrue(phoneField.waitForExistence(timeout: 2))
        phoneField.tap()
        phoneField.typeText("1234567890")

        let emailField = app.textFields["profile.emailField"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 2))
        emailField.tap()
        emailField.typeText("tim@apple.com")

        let addressField = app.textFields["profile.addressField"]
        XCTAssertTrue(addressField.waitForExistence(timeout: 2))
        addressField.tap()
        addressField.typeText("1 Apple Park Way")

        dismissKeyboardIfPresent()

        let saveButton = app.buttons["profile.saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()

        let status = app.staticTexts["profile.statusLabel"]
        XCTAssertTrue(status.waitForExistence(timeout: 2))
        XCTAssertEqual(status.label, "Saved")

        // Go back to Products
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Re-open Profile
        XCTAssertTrue(profileButton.waitForExistence(timeout: 2))
        profileButton.tap()

        let currentProfile = app.staticTexts["profile.currentAddressLabel"]
        XCTAssertTrue(currentProfile.waitForExistence(timeout: 2))
        XCTAssertTrue(currentProfile.label.contains("Tim Cook"))
        XCTAssertTrue(currentProfile.label.contains("1 Apple Park Way"))
    }

    private func dismissIfPresent(buttonTitle: String, timeout: TimeInterval) {
        let button = app.buttons[buttonTitle]
        if button.waitForExistence(timeout: timeout) {
            button.tap()
        }
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
