//
//  BaseAPIService.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 10.03.2026.
//

class BaseAPIService {
    
    // MARK: - Properties
    
    let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}
