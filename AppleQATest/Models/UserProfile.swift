import Foundation

struct UserProfile: Equatable {
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var shippingAddress: String = ""

    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    var hasRequiredShippingInfo: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !shippingAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
