//
//  AppDelegate.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import FirebaseCore
import UIKit

#if DEBUG
import DebugSwift
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let debugSwift = DebugSwift()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appContext = AppContext()
        appContext.configure()
        FirebaseApp.configure()
        
#if DEBUG
        debugSwift.setup()
        debugSwift.show()
#endif
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
