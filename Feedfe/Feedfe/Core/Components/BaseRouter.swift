//
//  BaseRouter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 09.03.2026.
//

import UIKit

class BaseRouter {
    
    // MARK: - Properties
    
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    // MARK: - Internal Methods
    
    func push(_ destination: UIViewController, animated: Bool = true) {
        viewController?.navigationController?.pushViewController(destination, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        viewController?.navigationController?.popViewController(animated: animated)
    }
}

