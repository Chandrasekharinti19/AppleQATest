import SwiftUI

struct RootView: View {

    @StateObject private var cart = CartManager()
    @StateObject private var profile = UserProfileManager()
    @StateObject private var payment = PaymentManager()

    var body: some View {
        NavigationStack {
            LoginView()
        }
        .environmentObject(cart)
        .environmentObject(profile)
        .environmentObject(payment)
        .onAppear {
            
            let environment = AppEnvironment.current
                        print("Running in environment:", environment.displayName)

                        let args = ProcessInfo.processInfo.arguments

                        if args.contains("-resetData") {
                            resetAppState()
                        }
                    }
                }

    private func resetAppState() {
        cart.clear()
        profile.profile = UserProfile()
        payment.paymentMethod = PaymentMethod()
        print("UI test reset completed")
    }

    private func currentEnvironment(from args: [String]) -> String? {
        guard let index = args.firstIndex(of: "-environment"),
              index + 1 < args.count else {
            return nil
        }
        return args[index + 1]
    }
}
