//
//  AppContext.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 09.03.2026.
//

import Foundation

struct AppContext: DependencyContextProtocol {
    
    // MARK: - Internal Methods
    
    func configure() {
        registerCoreComponents()
    }
}

// MARK: - Private Methods

private extension AppContext {
    private func registerCoreComponents() {
        DIContainer.shared.register(type: NetworkServiceProtocol.self) {
            return NetworkService()
        }
    }
}
