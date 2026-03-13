import Foundation
import Combine

@MainActor
final class PaymentManager: ObservableObject {

    @Published var paymentMethod = PaymentMethod()

    func updatePaymentMethod(
        cardholderName: String,
        cardNumber: String,
        expiryMonth: String,
        expiryYear: String,
        cvv: String
    ) {
        guard CardValidator.isValid(
            cardholderName: cardholderName,
            cardNumber: cardNumber,
            expiryMonth: expiryMonth,
            expiryYear: expiryYear,
            cvv: cvv
        ) else {
            return
        }

        paymentMethod.cardholderName = cardholderName.trimmingCharacters(in: .whitespacesAndNewlines)
        paymentMethod.cardNumber = cardNumber.filter(\.isNumber)
        paymentMethod.expiryMonth = expiryMonth.trimmingCharacters(in: .whitespacesAndNewlines)
        paymentMethod.expiryYear = expiryYear.trimmingCharacters(in: .whitespacesAndNewlines)
        paymentMethod.cvv = cvv.filter(\.isNumber)
    }

    var hasValidPaymentMethod: Bool {
        CardValidator.isValid(
            cardholderName: paymentMethod.cardholderName,
            cardNumber: paymentMethod.cardNumber,
            expiryMonth: paymentMethod.expiryMonth,
            expiryYear: paymentMethod.expiryYear,
            cvv: paymentMethod.cvv
        )
    }
}
