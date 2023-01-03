//
//  GameViewTopButton.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 30..
//

import Foundation
import UIKit

class GameViewTopButton: UIButton {
    init(image: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .default)
        let image = UIImage(systemName: image, withConfiguration: imgConfig)
        self.setImage(image, for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.tintColor = UIColor.label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
