import SwiftUI

struct ProductListView: View {

    @EnvironmentObject var cart: CartManager

    @State private var bumpBadge = false
    @State private var selectedCategory: ProductCategory? = nil
    @State private var searchText = ""

    private let products = ProductCatalog.products

    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(width: 1, height: 1)
                .accessibilityIdentifier("products.screen")

            ScrollView {
                VStack(spacing: 20) {

                    featuredBanner

                    categoryTabs

                    LazyVStack(spacing: 20) {
                        ForEach(filteredProducts) { product in
                            NavigationLink {
                                ProductDetailView(product: product, cart: cart)
                            } label: {
                                productCard(for: product)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("products.row.\(product.id.uuidString)")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                .padding(.top)
            }

            NavigationLink {
                CartView(cart: cart)
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 28))

                    if cart.totalItemCount > 0 {
                        Text("\(cart.totalItemCount)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                            .scaleEffect(bumpBadge ? 1.25 : 1.0)
                            .animation(.spring(response: 0.25, dampingFraction: 0.45), value: bumpBadge)
                            .accessibilityIdentifier("cartBadge")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    bumpBadge = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                        bumpBadge = false
                    }
                }
            )
            .accessibilityIdentifier("goToCartButton")
        }
        .navigationTitle("Store")
        .toolbar {
            NavigationLink("Profile") {
                ProfileView()
            }
            .accessibilityIdentifier("products.profileButton")
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search Apple Store"
        )
    }

    // MARK: - Featured Banner

    private var featuredBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [.black, .gray],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 10) {
                Text("New")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))

                Text("iPhone 17 Pro")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Powerful. Refined. Built for everyday brilliance.")
                    .foregroundColor(.white.opacity(0.85))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .frame(height: 160)
        .padding(.horizontal)
        .accessibilityIdentifier("products.featuredBanner")
    }

    // MARK: - Category Tabs

    private var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                categoryButton(title: "All", category: nil)

                ForEach(ProductCategory.allCases) { category in
                    categoryButton(title: category.displayName, category: category)
                }
            }
            .padding(.horizontal)
        }
        .accessibilityIdentifier("products.categoryTabs")
    }

    @ViewBuilder
    private func categoryButton(title: String, category: ProductCategory?) -> some View {
        Button {
            selectedCategory = category
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    selectedCategory == category
                    ? Color.blue
                    : Color(.secondarySystemBackground)
                )
                .foregroundColor(
                    selectedCategory == category
                    ? .white
                    : .primary
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Product Card

    @ViewBuilder
    private func productCard(for product: Product) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(ProductImageMapper.listImageName(for: product))
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .padding(.top, 8)
                .accessibilityIdentifier("products.image.\(product.id.uuidString)")

            VStack(alignment: .leading, spacing: 6) {
                Text(product.displayName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(product.category.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let startingPrice = lowestPrice(for: product) {
                    Text("From $\(startingPrice, specifier: "%.2f")")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                }
            }

            HStack {
                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
    }

    // MARK: - Filtering

    private var filteredProducts: [Product] {
        var result = products

        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.displayName.localizedCaseInsensitiveContains(searchText) ||
                $0.category.displayName.localizedCaseInsensitiveContains(searchText) ||
                $0.variants.contains(where: { $0.name.localizedCaseInsensitiveContains(searchText) })
            }
        }

        return result
    }

    private func lowestPrice(for product: Product) -> Double? {
        let prices = product.variants.flatMap { variant in
            if variant.availableStorage.isEmpty {
                return [variant.basePrice]
            } else {
                return variant.availableStorage.map { variant.price(for: $0) }
            }
        }

        return prices.min()
    }
}
