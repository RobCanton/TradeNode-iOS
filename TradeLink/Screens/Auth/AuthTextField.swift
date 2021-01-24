//
//  AuthTextField.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-18.
//

import Foundation
import UIKit

protocol AuthTextFieldDelegate:class {
    func authTextFieldDidReturn(id: String)
}

class AuthTextField:UIView, UITextFieldDelegate {
    
    weak var delegate:AuthTextFieldDelegate?
    
    var textField:UITextField!
    var containerView:UIView!
    
    var isEmpty:Bool {
        return textField.text?.isEmpty ?? true
    }
    
    let id:String
    
    init(id:String) {
        self.id = id
        super.init(frame: .zero)
        setup()
    }
    
    
    override init(frame: CGRect) {
        id = ""
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        id = ""
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        
        containerView = UIView()
        self.addSubview(containerView)
        containerView.constraintToSuperview(insets: .zero, ignoreSafeArea: true)
        
        containerView.layer.borderWidth = 2.0 / UIScreen.main.scale
        containerView.layer.borderColor = UIColor.label.cgColor
        containerView.alpha = 0.5
        
        textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18.0, weight: .light)
        
        self.addSubview(textField)
        textField.constraintToSuperview(12, 12, 12, 12, ignoreSafeArea: true)
        textField.delegate = self
        self.constraintHeight(to: 56)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Begin")
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.containerView.alpha = 1.0
            }, completion: nil)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("End")
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.containerView.alpha = 0.5
            }, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.authTextFieldDidReturn(id: id)
        return true
    }
}
