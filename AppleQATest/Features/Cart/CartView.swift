import SwiftUI

struct CartView: View {

    @ObservedObject var cart: CartManager

    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(width: 1, height: 1)
                .accessibilityIdentifier("cart.screen")

            if cart.totalItemCount == 0 {

                VStack(spacing: 16) {
                    Spacer()

                    Image(systemName: "cart")
                        .font(.system(size: 64))
                        .foregroundColor(.gray)

                    Text("Your cart is empty")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .accessibilityIdentifier("emptyCartLabel")

                    Text("Add items from the product list to continue.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Spacer()
                }
                .padding()

            } else {

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(cart.groupedLineItems) { item in
                            VStack(alignment: .leading, spacing: 14) {
                                Color.clear
                                    .frame(width: 1, height: 1)
                                    .accessibilityIdentifier("cart.row.\(item.id.uuidString)")

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.selection.variantName)
                                        .font(.headline)

                                    Text(item.product.displayName)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    if let color = item.selection.color {
                                        Text("Finish: \(color.rawValue)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    if let storage = item.selection.storage {
                                        Text("Storage: \(storage.rawValue)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                HStack {
                                    Text("$\(item.selection.finalPrice, specifier: "%.2f")")
                                        .font(.headline)

                                    Spacer()

                                    HStack(spacing: 16) {
                                        Button {
                                            cart.decreaseQuantity(for: item.id)
                                        } label: {
                                            Image(systemName: "minus.circle")
                                                .font(.title3)
                                        }
                                        .buttonStyle(.borderless)
                                        .accessibilityElement(children: .ignore)
                                        .accessibilityIdentifier("cart.decrease.\(item.id.uuidString)")

                                        Text("\(item.quantity)")
                                            .font(.headline)
                                            .frame(minWidth: 28)
                                            .accessibilityElement(children: .ignore)
                                            .accessibilityLabel("\(item.quantity)")
                                            .accessibilityIdentifier("cart.qty.\(item.id.uuidString)")

                                        Button {
                                            cart.increaseQuantity(for: item.id)
                                        } label: {
                                            Image(systemName: "plus.circle")
                                                .font(.title3)
                                        }
                                        .buttonStyle(.borderless)
                                        .accessibilityElement(children: .ignore)
                                        .accessibilityIdentifier("cart.increase.\(item.id.uuidString)")
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color(.tertiarySystemBackground))
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(18)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
                            .padding(.horizontal)
                        }

                        VStack(spacing: 14) {
                            HStack {
                                Text("Subtotal")
                                    .font(.headline)

                                Spacer()

                                Text("$\(cart.subtotal, specifier: "%.2f")")
                                    .font(.headline)
                            }
                            .accessibilityIdentifier("cartSubtotalLabel")

                            NavigationLink {
                                CheckoutView(cart: cart)
                            } label: {
                                Text("Checkout")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .accessibilityIdentifier("cart.checkoutButton")
                        }
                        .padding(20)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
                        .padding()
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("Cart")
    }
}
