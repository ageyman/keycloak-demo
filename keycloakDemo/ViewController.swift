//
//  ViewController.swift
//  keycloakDemo
//
//  Created by Aleksandar Geyman on 23.12.20.
//

import UIKit
import AppAuth

struct AuthConstants {
    static let authorizationEndpoint = "https://localhost:8443/auth/realms/index-labs"
    static let tokenEndpoint = "https://localhost:8443/auth/realms/index-labs/protocol/openid-connect/token"
    static let redirectURI = "indexlabs://redirect"
}

class ViewController: UIViewController {
    private var authState: OIDAuthState?
    private var authConfiguration: OIDServiceConfiguration?

    override func viewDidLoad() {
        super.viewDidLoad()
        discoverConfiguration()
    }
    
    @IBAction private func didTapOnAuthButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: makeAuthRequest(), presenting: self, callback: { [unowned self] authState, error in
            if let authState = authState {
                self.authState = authState
            } else {
                print(#function, error?.localizedDescription)
                self.authState = nil
            }
        })
    }
    
    private func makeAuthRequest() -> OIDAuthorizationRequest {
        return OIDAuthorizationRequest(configuration: authConfiguration!,
                                       clientId: "mobile",
                                       scopes: ["openid", "email", "roles"],
                                       redirectURL: URL(string: AuthConstants.redirectURI)!,
                                       responseType: "code",
                                       additionalParameters: nil)
    }

    private func discoverConfiguration() {
        guard let authURL = URL(string: AuthConstants.authorizationEndpoint) else { return }

        OIDAuthorizationService.discoverConfiguration(forIssuer: authURL) { [unowned self] conf, _ in
            self.authConfiguration = conf
        }
    }

    private func getConfiguration() -> OIDServiceConfiguration? {
        guard let authURL = URL(string: AuthConstants.authorizationEndpoint),
              let tokenURL = URL(string: AuthConstants.tokenEndpoint) else { return nil}

        return OIDServiceConfiguration(authorizationEndpoint: authURL, tokenEndpoint: tokenURL)
    }
}
