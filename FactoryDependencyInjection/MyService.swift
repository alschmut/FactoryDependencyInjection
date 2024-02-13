//
//  MyService.swift
//  FactoryDependencyInjection
//
//  Created by Alexander Schmutz on 13.02.24.
//

import Foundation

// MARK: - MyService Definition

protocol MyServiceProtocol {
    func getSomething() -> String
}

extension FactoryAdapter<MyServiceProtocol> {
    static let myService = FactoryAdapter {
        MyService()
    } fixture: {
        MyServiceFixture()
    }
}

struct MyService: MyServiceProtocol {
    func getSomething() -> String {
        return ""
    }
}

struct MyServiceFixture: MyServiceProtocol {
    func getSomething() -> String {
        return ""
    }
}

// MARK: - MyServie Usage

class MyViewModel {
    private let myService: MyServiceProtocol

    init(
        myService: MyServiceProtocol = resolve(.myService)
    ) {
        self.myService = myService
    }
}
