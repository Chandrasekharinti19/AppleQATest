import SwiftUI

struct PaymentView: View {

    @EnvironmentObject var payment: PaymentManager

    @State private var cardholderName = ""
    @State private var cardNumber = ""
    @State private var expiryMonth = ""
    @State private var expiryYear = ""
    @State private var cvv = ""
    @State private var statusMessage: String?

    var body: some View {

        ScrollView {

            VStack(spacing: 18) {

                Color.clear
                    .frame(width: 1, height: 1)
                    .accessibilityIdentifier("payment.screen")

                Text("Payment")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier("payment.title")

                VStack(alignment: .leading, spacing: 12) {

                    Label("Card Information", systemImage: "creditcard")
                        .font(.headline)

                    Divider()

                    TextField("Cardholder Name", text: $cardholderName)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("payment.cardholderField")

                    TextField("Card Number", text: $cardNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .accessibilityIdentifier("payment.cardNumberField")

                    HStack {

                        TextField("MM", text: $expiryMonth)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier("payment.expiryMonthField")

                        TextField("YYYY", text: $expiryYear)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier("payment.expiryYearField")

                        SecureField("CVV", text: $cvv)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier("payment.cvvField")
                    }

                }
                .padding(18)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                Button("Save Payment") {

                    if CardValidator.isValid(
                        cardholderName: cardholderName,
                        cardNumber: cardNumber,
                        expiryMonth: expiryMonth,
                        expiryYear: expiryYear,
                        cvv: cvv
                    ) {

                        payment.updatePaymentMethod(
                            cardholderName: cardholderName,
                            cardNumber: cardNumber,
                            expiryMonth: expiryMonth,
                            expiryYear: expiryYear,
                            cvv: cvv
                        )

                        statusMessage = "Saved"

                    } else {
                        statusMessage = "Invalid payment details"
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier("payment.saveButton")

                if let statusMessage {
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundStyle(statusMessage == "Saved" ? .green : .red)
                        .accessibilityIdentifier("payment.statusLabel")
                }

                Text("Current: \(payment.paymentMethod.maskedCardNumber)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier("payment.currentCardLabel")

            }
            .padding()
        }
        .navigationTitle("Payment")
        .onAppear {
            cardholderName = payment.paymentMethod.cardholderName
            cardNumber = payment.paymentMethod.cardNumber
            expiryMonth = payment.paymentMethod.expiryMonth
            expiryYear = payment.paymentMethod.expiryYear
            cvv = payment.paymentMethod.cvv
        }
    }
}
