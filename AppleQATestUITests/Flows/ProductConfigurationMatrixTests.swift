import XCTest

final class ProductConfigurationMatrixTests: BaseUITestCase {

    private enum ProductIDs {
        static let iPhone = "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA"
    }

    private let variants = [
        "iPhone 17",
        "iPhone 17 Pro",
        "iPhone 17 Pro Max"
    ]

    func testAllVisibleIPhoneConfigurations() {
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

        for variant in variants {
            detail.selectVariant(named: variant)

            let colors = detail.readAllColorOptions()
            XCTAssertFalse(colors.isEmpty, "No colors found for variant: \(variant)")

            for color in colors {
                detail.selectColor(color)

                let storageOptions = detail.readAllStorageOptions()
                XCTAssertFalse(storageOptions.isEmpty, "No storage options found for variant: \(variant), color: \(color)")

                for storage in storageOptions {
                    detail.selectStorage(storage)

                    XCTAssertTrue(detail.priceLabel.waitForExistence(timeout: 2))
                    XCTAssertFalse(detail.priceLabel.label.isEmpty)
                }
            }
        }
    }
    private func dismissIfPresent(buttonTitle: String, timeout: TimeInterval) {
        let button = app.buttons[buttonTitle]
        if button.waitForExistence(timeout: timeout) {
            button.tap()
        }
    }
}
