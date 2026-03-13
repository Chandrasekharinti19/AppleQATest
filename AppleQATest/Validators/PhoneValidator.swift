import Foundation

struct PhoneValidator {

    static func isValid(_ phoneNumber: String) -> Bool {
        let digitsOnly = phoneNumber.filter(\.isNumber)

        return digitsOnly.count >= 10 && digitsOnly.count <= 15
    }

    static func normalized(_ phoneNumber: String) -> String {
        phoneNumber.filter(\.isNumber)
    }
}
