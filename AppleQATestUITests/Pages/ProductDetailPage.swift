import XCTest

final class ProductDetailPage {

    private let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    // MARK: - Screen

    var screen: XCUIElement {
        app.otherElements["productDetail.screen"]
    }

    func waitForScreen(timeout: TimeInterval = 2) {
        XCTAssertTrue(screen.waitForExistence(timeout: timeout))
    }

    // MARK: - Elements

    var titleLabel: XCUIElement {
        app.staticTexts["productDetail.title"]
    }

    var variantPicker: XCUIElement {
        app.buttons["productDetail.variantPicker"]
    }

    var colorPicker: XCUIElement {
        app.otherElements["productDetail.colorPicker"]
    }

    var storagePicker: XCUIElement {
        app.segmentedControls["productDetail.storagePicker"]
    }

    var priceLabel: XCUIElement {
        app.staticTexts["productDetail.priceLabel"]
    }

    var addToCartButton: XCUIElement {
        app.buttons["productDetail.addToCartButton"]
    }

    var viewCartButton: XCUIElement {
        app.buttons["View Cart"]
    }

    private var scrollView: XCUIElement {
        app.scrollViews.firstMatch
    }

    // MARK: - Actions

    func selectVariant(named variantName: String) {
        XCTAssertTrue(variantPicker.waitForExistence(timeout: 2))
        variantPicker.tap()

        let option = app.buttons[variantName]
        XCTAssertTrue(option.waitForExistence(timeout: 2))
        option.tap()
    }
    func selectColor(_ colorName: String) {
        scrollToColorPickerIfNeeded()
        XCTAssertTrue(colorPicker.waitForExistence(timeout: 2))

        let swatch = colorPicker.buttons["productDetail.color.\(colorName)"]
        XCTAssertTrue(swatch.waitForExistence(timeout: 2))

        let isSelected = (swatch.value as? String) == "selected"
        if isSelected {
            return
        }

        if swatch.isHittable {
            swatch.tap()
            return
        }

        // Fallback for SwiftUI buttons that exist but report not hittable
        let coordinate = swatch.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        coordinate.tap()
    }
    func selectStorage(_ storageName: String) {
        scrollToStorageIfNeeded()
        XCTAssertTrue(storagePicker.waitForExistence(timeout: 2))

        let button = storagePicker.buttons[storageName]
        XCTAssertTrue(button.waitForExistence(timeout: 2))

        if button.isSelected {
            return
        }

        if button.isHittable {
            button.tap()
            return
        }

        let coordinate = button.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        coordinate.tap()
    }
    func addToCart() {
        scrollToAddToCartIfNeeded()

        XCTAssertTrue(addToCartButton.waitForExistence(timeout: 2))
        XCTAssertTrue(addToCartButton.isHittable)
        addToCartButton.tap()
    }

    func goToCartFromDialog() {
        XCTAssertTrue(viewCartButton.waitForExistence(timeout: 2))
        viewCartButton.tap()
    }

    // MARK: - Dynamic Reads
    func readAllColorOptions() -> [String] {
        scrollToColorPickerIfNeeded()
        XCTAssertTrue(colorPicker.waitForExistence(timeout: 2))

        let swatches = colorPicker.descendants(matching: .button).allElementsBoundByIndex

        let colors = swatches.compactMap { element -> String? in
            let id = element.identifier
            guard id.hasPrefix("productDetail.color.") else { return nil }
            return id.replacingOccurrences(of: "productDetail.color.", with: "")
        }

        return Array(Set(colors)).sorted()
    }

    func readAllStorageOptions() -> [String] {
        scrollToStorageIfNeeded()
        XCTAssertTrue(storagePicker.waitForExistence(timeout: 2))

        return storagePicker.buttons.allElementsBoundByIndex
            .map(\.label)
            .filter { !$0.isEmpty }
    }

    // MARK: - Scrolling Helpers

    func scrollToColorPickerIfNeeded() {
        if colorPicker.exists && colorPicker.isHittable {
            return
        }

        XCTAssertTrue(scrollView.waitForExistence(timeout: 2))

        for _ in 0..<6 {
            if colorPicker.exists && colorPicker.isHittable {
                return
            }
            scrollView.swipeUp()
        }

        XCTAssertTrue(colorPicker.exists, "Color picker was not found after scrolling")
    }

    func scrollToStorageIfNeeded() {
        if storagePicker.exists && storagePicker.isHittable {
            return
        }

        XCTAssertTrue(scrollView.waitForExistence(timeout: 2))

        for _ in 0..<6 {
            if storagePicker.exists && storagePicker.isHittable {
                return
            }
            scrollView.swipeUp()
        }

        XCTAssertTrue(storagePicker.exists, "Storage picker was not found after scrolling")
    }

    func scrollToAddToCartIfNeeded() {
        if addToCartButton.exists && addToCartButton.isHittable {
            return
        }

        XCTAssertTrue(scrollView.waitForExistence(timeout: 2))

        for _ in 0..<6 {
            if addToCartButton.exists && addToCartButton.isHittable {
                return
            }
            scrollView.swipeUp()
        }

        XCTAssertTrue(addToCartButton.exists, "Add to Cart button was not found after scrolling")
    }
}
