import Foundation

enum AppEnvironment: String {
    case dev = "DEV"
    case qa = "QA"
    case staging = "STAGING"

    static var current: AppEnvironment {
        let args = ProcessInfo.processInfo.arguments

        guard let index = args.firstIndex(of: "-environment"),
              index + 1 < args.count,
              let env = AppEnvironment(rawValue: args[index + 1]) else {
            return .dev
        }

        return env
    }

    var displayName: String {
        rawValue
    }
}
