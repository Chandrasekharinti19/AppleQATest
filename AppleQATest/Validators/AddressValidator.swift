import Foundation

struct AddressValidator {

    static func isValid(_ address: String) -> Bool {
        let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
}
