//
//  Injected.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import Foundation

/// Property wrapper for type-safe dependency injection in Swift 6 strict mode.
@propertyWrapper
struct Injected<T> {
    nonisolated(unsafe) private let instance: T // Bypass MainActor checks for wrapped dependency
    
    /// Resolves dependency at initialization time without MainActor constraints.
    nonisolated init() {
        self.instance = DIContainer.shared.requireResolve(T.self)
    }
    
    var wrappedValue: T {
        instance
    }
}
