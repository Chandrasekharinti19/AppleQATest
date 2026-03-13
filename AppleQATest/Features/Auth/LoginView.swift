import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {

            Color.clear
                .frame(width: 1, height: 1)
                .accessibilityIdentifier("login.screen")

            Image(systemName: "applelogo")
                .font(.system(size: 60))
                .accessibilityIdentifier("login.logo")

            Text("Apple Store")
                .font(.title)
                .accessibilityIdentifier("login.title")

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .accessibilityIdentifier("login.emailTextField")

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .accessibilityIdentifier("login.passwordTextField")

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
                    .accessibilityIdentifier("login.errorLabel")
            }

            Button {
                let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

                if LoginValidator.validate(email: trimmedEmail, password: password) {
                    email = trimmedEmail
                    errorMessage = nil
                    isLoggedIn = true
                } else {
                    errorMessage = "Invalid email or password"
                }
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("login.loginButton")

            Spacer()
        }
        .padding()
        .frame(maxWidth: 400)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationDestination(isPresented: $isLoggedIn) {
            ProductListView()
        }
    }
}
