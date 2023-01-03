//
//  PopUpViewLeaveButton.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 03..
//

import UIKit

class PopUpViewLeaveButton: UIButton {
    init(with title: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        self.tintColor = .label
        self.layer.borderColor = UIColor.systemBackground.cgColor
        self.layer.cornerRadius = 12
        self.backgroundColor = .label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
