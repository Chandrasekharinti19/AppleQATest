import Foundation

struct PaymentMethod: Equatable {
    var cardholderName: String = ""
    var cardNumber: String = ""
    var expiryMonth: String = ""
    var expiryYear: String = ""
    var cvv: String = ""

    var maskedCardNumber: String {
        let trimmed = cardNumber.filter(\.isNumber)
        guard trimmed.count >= 4 else { return "••••" }
        return "•••• \(trimmed.suffix(4))"
    }

    var isComplete: Bool {
        !cardholderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !cardNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !expiryMonth.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !expiryYear.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !cvv.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
