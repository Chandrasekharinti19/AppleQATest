import XCTest

class BaseUITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false
        app = XCUIApplication()

        app.launchArguments.append("-uiTesting")
        app.launchArguments.append("-resetData")

        if let environment = ProcessInfo.processInfo.environment["APP_ENV"] {
            app.launchArguments.append("-environment")
            app.launchArguments.append(environment)
            print("Running UI tests in environment: \(environment)")
        }

        app.launch()
    }

    override func record(_ issue: XCTIssue) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Failure - \(name)"
        attachment.lifetime = .keepAlways
        add(attachment)

        super.record(issue)
    }

//    func dismissIfPresent(buttonTitle: String, timeout: TimeInterval = 2) {
//        let button = app.buttons[buttonTitle]
//        if button.waitForExistence(timeout: timeout) {
//            button.tap()
//        }
//    }

//    func dismissCommonInterruptions() {
//        dismissIfPresent(buttonTitle: "Not Now", timeout: 1)
//        dismissIfPresent(buttonTitle: "Cancel", timeout: 1)
//        dismissIfPresent(buttonTitle: "OK", timeout: 1)
//    }
}
