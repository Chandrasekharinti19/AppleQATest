import Foundation
import Combine

@MainActor
final class CartManager: ObservableObject {

    @Published private(set) var items: [CartItem] = []

    @Published private(set) var promoCode: String = ""
    @Published private(set) var discountPercent: Double = 0.0

    let taxRate: Double = 0.0825
    let baseShipping: Double = 9.99
    let freeShippingThreshold: Double = 999.0

    // MARK: - Cart Actions

    func add(product: Product, selection: ProductSelection) {
        if let index = items.firstIndex(where: {
            $0.product.id == product.id &&
            $0.selection == selection
        }) {
            items[index].quantity += 1
        } else {
            items.append(
                CartItem(
                    product: product,
                    selection: selection,
                    quantity: 1
                )
            )
        }
    }

    func increaseQuantity(for itemID: CartItem.ID) {
        guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }
        items[index].quantity += 1
    }

    func decreaseQuantity(for itemID: CartItem.ID) {
        guard let index = items.firstIndex(where: { $0.id == itemID }) else { return }

        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }

    func removeItem(itemID: CartItem.ID) {
        items.removeAll { $0.id == itemID }
    }

    func clear() {
        items.removeAll()
        promoCode = ""
        discountPercent = 0.0
    }

    // MARK: - Counts

    var totalItemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var uniqueProductCount: Int {
        items.count
    }

    // MARK: - Pricing

    var subtotal: Double {
        roundTo2(
            items.reduce(0) { partialResult, item in
                partialResult + (item.selection.finalPrice * Double(item.quantity))
            }
        )
    }

    var discountAmount: Double {
        roundTo2(subtotal * discountPercent)
    }

    var subtotalAfterDiscount: Double {
        roundTo2(subtotal - discountAmount)
    }

    // Always show shipping base if cart has items
    var shippingBaseAmount: Double {
        guard !items.isEmpty else { return 0.0 }
        return baseShipping
    }

    // Free shipping discount if eligible
    var shippingDiscountAmount: Double {
        guard !items.isEmpty else { return 0.0 }
        return subtotalAfterDiscount >= freeShippingThreshold ? baseShipping : 0.0
    }

    // Net shipping user pays
    var shippingAmount: Double {
        roundTo2(shippingBaseAmount - shippingDiscountAmount)
    }

    var taxAmount: Double {
        roundTo2(subtotalAfterDiscount * taxRate)
    }

    var grandTotal: Double {
        roundTo2(subtotalAfterDiscount + shippingAmount + taxAmount)
    }

    // MARK: - Promo

    func applyPromo(_ code: String) -> Bool {
        let normalized = code
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        promoCode = normalized

        switch normalized {
        case "APPLE10":
            discountPercent = 0.10
            return true
        case "":
            discountPercent = 0.0
            return true
        default:
            discountPercent = 0.0
            return false
        }
    }

    // MARK: - Helpers for UI

    var groupedLineItems: [CartItem] {
        items.sorted {
            $0.product.displayName.localizedCaseInsensitiveCompare($1.product.displayName) == .orderedAscending
        }
    }

    private func roundTo2(_ value: Double) -> Double {
        (value * 100).rounded() / 100
    }
}
