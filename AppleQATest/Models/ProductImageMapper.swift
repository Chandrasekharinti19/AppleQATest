import Foundation

struct ProductImageMapper {

    // MARK: - Product List Image

    static func listImageName(for product: Product) -> String {

        switch product.category {

        case .iPhone:
            return "iphone17_blue_front"

        case .iPad:
            return "ipadair_blue_front"

        case .macBook:
            return "macbookair_midnight_open"
        }
    }

    // MARK: - Detail Image Gallery

    static func detailImageNames(
        product: Product,
        variant: ProductVariant?,
        color: ProductColor?
    ) -> [String] {

        guard let variant else { return [] }

        switch product.category {

        // MARK: iPhone

        case .iPhone:

            let colorName = color?.rawValue.lowercased() ?? "blue"

            if variant.name.lowercased().contains("pro max") {

                return [
                    "iphone17promax_\(colorName)_front",
                    "iphone17promax_\(colorName)_side",
                    "iphone17promax_\(colorName)_back"
                ]

            } else if variant.name.lowercased().contains("pro") {

                return [
                    "iphone17pro_\(colorName)_front",
                    "iphone17pro_\(colorName)_side",
                    "iphone17pro_\(colorName)_back"
                ]

            } else {

                return [
                    "iphone17_\(colorName)_front",
                    "iphone17_\(colorName)_side",
                    "iphone17_\(colorName)_back"
                ]
            }

        // MARK: iPad

        case .iPad:

            let colorName = color?.rawValue.lowercased() ?? "blue"

            if variant.name.lowercased().contains("pro") {

                return [
                    "ipadpro_\(colorName)_front",
                    "ipadpro_\(colorName)_side",
                    "ipadpro_\(colorName)_back"
                ]

            } else {

                return [
                    "ipadair_\(colorName)_front",
                    "ipadair_\(colorName)_side",
                    "ipadair_\(colorName)_back"
                ]
            }

        // MARK: MacBook

        case .macBook:

            let colorName = color?.rawValue.lowercased() ?? "silver"

            if variant.name.lowercased().contains("pro") {

                return [
                    "macbookpro_\(colorName)_open",
                    "macbookpro_\(colorName)_side",
                    "macbookpro_\(colorName)_closed"
                ]

            } else {

                return [
                    "macbookair_\(colorName)_open",
                    "macbookair_\(colorName)_side",
                    "macbookair_\(colorName)_closed"
                ]
            }
        }
    }
}
