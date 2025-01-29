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
                .frame(maxWidth: 1300, maxHeight: 800)
                .frame(minWidth: 1000, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1300, height: 800)
        .windowResizability(.contentSize)
    }
}
