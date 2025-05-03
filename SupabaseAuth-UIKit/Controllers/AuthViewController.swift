
import UIKit
import Supabase

class AuthViewController: UIViewController {
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let otpToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Use OTP instead", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isOTPLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(otpToggleButton)
        
        NSLayoutConstraint.activate([
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            signInButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
            
            otpToggleButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 8),
            otpToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: otpToggleButton.bottomAnchor, constant: 16),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        otpToggleButton.addTarget(self, action: #selector(toggleOTPLogin), for: .touchUpInside)
    }
    
    @objc private func toggleOTPLogin() {
        isOTPLogin.toggle()
        
        if isOTPLogin {
            otpToggleButton.setTitle("Use Password instead", for: .normal)
            passwordTextField.isHidden = true
            signInButton.setTitle("Send OTP", for: .normal)
        } else {
            otpToggleButton.setTitle("Use OTP instead", for: .normal)
            passwordTextField.isHidden = false
            signInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @objc private func signInTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email")
            return
        }

        Task {
            do {
                if isOTPLogin {
                    try await SupabaseManager.shared.client.auth.signInWithOTP(
                        email: email,
                        redirectTo: URL(string: "auth.supabase.test://login-callback"),
                        shouldCreateUser: true
                    )
                    showAlert(message: "OTP sent! Check your email.")
                } else {
                    guard let password = passwordTextField.text, !password.isEmpty else {
                        showAlert(message: "Please enter your password")
                        return
                    }
                    let response = try await SupabaseManager.shared.client.auth.signIn(
                        email: email,
                        password: password
                    )
                    print("✅ Login completed:", response.user.email ?? "No email")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.showSuccessViewController()
                }
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please fill in all fields")
            return
        }
        
        Task {
            do {
                let response = try await SupabaseManager.shared.client.auth.signUp(
                    email: email,
                    password: password
                )
                print("Signed up successfully: \(response)")
                showAlert(message: "Please check your email to confirm your account")
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
    

