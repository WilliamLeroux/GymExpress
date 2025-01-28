//
//  GymExpressApp.swift
//  GymExpress
//
//  Created by William Leroux, Samuel Oliveira Martel, Nicolas Morin on 2025-01-27.
//

import SwiftUI

@main
struct GymExpressApp: App {
    var body: some Scene {
        WindowGroup {
            RootNavigation()
                .preferredColorScheme(.light)
        }.windowStyle(.hiddenTitleBar)
    }
}
