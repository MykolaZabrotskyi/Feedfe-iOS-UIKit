//
//  BaseRouter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 09.03.2026.
//

import UIKit

class BaseRouter{
    
    // MARK: - Properties
    
    private weak var viewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

