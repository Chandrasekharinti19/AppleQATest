import Foundation

struct Product: Identifiable, Equatable {
    let id: UUID
    let category: ProductCategory
    let displayName: String
    let variants: [ProductVariant]

    init(
        id: UUID = UUID(),
        category: ProductCategory,
        displayName: String,
        variants: [ProductVariant]
    ) {
        self.id = id
        self.category = category
        self.displayName = displayName
        self.variants = variants
    }
}
