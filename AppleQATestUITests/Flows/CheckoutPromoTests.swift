import XCTest

final class CheckoutPromoTests: BaseUITestCase {

    private enum ProductIDs {
        static let macBook = "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC"
    }

    func testApplyingPromoUpdatesCheckoutTotal() {
        // Login
        let login = LoginPage(app: app)
        login.login(email: "test@test.com", password: "123456")

        dismissIfPresent(buttonTitle: "Not Now", timeout: 2)
        dismissIfPresent(buttonTitle: "Not Now", timeout: 2)
        dismissIfPresent(buttonTitle: "Cancel", timeout: 1)

        // Products
        let products = ProductListPage(app: app)
        products.waitForScreen()

        // Open MacBook
        products.openProduct(productID: ProductIDs.macBook)

        // Product Detail
        let detail = ProductDetailPage(app: app)
        detail.waitForScreen()

        detail.selectVariant(named: "MacBook Pro")
        detail.selectStorage("1TB")

        detail.addToCart()
        detail.goToCartFromDialog()

        // Cart
        let cart = CartPage(app: app)
        cart.waitForScreen()
        cart.goToCheckout()

        // Checkout
        let checkout = CheckoutPage(app: app)
        checkout.waitForScreen()

        XCTAssertTrue(checkout.shippingRow.waitForExistence(timeout: 2))
        XCTAssertTrue(checkout.freeShippingRow.waitForExistence(timeout: 2))

        let totalBefore = checkout.totalRow.label

        checkout.applyPromo("APPLE10")

        XCTAssertTrue(checkout.promoStatusLabel.waitForExistence(timeout: 2))
        XCTAssertEqual(checkout.promoStatusLabel.label, "Applied")

        let totalAfter = checkout.totalRow.label
        XCTAssertNotEqual(totalBefore, totalAfter)
    }

    func testInvalidPromoShowsErrorMessage() {
        // Login
        let login = LoginPage(app: app)
        login.login(email: "test@test.com", password: "123456")

        dismissIfPresent(buttonTitle: "Not Now", timeout: 2)
        dismissIfPresent(buttonTitle: "Not Now", timeout: 2)
        dismissIfPresent(buttonTitle: "Cancel", timeout: 1)


        // Products
        let products = ProductListPage(app: app)
        products.waitForScreen()

        // Open MacBook
        products.openProduct(productID: ProductIDs.macBook)

        // Product Detail
        let detail = ProductDetailPage(app: app)
        detail.waitForScreen()

        detail.selectVariant(named: "MacBook Air")
        detail.selectStorage("512GB")

        detail.addToCart()
        detail.goToCartFromDialog()

        // Cart
        let cart = CartPage(app: app)
        cart.waitForScreen()
        cart.goToCheckout()

        // Checkout
        let checkout = CheckoutPage(app: app)
        checkout.waitForScreen()

        checkout.applyPromo("BADCODE")

        XCTAssertTrue(checkout.promoStatusLabel.waitForExistence(timeout: 2))
        XCTAssertEqual(checkout.promoStatusLabel.label, "Invalid code")
    }

    // Helpers

    private func dismissIfPresent(buttonTitle: String, timeout: TimeInterval) {
        let button = app.buttons[buttonTitle]
        if button.waitForExistence(timeout: timeout) {
            button.tap()
        }
    }
}
