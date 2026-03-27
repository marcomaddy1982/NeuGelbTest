//
//  NeuGelbTestApp.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import SwiftUI

@main
struct NeuGelbTestApp: App {
    init() {
        // Initialize dependency injection container with all required services
        setupDependencies()
    }

    var body: some Scene {
         WindowGroup {
             if !isRunningTests() {
                 AppRootView()
             } else {
                 EmptyView()
             }
         }
    }
}

private func isRunningTests() -> Bool {
    NSClassFromString("XCTestCase") != nil
}
