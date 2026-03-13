import Foundation

struct EmailValidator {

    static func isValid(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else { return false }
        guard trimmed.contains("@"), trimmed.contains(".") else { return false }

        let pattern = #"^[A-Z0-9a-z._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#

        return trimmed.range(of: pattern, options: .regularExpression) != nil
    }
}
