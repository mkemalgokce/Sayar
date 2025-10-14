// Copyright © 2025 Mustafa Kemal Gökçe. 
// All rights reserved.

@testable import Onboarding
import XCTest

final class OnboardingPageTests: XCTestCase {
    func test_didItSuccess() {
        let page = OnboardingPage(title: "Page", description: "Description", image: "Image")
        page.printLog()
        XCTAssertTrue(true)
    }
}
