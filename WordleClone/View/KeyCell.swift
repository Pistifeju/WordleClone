//
//  KeyCell.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 27..
//

import Foundation
import UIKit

class KeyCell: UICollectionViewCell {
    static let identifier = "KeyCell"
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGray2
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(letterLabel)
        
        self.backgroundColor = nil
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        
        NSLayoutConstraint.activate([
            letterLabel.topAnchor.constraint(equalTo: topAnchor),
            letterLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            letterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            letterLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        letterLabel.text = nil
    }
    
    func configure(with letter: Character) {
        letterLabel.text = String(letter).uppercased()
    }
}
