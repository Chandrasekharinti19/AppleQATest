import XCTest

final class CartQuantityTests: BaseUITestCase {

    private enum ProductIDs {
        static let iPhone = "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA"
    }

    func testIncreaseAndDecreaseQuantityInCart() {
        let login = LoginPage(app: app)
        login.login(email: "test@test.com", password: "123456")
        
        dismissIfPresent(buttonTitle: "Not Now", timeout: 2)
        dismissIfPresent(buttonTitle: "Not Now", timeout: 2)
        dismissIfPresent(buttonTitle: "Cancel", timeout: 1)

        let products = ProductListPage(app: app)
        products.waitForScreen()

        products.openProduct(productID: ProductIDs.iPhone)

        let detail = ProductDetailPage(app: app)
        detail.waitForScreen()

        detail.selectVariant(named: "iPhone 17 Pro")
        detail.selectStorage("512GB")

        detail.addToCart()
        detail.goToCartFromDialog()

        let cart = CartPage(app: app)
        cart.waitForScreen()

        let increaseButton = firstCartIncreaseButton()
        XCTAssertTrue(increaseButton.waitForExistence(timeout: 2))

        let decreaseButton = firstCartDecreaseButton()
        XCTAssertTrue(decreaseButton.waitForExistence(timeout: 2))

        let qtyLabel = firstCartQuantityLabel()
        XCTAssertTrue(qtyLabel.waitForExistence(timeout: 2))
        XCTAssertEqual(qtyLabel.label, "1")

        increaseButton.tap()
        XCTAssertEqual(qtyLabel.label, "2")

        decreaseButton.tap()
        XCTAssertEqual(qtyLabel.label, "1")
    }

    private func firstCartQuantityLabel() -> XCUIElement {
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "cart.qty.")
        return app.descendants(matching: .any).matching(predicate).firstMatch
    }

    private func firstCartIncreaseButton() -> XCUIElement {
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "cart.increase.")
        return app.descendants(matching: .any).matching(predicate).firstMatch
    }

    private func firstCartDecreaseButton() -> XCUIElement {
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "cart.decrease.")
        return app.descendants(matching: .any).matching(predicate).firstMatch
    }

    private func dismissIfPresent(buttonTitle: String, timeout: TimeInterval) {
        let button = app.buttons[buttonTitle]
        if button.waitForExistence(timeout: timeout) {
            button.tap()
        }
    }
}
