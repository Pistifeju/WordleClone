//
//  CustomAuthTextField.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 30..
//

import UIKit

enum CustomAuthTextFieldType {
    case username
    case email
    case password
}

class CustomAuthTextField: UITextField {
    
    // MARK: - Properties
    private let authFieldType: CustomAuthTextFieldType
    
    // MARK: - Lifecycle
    init(textFieldType: CustomAuthTextFieldType) {
        self.authFieldType = textFieldType
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .secondarySystemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        
        switch authFieldType {
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.isSecureTextEntry = true
        }
    }
    
    // MARK: - Selectors
    
}

