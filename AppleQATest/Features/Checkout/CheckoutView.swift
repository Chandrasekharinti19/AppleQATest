import SwiftUI

struct CheckoutView: View {

    @ObservedObject var cart: CartManager
    @EnvironmentObject var profile: UserProfileManager
    @EnvironmentObject var payment: PaymentManager

    @State private var promoDraft: String = ""
    @State private var promoStatus: String?
    @State private var didPlaceOrder = false
    @State private var placedSummary: OrderSummary?

    private struct OrderSummary: Equatable {
        let subtotal: Double
        let discount: Double
        let shippingBase: Double
        let shippingDiscount: Double
        let tax: Double
        let total: Double
    }

    private var canPlaceOrder: Bool {
        cart.totalItemCount > 0 &&
        profile.hasValidCheckoutProfile &&
        payment.hasValidPaymentMethod &&
        !didPlaceOrder
    }

    var body: some View {
        let summary = placedSummary ?? OrderSummary(
            subtotal: cart.subtotal,
            discount: cart.discountAmount,
            shippingBase: cart.shippingBaseAmount,
            shippingDiscount: cart.shippingDiscountAmount,
            tax: cart.taxAmount,
            total: cart.grandTotal
        )

        return ScrollView {
            VStack(spacing: 18) {

                Color.clear
                    .frame(width: 1, height: 1)
                    .accessibilityIdentifier("checkout.screen")

                Text("Checkout")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier("checkout.title")

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Shipping", systemImage: "shippingbox")
                            .font(.headline)

                        Spacer()

                        NavigationLink {
                            ProfileView()
                        } label: {
                            Text("Edit")
                                .fontWeight(.medium)
                        }
                        .accessibilityIdentifier("checkout.editProfileButton")
                    }

                    Divider()

                    if profile.hasValidCheckoutProfile {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(profile.profile.fullName)
                                .fontWeight(.medium)

                            Text(profile.profile.phoneNumber)
                                .foregroundStyle(.secondary)

                            Text(profile.profile.email)
                                .foregroundStyle(.secondary)

                            Text(profile.profile.shippingAddress)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("Shipping details missing")
                            .foregroundStyle(.red)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("checkout.shippingSummary")

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Payment", systemImage: "creditcard")
                            .font(.headline)

                        Spacer()

                        NavigationLink {
                            PaymentView()
                        } label: {
                            Text("Edit")
                                .fontWeight(.medium)
                        }
                        .accessibilityIdentifier("checkout.editPaymentButton")
                    }

                    Divider()

                    if payment.hasValidPaymentMethod {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(payment.paymentMethod.cardholderName)
                                .fontWeight(.medium)

                            Text(payment.paymentMethod.maskedCardNumber)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("Payment details missing")
                            .foregroundStyle(.red)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("checkout.paymentSummary")

                VStack(alignment: .leading, spacing: 12) {
                    Label("Promo Code", systemImage: "tag")
                        .font(.headline)

                    HStack(spacing: 12) {
                        TextField("Promo code", text: $promoDraft)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                            .accessibilityIdentifier("checkout.promoField")

                        Button("Apply") {
                            let ok = cart.applyPromo(promoDraft)
                            promoStatus = ok ? "Applied" : "Invalid code"
                        }
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("checkout.applyPromoButton")
                    }

                    if let promoStatus {
                        Text(promoStatus)
                            .font(.footnote)
                            .foregroundStyle(promoStatus == "Applied" ? .green : .red)
                            .accessibilityIdentifier("checkout.promoStatusLabel")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .disabled(didPlaceOrder)

                VStack(alignment: .leading, spacing: 12) {
                    Label("Order Summary", systemImage: "list.bullet.clipboard")
                        .font(.headline)

                    Divider()

                    VStack(spacing: 10) {
                        breakdownRow("Subtotal", summary.subtotal, id: "checkout.subtotalLabel")
                        breakdownRow("Discount", -summary.discount, id: "checkout.discountLabel")
                        breakdownRow("Shipping", summary.shippingBase, id: "checkout.shippingLabel")

                        if summary.shippingDiscount > 0 {
                            breakdownRow("Free Shipping", -summary.shippingDiscount, id: "checkout.shippingDiscountLabel")
                        }

                        breakdownRow("Estimated Tax", summary.tax, id: "checkout.taxLabel")

                        Divider()

                        breakdownRow("Total", summary.total, id: "checkout.totalLabel", isBold: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                if !profile.hasValidCheckoutProfile {
                    Text("Please complete your shipping details before placing the order.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("checkout.profileWarningLabel")
                }

                if !payment.hasValidPaymentMethod {
                    Text("Please add payment details before placing the order.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("checkout.paymentWarningLabel")
                }

                Button("Place Order") {
                    placedSummary = OrderSummary(
                        subtotal: cart.subtotal,
                        discount: cart.discountAmount,
                        shippingBase: cart.shippingBaseAmount,
                        shippingDiscount: cart.shippingDiscountAmount,
                        tax: cart.taxAmount,
                        total: cart.grandTotal
                    )

                    didPlaceOrder = true
                    cart.clear()
                }
                .disabled(!canPlaceOrder)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier("checkout.placeOrderButton")

                if didPlaceOrder {
                    Text("Order placed successfully ✅")
                        .font(.footnote)
                        .foregroundStyle(.green)
                        .accessibilityIdentifier("checkout.successLabel")
                }
            }
            .padding()
        }
        .navigationTitle("Checkout")
        .onAppear {
            promoDraft = cart.promoCode
            promoStatus = nil
        }
    }

    @ViewBuilder
    private func breakdownRow(_ title: String, _ amount: Double, id: String, isBold: Bool = false) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("$\(amount, specifier: "%.2f")")
                .fontWeight(isBold ? .semibold : .regular)
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(id)
    }
}
