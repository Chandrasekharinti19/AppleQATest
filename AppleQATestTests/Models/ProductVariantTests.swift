import XCTest
@testable import AppleQATest

final class ProductVariantTests: XCTestCase {

    func testIPhone17Pro256GBPrice() {
        let variant = ProductVariant(
            name: "iPhone 17 Pro",
            basePrice: 1099,
            availableColors: [.black, .white, .spaceGray],
            availableStorage: [.gb256, .gb512, .tb1],
            storagePriceAdjustments: [
                .gb256: 0,
                .gb512: 200,
                .tb1: 400
            ]
        )

        XCTAssertEqual(variant.price(for: .gb256), 1099, accuracy: 0.0001)
    }

    func testIPhone17Pro512GBPrice() {
        let variant = ProductVariant(
            name: "iPhone 17 Pro",
            basePrice: 1099,
            availableColors: [.black, .white, .spaceGray],
            availableStorage: [.gb256, .gb512, .tb1],
            storagePriceAdjustments: [
                .gb256: 0,
                .gb512: 200,
                .tb1: 400
            ]
        )

        XCTAssertEqual(variant.price(for: .gb512), 1299, accuracy: 0.0001)
    }

    func testIPhone17Pro1TBPrice() {
        let variant = ProductVariant(
            name: "iPhone 17 Pro",
            basePrice: 1099,
            availableColors: [.black, .white, .spaceGray],
            availableStorage: [.gb256, .gb512, .tb1],
            storagePriceAdjustments: [
                .gb256: 0,
                .gb512: 200,
                .tb1: 400
            ]
        )

        XCTAssertEqual(variant.price(for: .tb1), 1499, accuracy: 0.0001)
    }

    func testMacBookPro1TBPrice() {
        let variant = ProductVariant(
            name: "MacBook Pro",
            basePrice: 1599,
            availableColors: [.silver, .spaceBlack],
            availableStorage: [.gb512, .tb1],
            storagePriceAdjustments: [
                .gb512: 0,
                .tb1: 400
            ]
        )

        XCTAssertEqual(variant.price(for: .tb1), 1999, accuracy: 0.0001)
    }

    func testVariantWithoutAdjustmentUsesBasePrice() {
        let variant = ProductVariant(
            name: "Apple Pencil (USB-C)",
            basePrice: 79,
            availableColors: [],
            availableStorage: [],
            storagePriceAdjustments: [:]
        )

        XCTAssertEqual(variant.basePrice, 79, accuracy: 0.0001)
    }
}
