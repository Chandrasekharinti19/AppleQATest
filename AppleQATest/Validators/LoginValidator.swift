import Foundation

struct LoginValidator {

    static func validate(email: String, password: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        return isValidEmail(trimmedEmail) && trimmedPassword.count >= 6
    }

    static func isValidEmail(_ email: String) -> Bool {
        
        email.contains("@") && email.contains(".") && !email.contains(" ")
    }
}
