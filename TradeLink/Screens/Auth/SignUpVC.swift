//
//  SignUpVC.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-19.
//

import Foundation
import UIKit
import Firebase
import Combine

class SignUpVC:UIViewController {
    
    var requests = Set<AnyCancellable>()
    
    var tableView:UITableView!
    var scrollView:UIScrollView!
    
    let email:String?
    let password:String?
    
    init(email:String?, password:String?) {
        self.email = email
        self.password = password
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var usernameField:AuthTextField!
    var emailField:AuthTextField!
    var passwordField:AuthTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        self.title = "Sign Up"
        
//        self.extendedLayoutIncludesOpaqueBars = false
//        self.navigationController?.navigationBar.backgroundColor = UIColor.black
//        self.navigationController?.navigationBar.barTintColor = .black
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.tintColor = .white
    
//        self.navigationItem.title = "Sign Up"
//        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Full Arrow Left"),
//                                                                style: .plain,
//                                                                target: self,
//                                                                action: #selector(handleClose))
        
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.constraintToSuperview(insets: .zero, ignoreSafeArea: false)
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        let stackView = UIStackView()
        //stackView.distribution = .fillProportionally
        stackView.spacing = 12
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(16, 16, 32, 16, ignoreSafeArea: true)
        
        usernameField = AuthTextField(id: "username")
        usernameField.textField.placeholder = "Username"
        usernameField.textField.keyboardType = .asciiCapable
        usernameField.textField.autocapitalizationType = .none
        usernameField.textField.spellCheckingType = .no
        usernameField.textField.returnKeyType = .next
        usernameField.delegate = self
        
        emailField = AuthTextField(id: "email")
        emailField.textField.text = email
        emailField.textField.placeholder = "Email Address"
        emailField.textField.keyboardType = .emailAddress
        emailField.textField.autocapitalizationType = .none
        emailField.textField.spellCheckingType = .no
        emailField.textField.returnKeyType = .next
        emailField.delegate = self
        
        passwordField = AuthTextField(id: "password")
        passwordField.textField.text = password
        passwordField.textField.placeholder = "Password"
        passwordField.textField.keyboardType = .asciiCapable
        passwordField.textField.isSecureTextEntry = true
        passwordField.textField.autocapitalizationType = .none
        passwordField.textField.spellCheckingType = .no
        passwordField.textField.returnKeyType = .go
        passwordField.delegate = self
        
        stackView.addArrangedSubview(usernameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        
        let submit = createSubmitButton()
        submit.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        stackView.addArrangedSubview(submit)
        
        let spacer = UIView()
        stackView.addArrangedSubview(spacer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.usernameField.textField.becomeFirstResponder()
        }
        
    }
    
    @objc func handleSubmit() {
        guard let email = emailField.textField.text else { return }
        guard let password = passwordField.textField.text else { return }
        guard let username = usernameField.textField.text else { return }
        
        let userCreateDTO = UserCreateDTO(username: username)
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let auth = authResult, error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            AuthManager.shared.sessionType = .newUser(dto: userCreateDTO)
            
        }
        
    }
    
    
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createSubmitButton() -> UIButton {
        let button = UIButton(type: .system)
        button.constraintHeight(to: 56)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        button.setTitle("Submit", for: .normal)
        return button
    }
}

extension SignUpVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}



extension SignUpVC: AuthTextFieldDelegate {
    func authTextFieldDidReturn(id: String) {
        switch id {
        case "username":
            usernameField.textField.resignFirstResponder()
            emailField.textField.becomeFirstResponder()
            break
        case "email":
            emailField.textField.resignFirstResponder()
            passwordField.textField.becomeFirstResponder()
            break
        case "password":
            handleSubmit()
            break
        default:
            break
        }
    }
    
}
