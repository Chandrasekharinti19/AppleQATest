import XCTest

final class CheckoutPage {

    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    // Screen

    var screen: XCUIElement {
        app.otherElements["checkout.screen"]
    }

    func waitForScreen(timeout: TimeInterval = 2) {
        XCTAssertTrue(screen.waitForExistence(timeout: timeout))
    }

    // Shipping / Profile

    var shippingSummary: XCUIElement {
        app.otherElements["checkout.shippingSummary"]
    }

    var editProfileButton: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "checkout.editProfileButton").firstMatch
    }

    var profileWarningLabel: XCUIElement {
        app.staticTexts["checkout.profileWarningLabel"]
    }

    func editProfile() {
        XCTAssertTrue(editProfileButton.waitForExistence(timeout: 2))
        editProfileButton.tap()
    }

    // Payment

    var paymentSummary: XCUIElement {
        app.otherElements["checkout.paymentSummary"]
    }

    var editPaymentButton: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "checkout.editPaymentButton").firstMatch
    }
    var paymentWarningLabel: XCUIElement {
        app.staticTexts["checkout.paymentWarningLabel"]
    }

    func editPayment() {
        XCTAssertTrue(editPaymentButton.waitForExistence(timeout: 2))
        editPaymentButton.tap()
    }

    // Promo

    var promoField: XCUIElement {
        app.textFields["checkout.promoField"]
    }

    var applyPromoButton: XCUIElement {
        app.buttons["checkout.applyPromoButton"]
    }

    var promoStatusLabel: XCUIElement {
        app.staticTexts["checkout.promoStatusLabel"]
    }

    func applyPromo(_ code: String) {
        XCTAssertTrue(promoField.waitForExistence(timeout: 2))
        promoField.tap()
        promoField.typeText(code)
        applyPromoButton.tap()
    }

    // Breakdown Rows

    var subtotalRow: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "checkout.subtotalLabel").firstMatch
    }

    var discountRow: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "checkout.discountLabel").firstMatch
    }

    var shippingRow: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "checkout.shippingLabel").firstMatch
    }

    var freeShippingRow: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "checkout.shippingDiscountLabel").firstMatch
    }

    var taxRow: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "checkout.taxLabel").firstMatch
    }

    var totalRow: XCUIElement {
        app.descendants(matching: .any).matching(identifier: "checkout.totalLabel").firstMatch
    }

    // Place Order

    var placeOrderButton: XCUIElement {
        app.buttons["checkout.placeOrderButton"]
    }

    var successLabel: XCUIElement {
        app.staticTexts["checkout.successLabel"]
    }

    func placeOrder() {
        XCTAssertTrue(placeOrderButton.waitForExistence(timeout: 2))
        placeOrderButton.tap()
    }

    // Convenience Assertions

    func assertShippingIsDisplayed() {
        XCTAssertTrue(shippingRow.waitForExistence(timeout: 2))
    }

    func assertFreeShippingDisplayed() {
        XCTAssertTrue(freeShippingRow.waitForExistence(timeout: 2))
    }

    func assertProfileWarningDisplayed() {
        XCTAssertTrue(profileWarningLabel.waitForExistence(timeout: 2))
    }

    func assertPaymentWarningDisplayed() {
        XCTAssertTrue(paymentWarningLabel.waitForExistence(timeout: 2))
    }
}
