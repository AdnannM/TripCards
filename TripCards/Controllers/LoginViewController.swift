//
//  LoginViewController.swift
//  TripCards
//
//  Created by Adnann Muratovic on 10.09.21.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var logoImageVIew: UIImageView! {
        didSet {
            logoImageVIew.layer.borderColor = UIColor.systemBlue.cgColor
            logoImageVIew.layer.borderWidth = 2
            logoImageVIew.layer.cornerRadius = 280.0
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.textColor = .systemBackground
            emailTextField.backgroundColor = UIColor.white
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.backgroundColor = UIColor.white
            passwordTextField.textColor = .systemBackground
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.layer.cornerRadius = 20.0
            signInButton.layer.borderColor = UIColor.white.cgColor
            signInButton.layer.borderWidth = 0.8
        }
    }
    
    @IBOutlet weak var loginView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.isHidden = true
        authenticationWithBiometric()
        blur()
        
    }
    
    // MARK: - Hide loginView
    private func showDialog() {
        // Move loginView off Screen
        loginView.isHidden = false
        loginView.transform = CGAffineTransform(translationX: 0, y: -700)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
            self.loginView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // MARK: - Blur Background
    private func blur() {
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
    }
    
    // MARK: - Action Button
    @IBAction func signInButtonTapped(_ sender: Any) {
        if emailTextField.text == "adnann@gmail.com" && passwordTextField.text == "12345" {
            performSegue(withIdentifier: "showTripCards", sender: nil)
        } else {
            // Shake view indicate wrong email or password
            loginView.transform = CGAffineTransform(translationX: 25, y: 0)
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
                self.loginView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}

// MARK: - Login Authentication TouchID/FaceID
extension LoginViewController {
    func authenticationWithBiometric() {
        // Get local auth context
        let localAuthContext = LAContext()
        let reasonText = "Authentication is required to Sign In to TripCards"
        
        var authError: NSError?
        
        if !localAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            if let error = authError {
                print(error.localizedDescription)
            }
            
            // Display login if TouchID of FaceID is not available
            showDialog()
            return
        }
        // Perform the biometrics authentication
        localAuthContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                        localizedReason: reasonText) { success, error in
            // Failure
            if !success {
                if let error = error {
                    switch error {
                    case LAError.authenticationFailed:
                        print("Authentication Failed try again!")
                    case LAError.passcodeNotSet:
                        print("Passcode is not set")
                    case LAError.systemCancel:
                        print("Authentication was canceled by the system")
                    case LAError.userCancel:
                        print("Authentication was canceled by the user")
                    case LAError.biometryNotEnrolled:
                        print("Authentication could not start because you haven't enrolled either TouchID or FaceID on your device")
                    case LAError.biometryNotAvailable:
                        print("Authentication could not start because TouchID or FaceID is not available")
                    case LAError.userFallback:
                        print("User tapped Fallback button(Enter the Passwrod")
                    default:
                        print(error.localizedDescription)
                    }
                }
                
                // Fallback to the password authentication
                OperationQueue.main.addOperation {
                    self.showDialog()
                }
            } else {
                // Success workflow
                print("Successefully Login wiht FaceID")
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "showTripCards", sender: nil)
                }
            }
        }
    }
}
