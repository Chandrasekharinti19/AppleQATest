import SwiftUI

struct ProductDetailView: View {

    let product: Product
    @ObservedObject var cart: CartManager

    @State private var selectedVariant: ProductVariant?
    @State private var selectedColor: ProductColor?
    @State private var selectedStorage: StorageOption?

    @State private var showAddToCartDialog = false
    @State private var navigateToCart = false
    @State private var selectedImageIndex = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                Color.clear
                    .frame(width: 1, height: 1)
                    .accessibilityIdentifier("productDetail.screen")

                imageGallerySection

                headerSection

                if product.variants.count > 1 {
                    detailCard(title: "Model") {
                        Picker("Model", selection: $selectedVariant) {
                            ForEach(product.variants) { variant in
                                Text(variant.name)
                                    .tag(Optional(variant))
                            }
                        }
                        .pickerStyle(.menu)
                        .accessibilityIdentifier("productDetail.variantPicker")
                        .onChange(of: selectedVariant) { _, newVariant in
                            guard let variant = newVariant else { return }

                            if !variant.availableColors.contains(selectedColor ?? fallbackColor) {
                                selectedColor = variant.availableColors.first
                            }

                            if !variant.availableStorage.contains(selectedStorage ?? fallbackStorage) {
                                selectedStorage = variant.availableStorage.first
                            }

                            selectedImageIndex = 0
                        }
                    }
                }

                if let variant = selectedVariant, !variant.availableColors.isEmpty {
                    detailCard(title: "Finish") {
                        colorSwatches(for: variant)
                    }
                    .accessibilityElement(children: .contain)
                    .accessibilityIdentifier("productDetail.colorPicker")
                }

                if let variant = selectedVariant, !variant.availableStorage.isEmpty {
                    detailCard(title: "Storage") {
                        Picker("Storage", selection: $selectedStorage) {
                            ForEach(variant.availableStorage) { storage in
                                Text(storage.rawValue)
                                    .tag(Optional(storage))
                            }
                        }
                        .pickerStyle(.segmented)
                        .accessibilityIdentifier("productDetail.storagePicker")
                    }
                }

                priceSection

                addToCartSection
            }
            .padding(.vertical)
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            configureDefaults()
        }
        .confirmationDialog(
            "Added to Cart",
            isPresented: $showAddToCartDialog,
            titleVisibility: .visible
        ) {
            Button("View Cart") {
                navigateToCart = true
            }

            Button("Continue Shopping", role: .cancel) { }
        } message: {
            Text("Your item was added to the cart.")
        }
        .navigationDestination(isPresented: $navigateToCart) {
            CartView(cart: cart)
        }
    }

    // MARK: - Sections

    private var imageGallerySection: some View {
        VStack(spacing: 16) {
            TabView(selection: $selectedImageIndex) {
                ForEach(Array(currentImageNames.enumerated()), id: \.offset) { index, imageName in
                    ZoomableProductImage(imageName: imageName)
                        .tag(index)
                        .accessibilityIdentifier("productDetail.image.\(index)")
                }
            }
            .frame(height: 320)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .accessibilityIdentifier("productDetail.imageGallery")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(currentImageNames.enumerated()), id: \.offset) { index, imageName in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedImageIndex = index
                            }
                        } label: {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 68, height: 68)
                                .padding(6)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selectedImageIndex == index ? Color.blue : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("productDetail.thumbnail.\(index)")
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.displayName)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .accessibilityIdentifier("productDetail.title")

            Text(subtitleText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private var priceSection: some View {
        VStack(spacing: 16) {
            Text("Price")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("$\(currentPrice(), specifier: "%.2f")")
                .font(.system(size: 34, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.25), value: currentPrice())
                .accessibilityIdentifier("productDetail.priceLabel")
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal)
    }

    private var addToCartSection: some View {
        VStack(spacing: 12) {
            Button {
                guard let variant = selectedVariant else { return }

                let selection = ProductSelection(
                    variantName: variant.name,
                    color: selectedColor,
                    storage: selectedStorage,
                    finalPrice: currentPrice()
                )

                cart.add(product: product, selection: selection)
                showAddToCartDialog = true
            } label: {
                Text("Add to Cart")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .accessibilityIdentifier("productDetail.addToCartButton")
        }
        .padding(.horizontal)
    }

    // MARK: - Reusable UI

    @ViewBuilder
    private func detailCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            content()
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal)
    }

    @ViewBuilder
    private func colorSwatches(for variant: ProductVariant) -> some View {
        HStack(spacing: 14) {
            ForEach(variant.availableColors) { color in
                Button {
                    selectedColor = color
                    selectedImageIndex = 0
                } label: {
                    VStack(spacing: 6) {
                        Circle()
                            .fill(color.swiftUIColor)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle()
                                    .stroke(
                                        selectedColor == color ? Color.blue : Color.gray.opacity(0.25),
                                        lineWidth: selectedColor == color ? 3 : 1
                                    )
                            )

                        Text(color.rawValue)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .frame(width: 64)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(color.rawValue)
                .accessibilityValue(selectedColor == color ? "selected" : "not selected")
                .accessibilityIdentifier("productDetail.color.\(color.rawValue)")
            }
        }
    }
    // MARK: - Helpers

    private var currentImageNames: [String] {
        let images = ProductImageMapper.detailImageNames(
            product: product,
            variant: selectedVariant,
            color: selectedColor
        )

        return images.isEmpty ? [ProductImageMapper.listImageName(for: product)] : images
    }

    private var subtitleText: String {
        if let variant = selectedVariant {
            return "Explore \(variant.name) in the finish and storage that fit you best."
        }
        return "Explore available finishes and storage options."
    }

    private var fallbackColor: ProductColor {
        .black
    }

    private var fallbackStorage: StorageOption {
        .gb128
    }

    private func configureDefaults() {
        if selectedVariant == nil {
            selectedVariant = product.variants.first
        }

        if let variant = selectedVariant {
            if selectedColor == nil {
                selectedColor = variant.availableColors.first
            }

            if selectedStorage == nil {
                selectedStorage = variant.availableStorage.first
            }
        }

        selectedImageIndex = 0
    }

    private func currentPrice() -> Double {
        guard let variant = selectedVariant else { return 0 }

        if let storage = selectedStorage {
            return variant.price(for: storage)
        }

        return variant.basePrice
    }
}

// MARK: - Zoomable Image

private struct ZoomableProductImage: View {
    let imageName: String

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(height: 300)
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = max(1.0, min(lastScale * value, 3.0))
                    }
                    .onEnded { _ in
                        lastScale = scale
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                    if scale > 1.0 {
                        scale = 1.0
                        lastScale = 1.0
                    } else {
                        scale = 2.0
                        lastScale = 2.0
                    }
                }
            }
            .padding(.horizontal)
    }
}

// MARK: - Product Color to SwiftUI Color

private extension ProductColor {
    var swiftUIColor: Color {
        switch self {
        case .black:
            return .black
        case .white:
            return .white
        case .blue:
            return .blue
        case .silver:
            return Color(.systemGray3)
        case .spaceGray:
            return Color(.systemGray)
        case .spaceBlack:
            return Color(.darkGray)
        case .starlight:
            return Color(red: 0.98, green: 0.95, blue: 0.82)
        case .midnight:
            return Color(red: 0.11, green: 0.14, blue: 0.24)
        case .orange:
            return .orange
        }
    }
}
