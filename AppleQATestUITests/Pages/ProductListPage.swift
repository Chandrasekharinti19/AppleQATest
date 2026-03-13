import XCTest

final class ProductListPage {

    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var screen: XCUIElement {
        app.otherElements["products.screen"]
    }

    func waitForScreen(timeout: TimeInterval = 4) {
        dismissIfPresent(buttonTitle: "Not Now", timeout: 1)
        dismissIfPresent(buttonTitle: "Not Now", timeout: 1)
        //dismissIfPresent(buttonTitle: "Cancel", timeout: 1)

        XCTAssertTrue(screen.waitForExistence(timeout: timeout))
    }

    var cartButton: XCUIElement {
        app.buttons["goToCartButton"]
    }

    func goToCart() {
        XCTAssertTrue(cartButton.waitForExistence(timeout: 2))
        cartButton.tap()
    }

    func openProduct(productID: String) {
        let row = app.buttons["products.row.\(productID)"]
        XCTAssertTrue(row.waitForExistence(timeout: 2))
        row.tap()
    }

    private func dismissIfPresent(buttonTitle: String, timeout: TimeInterval) {
        let button = app.buttons[buttonTitle]
        if button.waitForExistence(timeout: timeout) {
            button.tap()
        }
    }
}
