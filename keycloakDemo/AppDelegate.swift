//
//  AppDelegate.swift
//  keycloakDemo
//
//  Created by Aleksandar Geyman on 23.12.20.
//

import UIKit
import AppAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var currentAuthorizationFlow: OIDExternalUserAgentSession? {
        didSet {
            print("did setup auth flow")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authFlow = currentAuthorizationFlow {
            authFlow.resumeExternalUserAgentFlow(with: url)
        }
        return true
    }
}
