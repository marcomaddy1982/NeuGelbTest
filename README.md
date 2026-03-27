# iOS Challenge — Technical Overview

## Overview

The project is structured around the following key technical decisions:

- [Custom networking library built on `async/await`](#1-networking-library)
- [Swift 6 strict concurrency](#2-swift-6-concurrency)
- [Lightweight dependency injection via `@Injected`](#3-dependency-injection-library)
- [Secure configuration management via `.xcconfig`](#4-configuration--secret-management)
- [MVVM with protocol-backed ViewModels and container views](#5-mvvm-architecture)
- [Dedicated service layer](#6-service-layer)
- [Combine-powered search autocomplete](#7-search-autocomplete-with-combine)
- [Unit tests for ViewModels and Request Builder](#8-testing)
- [Bonus — Offline cache with SwiftData and Repository pattern](#bonus--offline-cache-with-swiftdata-separate-branch)

---

## 1. Networking Library

A lightweight networking library handles all API communication. It currently supports `GET`, but is designed to be easily extended to other HTTP methods with minimal changes.

### Why `async/await`

Completion blocks and Combine/Promises were considered and set aside in favour of `async/await` for the following reasons:

- **Readability**: Async code reads like synchronous code.
- **Error handling**: `async throws` integrates naturally with `do/try/catch`.
- **Composability**: Calls can be sequenced or parallelised via `.task` modifiers or `Task` blocks.
- **First-class Swift support**: Aligns with Apple's own modern APIs (e.g. `URLSession.data(for:)`).
- **Cancellation**: Built-in cooperative cancellation via `Task`.

### Error Handling

The library defines a typed error enum (`NetworkError`) covering common failure scenarios: HTTP errors (4xx, 5xx), decoding failures, timeouts, and configuration issues. Callers always receive a meaningful error.

---

## 2. Swift 6 Concurrency

The project runs with **Swift 6 strict concurrency enabled** (`SWIFT_STRICT_CONCURRENCY = complete`), which enforces data-race safety at compile time rather than at runtime.

### Benefits

- **Compile-time safety**: Data races are caught as build errors.
- **Explicit contracts**: `Sendable` conformance makes threading assumptions visible in the type system.
- **Actor isolation**: `actor` types and `@MainActor` guarantee state protection and correct thread usage.
- **Future-proof**: Avoids a costly migration to Swift 6 requirements later.

---

## 3. Dependency Injection Library

A custom DI library built on `@propertyWrapper` exposes an `@Injected` API across the codebase. Dependencies are registered once at app launch and resolved anywhere via the property wrapper.

```swift
// Registration (once, at app launch in setupDependencies)
let networkClient = NetworkClient(config: config)
DIContainer.shared.register(networkClient)

// Resolution (in ViewModelFactory)
@Injected<NetworkClient> var networkClient: NetworkClient
@Injected<MovieServiceProtocol> var movieService
```

### Benefits

- **Single registration point**: All wiring lives in one place; swapping an implementation is a single change.
- **No manual passing**: Eliminates dependency chains through initializer parameters.
- **Protocol-backed**: Makes mock injection straightforward for tests.
- **Singleton-like lifetime**: Instances are created once and reused, without the pitfalls of global state.

---

## 4. Configuration & Secret Management

Sensitive values (API base URL, API token) are managed via `.xcconfig` files (excluded from version control, source of truth) and substituted into `Config.plist` at build time.

### Benefits

- **Security**: Secrets never appear in committed source code.
- **Environment separation**: Separate `.xcconfig` files per scheme (`Debug`, `Staging`, `Release`).
- **No code changes for config**: Updating an endpoint or token requires no Swift changes.
- **CI/CD friendly**: Pipelines can inject values as secrets without touching the repository.

---

## 5. MVVM Architecture

The project uses MVVM with SwiftUI's `ObservableObject` / `@StateObject`. ViewModels are created via a **Factory** pattern. Services are injected via **protocols** (e.g., `MovieServiceProtocol`, `ImageServiceProtocol`), enabling testability and mock injection.

### Factory Pattern

```swift
@MainActor
final class MovieListViewModelFactory {
    @Injected<MovieServiceProtocol> var movieService
    @Injected<ImageServiceProtocol> var imageService
    
    static func makeMovieListViewModel() -> MovieListViewModel {
        let factory = MovieListViewModelFactory()
        return MovieListViewModel(movieService: factory.movieService, imageService: factory.imageService)
    }
}
```

### Container View Pattern

Each screen is split into a **container view** and a set of **state-specific subviews**. The container owns the `@StateObject`, handles navigation via `.task` modifiers, and switches between subviews based on the ViewModel's current state.

### Benefits

- **Separation of concerns**: Views are purely declarative; all logic lives in the ViewModel.
- **`@StateObject` ownership**: The view correctly owns the ViewModel lifecycle.
- **Factory pattern**: ViewModel creation is centralised and decoupled from the view.
- **Decoupled subviews**: Each state maps to a focused, self-contained view.
- **Testability**: Services are injected via protocols, enabling mock injection for isolated ViewModel testing without network calls.

---

## 6. Service Layer

A dedicated Service layer sits between the ViewModels and the networking library. Each service owns one domain area and exposes `async throws` methods.

### Responsibilities

- Calling the networking library with the correct endpoint and parameters.
- Decoding API responses into typed model objects.
- Acting as the single point of change for API contract updates.

### Benefits

- **Single Responsibility**: ViewModels stay free of networking details.
- **Reusability**: Multiple ViewModels can share the same service.
- **Testability**: Services are injected via protocols and can be mocked in isolation.
- **Consistency**: The same `async/await` model flows uniformly from network to ViewModel.

## 7. Search Autocomplete with Combine

Search is powered by Combine, with the query string exposed as a `@Published` property on the ViewModel. Two separate Combine pipelines drive the behaviour:

- **Search pipeline**: Listens to query changes, applies `debounce` (waits for a pause after typing) and `removeDuplicates` (skips if value is unchanged), then triggers the search request.
- **Clear pipeline**: Listens for empty queries (user tapped clear), triggering an immediate reset of results without debounce.

### Benefits

- **Reduced network load**: Search pipeline's `debounce` fires only when the user pauses typing.
- **No redundant calls**: `removeDuplicates` skips requests when the value hasn't changed.
- **Separate concerns**: Search and clear logic flow through dedicated pipelines, centralised in the ViewModel.
- **Clean view**: The view only updates `viewModel.searchQuery` — all reactive logic is handled downstream.

---

## 8. Testing

Unit tests cover two key areas: **ViewModels** and the **Request Builder**.

ViewModels are tested in isolation by injecting mock services conforming to the same protocols used in production. This allows tests to control the data the ViewModel receives and assert on its output state without any networking or side effects involved.

The Request Builder is tested by asserting that given a set of inputs (endpoint, parameters, HTTP method), the resulting `URLRequest` is correctly constructed — right URL, headers, and method. This validates the core of the networking layer independently from any live API.

### Benefits

- **Fast and deterministic**: No network calls — tests run instantly and always produce the same result.
- **High confidence at low cost**: Covers the two most logic-heavy components of the codebase.
- **Mocks are free**: Protocol-backed types require no extra abstraction to be testable.
- **Regression safety**: Breaking changes to request construction or ViewModel logic are caught immediately.

---

## Bonus — Offline Cache with SwiftData *(separate branch)*

A caching layer is introduced via a **Repository** pattern. The repository sits between the ViewModel and the service, and is responsible for deciding whether to return cached data from a local SwiftData store or fetch fresh data from the network.

### Why SwiftData

- **Native Swift API**: Built on Swift macros, integrates seamlessly with SwiftUI and Swift concurrency.
- **Minimal boilerplate**: Models are declared with `@Model`, no manual schema definitions needed.
- **Type safety**: Queries and relationships are fully typed.
- **SwiftUI integration**: The `@Query` macro makes persisted data observable directly in views.

### Why the Repository Pattern

- **Single decision point**: Cache-or-network logic lives in one place, invisible to the ViewModel.
- **Transparent to the ViewModel**: Called exactly like a service — no changes needed above this layer.
- **Easily testable**: Conforms to a protocol, so it can be mocked like any other dependency.
- **Flexible strategy**: Cache invalidation rules can evolve inside the repository without touching the rest of the codebase.

---

*README written as part of the iOS technical challenge submission.*
