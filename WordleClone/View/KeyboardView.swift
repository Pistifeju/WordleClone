//
//  KeyboardView.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 27..
//

import Foundation
import UIKit

protocol KeyboardViewDelegate: AnyObject {
    func keyboardView(_ vc: KeyboardView, didTapKey letter: Character)
}

class KeyboardView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: KeyboardViewDelegate?
    
    let letters = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    private var keys: [[Character]] = []
    
    private let keyboardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        
        return collectionView
    }()
    
    private let enterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ENTER", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 1.0
        button.layer.masksToBounds = false
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    private let removeCharButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("<", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 1.0
        button.layer.masksToBounds = false
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        let width = UIScreen.main.bounds.width
        let cellHeight = (width / 10) * 1.5
        return CGSize(width: width, height: cellHeight * 3 + 15 + 16 + cellHeight)
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        keyboardCollectionView.delegate = self
        keyboardCollectionView.dataSource = self
        
        for row in letters {
            let chars = Array(row)
            keys.append(chars)
        }
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .clear
        
        self.addSubview(keyboardCollectionView)
        self.addSubview(enterButton)
        self.addSubview(removeCharButton)
        
        let width = UIScreen.main.bounds.width
        let cellHeight = (width / 10) * 1.5
        NSLayoutConstraint.activate([
            keyboardCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            keyboardCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            keyboardCollectionView.topAnchor.constraint(equalTo: topAnchor),
            keyboardCollectionView.heightAnchor.constraint(equalToConstant: cellHeight * 3 + 15)
        ])
        
        NSLayoutConstraint.activate([
            enterButton.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            enterButton.topAnchor.constraint(equalToSystemSpacingBelow: keyboardCollectionView.bottomAnchor, multiplier: 2),
            enterButton.heightAnchor.constraint(equalToConstant: cellHeight),
            enterButton.widthAnchor.constraint(equalToConstant: cellHeight*2),
        ])
        
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalToSystemSpacingAfter: removeCharButton.trailingAnchor, multiplier: 2),
            removeCharButton.topAnchor.constraint(equalToSystemSpacingBelow: keyboardCollectionView.bottomAnchor, multiplier: 2),
            removeCharButton.heightAnchor.constraint(equalToConstant: cellHeight),
            removeCharButton.widthAnchor.constraint(equalToConstant: cellHeight*2),
        ])
    }
    
    // MARK: - Selectors
}

//MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

extension KeyboardView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
            //Fade-out
            cell?.alpha = 0.5
        }) { (completed) in
            UIView.animate(withDuration: 0.3,
                           animations: {
                //Fade-out
                cell?.alpha = 1
            })
        }
        
        let letter = self.keys[indexPath.section][indexPath.row]
        
        delegate?.keyboardView(self, didTapKey: letter)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidth = (collectionView.frame.size.width - 50) / 10
        let cellCount: CGFloat = CGFloat(keys[section].count)
        
        let totalWidth = cellWidth * cellCount
        let totalSpacingWidth = 5 * (cellCount - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        
        let rightInset = leftInset

        return UIEdgeInsets(top: 5, left: leftInset, bottom: 5, right: rightInset)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGFloat = (collectionView.frame.size.width - 50) / 10
        
        return CGSize(width: size, height: size * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else { fatalError() }
        
        let letter = keys[indexPath.section][indexPath.row]
        cell.configure(with: letter)
        
        return cell
    }
}
