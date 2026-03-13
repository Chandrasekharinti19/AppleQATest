import XCTest
@testable import AppleQATest

final class CartManagerConfigurationTests: XCTestCase {

    private func makeProduct() -> Product {
        Product(
            id: UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!,
            category: .iPhone,
            displayName: "iPhone",
            variants: [
                ProductVariant(
                    name: "iPhone 17 Pro",
                    basePrice: 1099,
                    availableColors: [.black, .white],
                    availableStorage: [.gb256, .gb512],
                    storagePriceAdjustments: [
                        .gb256: 0,
                        .gb512: 200
                    ]
                )
            ]
        )
    }

    func testSameConfigurationMergesQuantity() async {
        await MainActor.run {
            let cart = CartManager()
            let product = makeProduct()

            let selection = ProductSelection(
                variantName: "iPhone 17 Pro",
                color: .black,
                storage: .gb256,
                finalPrice: 1099
            )

            cart.add(product: product, selection: selection)
            cart.add(product: product, selection: selection)

            XCTAssertEqual(cart.groupedLineItems.count, 1)
            XCTAssertEqual(cart.groupedLineItems.first?.quantity, 2)
        }
    }

    func testDifferentStorageCreatesSeparateCartLines() async {
        await MainActor.run {
            let cart = CartManager()
            let product = makeProduct()

            let first = ProductSelection(
                variantName: "iPhone 17 Pro",
                color: .black,
                storage: .gb256,
                finalPrice: 1099
            )

            let second = ProductSelection(
                variantName: "iPhone 17 Pro",
                color: .black,
                storage: .gb512,
                finalPrice: 1299
            )

            cart.add(product: product, selection: first)
            cart.add(product: product, selection: second)

            XCTAssertEqual(cart.groupedLineItems.count, 2)
        }
    }
}
