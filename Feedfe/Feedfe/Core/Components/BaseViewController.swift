//
//  BaseViewController.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 05.03.2026.
//

import UIKit

class BaseViewController<PresenterType>: UIViewController {
    
    // MARK: - Properties
    
    private(set) var presenter: PresenterType!
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Internal Methods
    
    func inject(presenter: PresenterType) {
        self.presenter = presenter
    }
}

private extension BaseViewController {
    
    // MARK: - Setup/Configuration
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
}
