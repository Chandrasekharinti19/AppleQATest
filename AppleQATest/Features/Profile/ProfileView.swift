import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var profile: UserProfileManager

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var addressDraft = ""
    @State private var statusMessage: String?

    var body: some View {

        ScrollView {

            VStack(spacing: 18) {

                Color.clear
                    .frame(width: 1, height: 1)
                    .accessibilityIdentifier("profile.screen")

                Text("Profile")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier("profile.title")

                // MARK: Personal Info

                VStack(alignment: .leading, spacing: 12) {

                    Label("Personal Information", systemImage: "person.circle")
                        .font(.headline)

                    Divider()

                    TextField("First Name", text: $firstName)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("profile.firstNameField")

                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("profile.lastNameField")

                    TextField("Phone Number", text: $phoneNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                        .accessibilityIdentifier("profile.phoneField")

                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("profile.emailField")

                }
                .padding(18)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                // MARK: Address

                VStack(alignment: .leading, spacing: 12) {

                    Label("Shipping Address", systemImage: "shippingbox")
                        .font(.headline)

                    Divider()

                    TextField("Shipping Address", text: $addressDraft, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3, reservesSpace: true)
                        .accessibilityIdentifier("profile.addressField")

                }
                .padding(18)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))

                // MARK: Save

                Button("Save Profile") {
                    if isValidProfileInput() {
                        profile.updateProfile(
                            firstName: firstName,
                            lastName: lastName,
                            phoneNumber: phoneNumber,
                            email: email,
                            shippingAddress: addressDraft
                        )
                        statusMessage = "Saved"
                    } else {
                        statusMessage = "Invalid profile details"
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                .accessibilityIdentifier("profile.saveButton")

                if let statusMessage {
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundStyle(statusMessage == "Saved" ? .green : .red)
                        .accessibilityIdentifier("profile.statusLabel")
                }

                Text("Current: \(profile.profile.fullName), \(profile.profile.shippingAddress)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityIdentifier("profile.currentAddressLabel")

            }
            .padding()
        }
        .navigationTitle("Profile")
        .onAppear {
            firstName = profile.profile.firstName
            lastName = profile.profile.lastName
            phoneNumber = profile.profile.phoneNumber
            email = profile.profile.email
            addressDraft = profile.profile.shippingAddress
        }
    }

    private func isValidProfileInput() -> Bool {

        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAddress = addressDraft.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedFirstName.isEmpty else { return false }
        guard !trimmedLastName.isEmpty else { return false }
        guard PhoneValidator.isValid(trimmedPhone) else { return false }
        guard EmailValidator.isValid(trimmedEmail) else { return false }
        guard AddressValidator.isValid(trimmedAddress) else { return false }

        return true
    }
}
