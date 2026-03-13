import Foundation

enum ProductCategory: String, CaseIterable, Identifiable {

    case iPhone
    case iPad
    case macBook

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .iPhone:
            return "iPhone"
        case .iPad:
            return "iPad"
        case .macBook:
            return "MacBook"
        }
    }
}
