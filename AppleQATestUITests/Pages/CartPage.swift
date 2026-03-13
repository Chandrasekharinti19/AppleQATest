import XCTest

final class CartPage {

    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var screen: XCUIElement { app.otherElements["cart.screen"] }

    func waitForScreen(timeout: TimeInterval = 2) {
        XCTAssertTrue(screen.waitForExistence(timeout: timeout))
    }

    var emptyCartLabel: XCUIElement { app.staticTexts["emptyCartLabel"] }

    var subtotalLabel: XCUIElement { app.staticTexts["cartSubtotalLabel"] }

    var checkoutButton: XCUIElement { app.buttons["cart.checkoutButton"] }

    func increase(productID: String) {
        app.buttons["cart.increase.\(productID)"].tap()
    }

    func decrease(productID: String) {
        app.buttons["cart.decrease.\(productID)"].tap()
    }

    func quantityLabel(productID: String) -> XCUIElement {
        app.staticTexts["cart.qty.\(productID)"]
    }

    func row(productID: String) -> XCUIElement {
        app.otherElements["cart.row.\(productID)"]
    }

    func goToCheckout() {
        XCTAssertTrue(checkoutButton.waitForExistence(timeout: 2))
        checkoutButton.tap()
    }
}
