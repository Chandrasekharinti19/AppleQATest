import XCTest

final class OrderPlacementTests: BaseUITestCase {

    private enum ProductIDs {
        static let iPad = "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB"
    }

    func testUserCanPlaceOrderAndCartIsCleared() {
        // Login
        let login = LoginPage(app: app)
        login.login(email: "test@test.com", password: "123456")

        //dismissIfPresent(buttonTitle: "Not Now", timeout: 2)
        //dismissIfPresent(buttonTitle: "Not Now
        // Product Detail
        let detail = ProductDetailPage(app: app)
        detail.waitForScreen()

        detail.selectVariant(named: "iPad Pro")
        detail.selectStorage("512GB")

        detail.addToCart()
        detail.goToCartFromDialog()

        // Cart
        let cart = CartPage(app: app)
        cart.waitForScreen()
        XCTAssertTrue(cart.subtotalLabel.waitForExistence(timeout: 2))

        cart.goToCheckout()

        // Checkout
        let checkout = CheckoutPage(app: app)
        checkout.waitForScreen()
        XCTAssertTrue(checkout.totalRow.waitForExistence(timeout: 2))

        // Fill Profile
        let editProfileButton = app.buttons["checkout.editProfileButton"]
        XCTAssertTrue(editProfileButton.waitForExistence(timeout: 2))
        editProfileButton.tap()

        fillProfile(
            firstName: "Tim",
            lastName: "Cook",
            phone: "1234567890",
            email: "tim@apple.com",
            address: "1 Apple Park Way"
        )

        // Back to Checkout
        app.navigationBars.buttons.element(boundBy: 0).tap()
        checkout.waitForScreen()

        // Fill Payment
        let editPaymentButton = app.buttons["checkout.editPaymentButton"]
        XCTAssertTrue(editPaymentButton.waitForExistence(timeout: 2))
        editPaymentButton.tap()

        fillPayment(
            cardholderName: "Tim Cook",
            cardNumber: "4111111111111111",
            expiryMonth: "12",
            expiryYear: "2030",
            cvv: "123"
        )

        // Back to Checkout
        app.navigationBars.buttons.element(boundBy: 0).tap()
        checkout.waitForScreen()

        // Place Order
        checkout.placeOrder()

        XCTAssertTrue(checkout.successLabel.waitForExistence(timeout: 2))

        // Go back to Cart
        app.navigationBars.buttons.element(boundBy: 0).tap()

        XCTAssertTrue(cart.emptyCartLabel.waitForExistence(timeout: 2))
    }

    // MARK: - Helpers

    private func fillProfile(
        firstName: String,
        lastName: String,
        phone: String,
        email: String,
        address: String
    ) {
        let firstNameField = app.textFields["profile.firstNameField"]
        XCTAssertTrue(firstNameField.waitForExistence(timeout: 2))
        firstNameField.tap()
        firstNameField.typeText(firstName)

        let lastNameField = app.textFields["profile.lastNameField"]
        XCTAssertTrue(lastNameField.waitForExistence(timeout: 2))
        lastNameField.tap()
        lastNameField.typeText(lastName)

        let phoneField = app.textFields["profile.phoneField"]
        XCTAssertTrue(phoneField.waitForExistence(timeout: 2))
        phoneField.tap()
        phoneField.typeText(phone)

        let emailField = app.textFields["profile.emailField"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 2))
        emailField.tap()
        emailField.typeText(email)

        let addressField = app.textFields["profile.addressField"]
        XCTAssertTrue(addressField.waitForExistence(timeout: 2))
        addressField.tap()
        addressField.typeText(address)

        dismissKeyboardIfPresent()

        let saveButton = app.buttons["profile.saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()

        let status = app.staticTexts["profile.statusLabel"]
        XCTAssertTrue(status.waitForExistence(timeout: 2))
        XCTAssertEqual(status.label, "Saved")
    }

    private func fillPayment(
        cardholderName: String,
        cardNumber: String,
        expiryMonth: String,
        expiryYear: String,
        cvv: String
    ) {
        let cardholderField = app.textFields["payment.cardholderField"]
        XCTAssertTrue(cardholderField.waitForExistence(timeout: 2))
        cardholderField.tap()
        cardholderField.typeText(cardholderName)

        let cardNumberField = app.textFields["payment.cardNumberField"]
        XCTAssertTrue(cardNumberField.waitForExistence(timeout: 2))
        cardNumberField.tap()
        cardNumberField.typeText(cardNumber)

        let expiryMonthField = app.textFields["payment.expiryMonthField"]
        XCTAssertTrue(expiryMonthField.waitForExistence(timeout: 2))
        expiryMonthField.tap()
        expiryMonthField.typeText(expiryMonth)

        let expiryYearField = app.textFields["payment.expiryYearField"]
        XCTAssertTrue(expiryYearField.waitForExistence(timeout: 2))
        expiryYearField.tap()
        expiryYearField.typeText(expiryYear)

        let cvvField = app.secureTextFields["payment.cvvField"]
        XCTAssertTrue(cvvField.waitForExistence(timeout: 2))
        cvvField.tap()
        cvvField.typeText(cvv)

        dismissKeyboardIfPresent()

        let saveButton = app.buttons["payment.saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        saveButton.tap()

        let status = app.staticTexts["payment.statusLabel"]
        XCTAssertTrue(status.waitForExistence(timeout: 2))
        XCTAssertEqual(status.label, "Saved")
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
