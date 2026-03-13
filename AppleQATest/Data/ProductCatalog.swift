import Foundation

enum ProductCatalog {

    static let products: [Product] = [

        Product(
            id: UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!,
            category: ProductCategory.iPhone,
            displayName: "iPhone",
            variants: [
                ProductVariant(
                    name: "iPhone 17",
                    basePrice: 899,
                    availableColors: [.blue, .black, .white],
                    availableStorage: [.gb128, .gb256, .gb512],
                    storagePriceAdjustments: [
                        .gb128: 0,
                        .gb256: 100,
                        .gb512: 300
                    ]
                ),
                ProductVariant(
                    name: "iPhone 17 Pro",
                    basePrice: 1099,
                    availableColors: [.blue, .orange, .silver],
                    availableStorage: [.gb256, .gb512, .tb1],
                    storagePriceAdjustments: [
                        .gb256: 0,
                        .gb512: 200,
                        .tb1: 400
                    ]
                ),
                ProductVariant(
                    name: "iPhone 17 Pro Max",
                    basePrice: 1299,
                    availableColors: [.blue, .orange, .silver],
                    availableStorage: [.gb256, .gb512, .tb1],
                    storagePriceAdjustments: [
                        .gb256: 0,
                        .gb512: 200,
                        .tb1: 400
                    ]
                )
            ]
        ),

        Product(
            id: UUID(uuidString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")!,
            category: ProductCategory.iPad,
            displayName: "iPad",
            variants: [
                ProductVariant(
                    name: "iPad Air",
                    basePrice: 599,
                    availableColors: [.blue, .spaceGray, .starlight],
                    availableStorage: [.gb128, .gb256],
                    storagePriceAdjustments: [
                        .gb128: 0,
                        .gb256: 150
                    ]
                ),
                ProductVariant(
                    name: "iPad Pro",
                    basePrice: 999,
                    availableColors: [.silver, .spaceBlack],
                    availableStorage: [.gb256, .gb512, .tb1],
                    storagePriceAdjustments: [
                        .gb256: 0,
                        .gb512: 200,
                        .tb1: 400
                    ]
                )
            ]
        ),

        Product(
            id: UUID(uuidString: "CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC")!,
            category: ProductCategory.macBook,
            displayName: "MacBook",
            variants: [
                ProductVariant(
                    name: "MacBook Air",
                    basePrice: 1099,
                    availableColors: [.midnight, .silver, .starlight],
                    availableStorage: [.gb256, .gb512],
                    storagePriceAdjustments: [
                        .gb256: 0,
                        .gb512: 200
                    ]
                ),
                ProductVariant(
                    name: "MacBook Pro",
                    basePrice: 1599,
                    availableColors: [.silver, .spaceBlack],
                    availableStorage: [.gb512, .tb1],
                    storagePriceAdjustments: [
                        .gb512: 0,
                        .tb1: 400
                    ]
                )
            ]
        ),

        Product(
            id: UUID(uuidString: "DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDDDDD")!,
            category: ProductCategory.iPad,
            displayName: "Apple Pencil (USB-C)",
            variants: [
                ProductVariant(
                    name: "Apple Pencil (USB-C)",
                    basePrice: 79,
                    availableColors: [],
                    availableStorage: [],
                    storagePriceAdjustments: [:]
                )
            ]
        )
    ]
}
