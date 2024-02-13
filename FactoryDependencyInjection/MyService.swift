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

// MARK: - MyServie Usage

class MyViewModel {
    private let myService: MyServiceProtocol

    init(
        myService: any MyServiceProtocol = resolve(\.myService)
    ) {
        self.myService = myService
    }
}
