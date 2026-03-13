import Foundation

enum ProductColor: String, CaseIterable, Identifiable, Hashable {
    case black = "Black"
    case white = "White"
    case blue = "Blue"
    case silver = "Silver"
    case spaceGray = "SpaceGray"
    case spaceBlack = "SpaceBlack"
    case starlight = "Starlight"
    case midnight = "Midnight"
    case orange = "Orange"

    var id: String { rawValue }
}
enum StorageOption: String, CaseIterable, Identifiable {
    case gb128 = "128GB"
    case gb256 = "256GB"
    case gb512 = "512GB"
    case tb1 = "1TB"

    var id: String { rawValue }
}
