//
//  CustomStatisticsLabel.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 01..
//

import UIKit

class CustomStatisticsLabel: UILabel {
    
    var number = 0
    
    init(with title: String, isNumber: Bool) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        numberOfLines = 0
        textAlignment = .center
        if isNumber {
            text = "\(number)"
            font = UIFont.systemFont(ofSize: 22, weight: .medium)
        } else {
            text = title
            font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

