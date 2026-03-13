import Foundation
import Combine

@MainActor
final class UserProfileManager: ObservableObject {

    @Published var profile = UserProfile()

    func updateProfile(
        firstName: String,
        lastName: String,
        phoneNumber: String,
        email: String,
        shippingAddress: String
    ) {
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedPhone = PhoneValidator.normalized(phoneNumber)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAddress = shippingAddress.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedFirstName.isEmpty else { return }
        guard !trimmedLastName.isEmpty else { return }
        guard PhoneValidator.isValid(normalizedPhone) else { return }
        guard EmailValidator.isValid(trimmedEmail) else { return }
        guard AddressValidator.isValid(trimmedAddress) else { return }

        profile.firstName = trimmedFirstName
        profile.lastName = trimmedLastName
        profile.phoneNumber = normalizedPhone
        profile.email = trimmedEmail
        profile.shippingAddress = trimmedAddress
    }

    var hasValidCheckoutProfile: Bool {
        !profile.firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !profile.lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        PhoneValidator.isValid(profile.phoneNumber) &&
        EmailValidator.isValid(profile.email) &&
        AddressValidator.isValid(profile.shippingAddress)
    }
}
