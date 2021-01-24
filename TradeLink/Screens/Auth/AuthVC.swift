//
//  AuthVC.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-18.
//

import Foundation
import UIKit
import Firebase

class AuthViewController:UIViewController {
    
    var titleLabel = UILabel()
    var iconView = UIImageView()
    
    var emailField:AuthTextField!
    var passwordField:AuthTextField!
    
    var signInButton:UIButton!
    var signUpButton:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        iconView.image = UIImage(named: "Icon")
        view.addSubview(iconView)
        iconView.contentMode = .scaleAspectFit
        iconView.constraintToCenter(axis: [.x])
        iconView.constraintToSuperview(-32, nil, nil, nil, ignoreSafeArea: false)
        iconView.constraintWidth(to: 128.0)
        iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor).isActive = true
        
        titleLabel = UILabel()
        titleLabel.text = "TradeNode"
        titleLabel.font = UIFont.systemFont(ofSize: 28.0, weight: .heavy)
        view.addSubview(titleLabel)
        titleLabel.constraintToCenter(axis: [.x])
        titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: -8).isActive = true
        
        
        emailField = AuthTextField(id: "email")
        emailField.textField.placeholder = "Email Address"
        emailField.textField.keyboardType = .emailAddress
        emailField.textField.autocapitalizationType = .none
        emailField.textField.spellCheckingType = .no
        emailField.textField.returnKeyType = .next
        emailField.delegate = self
        
        passwordField = AuthTextField(id: "password")
        passwordField.textField.placeholder = "Password"
        passwordField.textField.keyboardType = .asciiCapable
        passwordField.textField.isSecureTextEntry = true
        passwordField.textField.autocapitalizationType = .none
        passwordField.textField.spellCheckingType = .no
        passwordField.textField.returnKeyType = .go
        passwordField.delegate = self
        
        emailField.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        signUpButton = createSignUpButton()
        signInButton = createSignInButton()
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12.0
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44).isActive = true
        stackView.constraintToSuperview(nil, 16, 32, 16, ignoreSafeArea: false)
        
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        
        //signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInButton.isEnabled = false
        
//        let signRow = UIStackView()
//        signRow.axis = .horizontal
//        signRow.distribution = .fillEqually
//        signRow.spacing = 12.0
//
//        signRow.addArrangedSubview(signUpButton)
//        signRow.addArrangedSubview(signInButton)
//
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(signUpButton)
        
        let spacer = UIView()
        
        stackView.addArrangedSubview(spacer)
        
        let appleButton = createAppleButton()
        stackView.addArrangedSubview(appleButton)
        
        let googleButton = createGoogleButton()
        stackView.addArrangedSubview(googleButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignAll))
        tap.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(resignAll))
        view.addGestureRecognizer(pan)
        view.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    @objc func signUp() {
        
        let vc = SignUpVC(email: emailField.textField.text,
                          password: passwordField.textField.text)
        self.navigationController?.pushViewController(vc, animated: true)
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalTransitionStyle = .crossDissolve
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func signIn() {
        guard let email = emailField.textField.text else { return }
        guard let password = passwordField.textField.text else { return }
        print("signIn!")
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            
            print("Authenticated!")
          // ...
        }
        
    }
    
    @objc func resignAll() {
        emailField.textField.resignFirstResponder()
        passwordField.textField.resignFirstResponder()
    }
    
    func createSignUpButton() -> UIView {
        
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        
        let title = UILabel()
        title.text = "Don't have an account?"
        title.textColor = .secondaryLabel
        title.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        //let button = UIButton(type: .system)
        row.addArrangedSubview(title)
        
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        row.addArrangedSubview(button)
        
        
        let content = UIView()
        content.constraintHeight(to: 36)
        
        content.addSubview(row)
        
        row.constraintToCenter(axis: [.x, .y])
        return content
//        button.constraintHeight(to: 36)
//        //button.backgroundColor = UIColor.white
//        button.setTitleColor(UIColor.systemBlue, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
//        button.setTitle("Create an Account", for: .normal)
//        return button
    }
    
    func createSignInButton() -> UIButton {
        let button = UIButton(type: .system)
        button.constraintHeight(to: 56)
        //button.backgroundColor = UIColor.systemBlue
        button.setBackgroundColor(color: .systemBlue, forState: .normal)
        button.setBackgroundColor(color: .systemGray6, forState: .disabled)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.systemGray2, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        button.setTitle("Sign In", for: .normal)
        return button
    }
    
    func createAppleButton() -> UIButton {
        let button = UIButton(type: .system)
        button.constraintHeight(to: 56)
        button.backgroundColor = UIColor.label
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        button.setTitle("Sign In with Apple", for: .normal)
        return button
    }
    
    func createGoogleButton() -> UIButton {
        let button = UIButton(type: .system)
        button.constraintHeight(to: 56)
        button.backgroundColor = UIColor(hex: "4285F4")
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        button.setTitle("Sign In with Google", for: .normal)
        return button
    }
    
    @objc func textDidChange(_ textField:UITextField) {
        
        let formComplete = !emailField.isEmpty && !passwordField.isEmpty
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.signInButton.isEnabled = formComplete
        }, completion: nil)
        
    }
    
}


extension AuthViewController: AuthTextFieldDelegate {
    func authTextFieldDidReturn(id: String) {
        switch id {
        case "email":
            emailField.textField.resignFirstResponder()
            passwordField.textField.becomeFirstResponder()
            break
        case "password":
            signIn()
            break
        default:
            break
        }
    }
    
}
