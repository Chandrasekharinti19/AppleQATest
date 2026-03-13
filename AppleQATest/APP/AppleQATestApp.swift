import SwiftUI

@main
struct AppleQATestApp: App {

    init() {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-resetData") {
            AppResetManager.reset()
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
