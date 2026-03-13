import Foundation

struct ProductSelection: Equatable, Hashable {
    let variantName: String
    let color: ProductColor?
    let storage: StorageOption?
    let finalPrice: Double
}
