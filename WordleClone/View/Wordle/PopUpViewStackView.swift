//
//  PopUpViewStackView.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 03..
//

import UIKit

class PopUpViewStackView: UIStackView {
    init() {
        super.init(frame: .zero)
        distribution = .fill
        axis = .horizontal
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
