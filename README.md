# Dependency Injection with Factory

To decouple the dependency injection framework [Factory](https://github.com/hmlongco/Factory) from the internal app usage there are two options:


## Using KeyPaths to access a defined service on one of possibly many containers

### FactoryAdapter
```swift
func resolve<Value>(_ factoryAdapter: KeyPath<FactoryContainer, FactoryAdapter<Value>>) -> Value {
    FactoryContainer.shared[keyPath: factoryAdapter]()
}

struct FactoryContainer {
    static let shared = FactoryContainer()
}

struct FactoryAdapter<Value> {
    let factory: Factory<Value>

    init(
        value: @escaping () -> Value
    ) {
        factory = Factory(Container.shared) { value() }
    }

    init(
        scope: FactoryScope,
        value: @escaping () -> Value
    ) {
        factory = Factory(Container.shared) { value() }.scope(Self.scope(from: scope))
    }

    func callAsFunction() -> Value {
        factory()
    }

    private static func scope(from scope: FactoryScope) -> Scope {
        switch scope {
        case .singleton: return .singleton
        case .cashed: return .cached
        case .shared: return .shared
        }
    }
}

enum FactoryScope {
    case singleton
    case cashed
    case shared
}
```

### Service definition
```swift
protocol MyServiceProtocol {
    func getSomething() -> String
}

extension FactoryContainer {
    var myService: FactoryAdapter<MyServiceProtocol> {
        FactoryAdapter { MyService() }
    }
}

struct MyService: MyServiceProtocol {
    func getSomething() -> String {
        return ""
    }
}
```

### Service Usage
```swift
class MyViewModel {
    private let myService: MyServiceProtocol

    init(
        myService: any MyServiceProtocol = resolve(\.myService)
    ) {
        self.myService = myService
    }
}
```

## Using static variables on a single global container

### FactoryAdapter
```swift
func resolve<Value>(_ factoryAdapter: FactoryAdapter<Value>) -> Value {
    factoryAdapter()
}

struct FactoryAdapter<Value> {
    let factory: Factory<Value>

    init(
        value: @escaping () -> Value
    ) {
        factory = Factory(Container.shared) { value() }
    }

    init(
        scope: FactoryScope,
        value: @escaping () -> Value
    ) {
        factory = Factory(Container.shared) { value() }.scope(Self.scope(from: scope))
    }

    func callAsFunction() -> Value {
        factory()
    }

    private static func scope(from scope: FactoryScope) -> Scope {
        switch scope {
        case .singleton: return .singleton
        case .cashed: return .cached
        case .shared: return .shared
        }
    }
}

enum FactoryScope {
    case singleton
    case cashed
    case shared
}
```

### Service definition
```swift
protocol MyServiceProtocol {
    func getSomething() -> String
}

extension FactoryAdapter<MyServiceProtocol> {
    static let myService = FactoryAdapter {
        MyService()
    }
}

struct MyService: MyServiceProtocol {
    func getSomething() -> String {
        return ""
    }
}
```

### Service Usage
```swift
class MyViewModel {
    private let myService: MyServiceProtocol

    init(
        myService: any MyServiceProtocol = resolve(.myService)
    ) {
        self.myService = myService
    }
}
```
