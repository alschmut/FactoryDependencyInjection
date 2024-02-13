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
