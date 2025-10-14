// Copyright © 2025 Mustafa Kemal Gökçe. 
// All rights reserved.

import Foundation

struct OnboardingPage<Image> {
    let title: String
    let description: String
    let image: Image

    func printLog() {
        print("Title is: \(title)")
    }
}
