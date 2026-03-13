import Foundation

struct CardValidator {

    static func isValidCardholderName(_ name: String) -> Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    static func isValidCardNumber(_ cardNumber: String) -> Bool {
        let digits = cardNumber.filter(\.isNumber)

        guard digits.count >= 12 && digits.count <= 19 else { return false }

        return passesLuhnCheck(digits)
    }

    static func isValidExpiryMonth(_ month: String) -> Bool {
        guard let monthInt = Int(month.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return false
        }

        return (1...12).contains(monthInt)
    }

    static func isValidExpiryYear(_ year: String) -> Bool {
        let trimmed = year.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmed.count == 4, let yearInt = Int(trimmed) else {
            return false
        }

        let currentYear = Calendar.current.component(.year, from: Date())
        return yearInt >= currentYear
    }

    static func isValidExpiry(month: String, year: String) -> Bool {
        guard isValidExpiryMonth(month), isValidExpiryYear(year) else {
            return false
        }

        guard
            let monthInt = Int(month.trimmingCharacters(in: .whitespacesAndNewlines)),
            let yearInt = Int(year.trimmingCharacters(in: .whitespacesAndNewlines))
        else {
            return false
        }

        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)

        if yearInt < currentYear {
            return false
        }

        if yearInt == currentYear && monthInt < currentMonth {
            return false
        }

        return true
    }

    static func isValidCVV(_ cvv: String) -> Bool {
        let digits = cvv.filter(\.isNumber)
        return digits.count == 3 || digits.count == 4
    }

    static func isValid(
        cardholderName: String,
        cardNumber: String,
        expiryMonth: String,
        expiryYear: String,
        cvv: String
    ) -> Bool {
        isValidCardholderName(cardholderName) &&
        isValidCardNumber(cardNumber) &&
        isValidExpiry(month: expiryMonth, year: expiryYear) &&
        isValidCVV(cvv)
    }

    static func maskedCardNumber(_ cardNumber: String) -> String {
        let digits = cardNumber.filter(\.isNumber)
        guard digits.count >= 4 else { return "••••" }
        return "•••• \(digits.suffix(4))"
    }

    private static func passesLuhnCheck(_ digits: String) -> Bool {
        let reversedDigits = digits.reversed().compactMap { Int(String($0)) }

        var sum = 0

        for (index, digit) in reversedDigits.enumerated() {
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }

        return sum % 10 == 0
    }
}
