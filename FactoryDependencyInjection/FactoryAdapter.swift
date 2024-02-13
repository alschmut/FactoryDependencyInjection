//
//  FactoryAdapter.swift
//  AppAnalytics (iOS)
//
//  Created by Alexander Schmutz on 20.12.22.
//

import Factory

func resolve<Value>(_ factoryAdapter: FactoryAdapter<Value>) -> Value {
    factoryAdapter()
}

struct FactoryAdapter<Value> {
    let factory: Factory<Value>
    let mock: (() -> Value)?
    let fixture: (() -> Value)?

    enum Target {
        case service
        case fixture
        case mock
    }

    init(
        value: @escaping () -> Value,
        mock: (() -> Value)? = nil,
        fixture: (() -> Value)? = nil
    ) {
        factory = Factory(Container.shared) { value() }
        self.mock = mock
        self.fixture = fixture
    }

    init(
        scope: FactoryScope,
        value: @escaping () -> Value,
        mock: (() -> Value)? = nil,
        fixture: (() -> Value)? = nil
    ) {
        factory = Factory(Container.shared) { value() }.scope(Self.scope(from: scope))
        self.mock = mock
        self.fixture = fixture
    }

    func callAsFunction() -> Value {
        switch target {
        case .service: return factory()
        case .fixture: return fixture?() ?? factory()
        case .mock: return mock?() ?? factory()
        }
    }

    private static func scope(from scope: FactoryScope) -> Scope {
        switch scope {
        case .singleton: return .singleton
        case .cashed: return .cached
        case .shared: return .shared
        }
    }

    private var target: Target {
        #if DEV
        return .service
        #elseif RELEASE
        return .service
        #elseif LOCAL
        return .fixture
        #elseif TEST
        return .mock
        #else
        fatalError("Build configuration is missing environment value RELEASE, DEV, LOCAL or TEST")
        #endif
    }
}

enum FactoryScope {
    case singleton
    case cashed
    case shared
}
