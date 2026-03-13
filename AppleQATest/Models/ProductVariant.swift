import Foundation

struct ProductVariant: Identifiable, Equatable, Hashable {
    let id: UUID
    let name: String
    let basePrice: Double
    let availableColors: [ProductColor]
    let availableStorage: [StorageOption]
    let storagePriceAdjustments: [StorageOption: Double]

    init(
        id: UUID = UUID(),
        name: String,
        basePrice: Double,
        availableColors: [ProductColor],
        availableStorage: [StorageOption],
        storagePriceAdjustments: [StorageOption: Double]
    ) {
        self.id = id
        self.name = name
        self.basePrice = basePrice
        self.availableColors = availableColors
        self.availableStorage = availableStorage
        self.storagePriceAdjustments = storagePriceAdjustments
    }

    func price(for storage: StorageOption) -> Double {
        basePrice + (storagePriceAdjustments[storage] ?? 0)
    }
}
