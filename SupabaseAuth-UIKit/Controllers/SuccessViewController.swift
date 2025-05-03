//
//  ViewController.swift
//  SupabaseAuth-UIKit
//
//  Created by Pavel Lakhno on 17.04.2025.
//

import UIKit

class SuccessViewController: UIViewController {
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "✅ Login completed"
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(successLabel)
        view.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            successLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            successLabel.heightAnchor.constraint(equalToConstant: 44),
            
            signOutButton.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 16),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupActions() {
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
    }
    
    @objc private func signOutTapped() {
        Task {
            do {
                try await SupabaseManager.shared.client.auth.signOut()
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.showAuthViewController()
                print("✅ Exit completed")
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

