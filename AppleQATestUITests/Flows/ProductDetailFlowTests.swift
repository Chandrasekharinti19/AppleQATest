import XCTest

final class ProductDetailFlowTests: BaseUITestCase {

    private enum ProductIDs {
        static let iPhone = "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA"
    }

    func testAddConfiguredIPhoneToCart() {

        let login = LoginPage(app: app)
        login.login(email: "test@test.com", password: "123456")


        let products = ProductListPage(app: app)
        products.waitForScreen()

        // Open iPhone by row identifier, not text label
        products.openProduct(productID: ProductIDs.iPhone)

        let detail = ProductDetailPage(app: app)
        detail.waitForScreen()

        detail.selectVariant(named: "iPhone 17 Pro")

        XCTAssertTrue(detail.priceLabel.waitForExistence(timeout: 2))
        let priceBefore = detail.priceLabel.label

        detail.selectStorage("1TB")

        let priceAfter = detail.priceLabel.label
        XCTAssertNotEqual(priceBefore, priceAfter)

        detail.addToCart()
        detail.goToCartFromDialog()

        let cart = CartPage(app: app)
        cart.waitForScreen()

        XCTAssertTrue(cart.subtotalLabel.waitForExistence(timeout: 2))
    }
}
