//
//  TestModelContainer.swift
//  NeuGelbTestTests
//
//  Created by Marco Maddalena on 25.03.26.
//

import SwiftData
import Foundation
@testable import NeuGelbTest

struct TestModelContainer {
    static func create() throws -> ModelContainer {
        let container = try ModelContainer(
            for: MovieEntity.self, MoviePageMetadata.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return container
    }
    
    static func createContext() throws -> ModelContext {
        let container = try create()
        return ModelContext(container)
    }
}
