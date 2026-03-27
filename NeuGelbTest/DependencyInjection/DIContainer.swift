//
//  DIContainer.swift
//  NeuGelbTest
//
//  Created by Marco Maddalena on 23.03.26.
//

import Foundation

nonisolated final class DIContainer: @unchecked Sendable {
    static let shared = DIContainer()
    
    private var dependencies: [String: Any] = [:]
    
    private init() {}
    
    func register<T>(_ instance: T, as type: T.Type = T.self) {
        let key = String(describing: type)
        dependencies[key] = instance
    }
    
    func resolve<T>(_ type: T.Type = T.self) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }
    
    /// Crashes if dependency not registered - use only for required dependencies
    func requireResolve<T>(_ type: T.Type = T.self) -> T {
        guard let instance = resolve(type) else {
            fatalError("Dependency not registered: \(type). Call setupDependencies() at app startup.")
        }
        return instance
    }
    
    func reset() {
        dependencies.removeAll()
    }
}
