//
//  AppContext.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 09.03.2026.
//

import Foundation

public protocol DependencyContextProtocol {
    func configure()
}

struct AppContext: DependencyContextProtocol {
    func configure() {
        registerCoreComponents()
    }
    
    private func registerCoreComponents() {
        DIContainer.shared.register(type: NetworkServiceProtocol.self) {
            return NetworkService()
        }
    }
}
