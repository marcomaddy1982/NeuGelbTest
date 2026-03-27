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
            AppRootView()
        }
    }
}
