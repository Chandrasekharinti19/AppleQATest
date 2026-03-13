import Foundation

struct CartItem: Identifiable, Equatable {
    let id: UUID
    let product: Product
    let selection: ProductSelection
    var quantity: Int

    init(
        id: UUID = UUID(),
        product: Product,
        selection: ProductSelection,
        quantity: Int = 1
    ) {
        self.id = id
        self.product = product
        self.selection = selection
        self.quantity = quantity
    }
}
