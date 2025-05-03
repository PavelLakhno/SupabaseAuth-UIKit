//
//  SceneDelegate.swift
//  SupabaseAuth-UIKit
//
//  Created by Pavel Lakhno on 17.04.2025.
//

import UIKit
import Supabase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Checking authorization at startup
        checkAuthState()
        
        // Processing Deep Link (if the application was launched via a link)
        if let url = connectionOptions.urlContexts.first?.url {
            handleDeepLink(url)
        }
        
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Checking authorization status
    private func checkAuthState() {
        Task {
            do {
                let session = try await SupabaseManager.shared.client.auth.session
                print("✅ Authorized user:", session.user.email ?? "No email")
                showSuccessViewController()
            } catch {
                print("❌ User is not authorized:", error.localizedDescription)
                showAuthViewController()
            }
        }
    }
    
    // MARK: - Navigation
    
    func showAuthViewController() {
        DispatchQueue.main.async {
            self.window?.rootViewController = AuthViewController()
        }
    }
    
    func showSuccessViewController() {
        DispatchQueue.main.async {
            self.window?.rootViewController = SuccessViewController()
        }
    }

    
    // MARK: - Deep Link processing
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleDeepLink(url)
    }
    
    private func handleDeepLink(_ url: URL) {
        Task {
            do {
                let (accessToken, refreshToken) = try extractTokensFromURL(url)
                try await SupabaseManager.shared.client.auth.setSession(
                    accessToken: accessToken,
                    refreshToken: refreshToken
                )
                showSuccessViewController()
            } catch {
                print("❌ Error Deep Link:", error.localizedDescription)
            }
        }
    }
    
    private func extractTokensFromURL(_ url: URL) throws -> (accessToken: String, refreshToken: String) {
        guard let fragment = url.fragment else {
            throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Incorrect format URL"])
        }
        
        var accessToken: String?
        var refreshToken: String?
        
        let components = fragment.components(separatedBy: "&")
        for component in components {
            if component.starts(with: "access_token=") {
                accessToken = String(component.dropFirst("access_token=".count))
            } else if component.starts(with: "refresh_token=") {
                refreshToken = String(component.dropFirst("refresh_token=".count))
            }
        }
        
        guard let accessToken = accessToken, let refreshToken = refreshToken else {
            throw NSError(domain: "AuthError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Tokens not found in URL"])
        }
        
        return (accessToken, refreshToken)
    }
}

