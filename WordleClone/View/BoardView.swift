//
//  BoardView.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 28..
//

import Foundation
import UIKit

protocol BoardViewControllerDataSource: AnyObject {
    var currentGuesses: [[Character?]] { get }
    func boxColor(at indexPath: IndexPath) -> UIColor?
}

class BoardView: UIView {
    
    // MARK: - Properties

    weak var datasource: BoardViewControllerDataSource?
    
    private let boardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        
        return collectionView
    }()
    
    override var intrinsicContentSize: CGSize {
        let margin: CGFloat = 20
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: width + 2)
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        boardCollectionView.delegate = self
        boardCollectionView.dataSource = self
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .clear
        
        self.addSubview(boardCollectionView)
        
        NSLayoutConstraint.activate([
            boardCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            boardCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            boardCollectionView.topAnchor.constraint(equalTo: topAnchor),
            boardCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func reloadData() {
        boardCollectionView.reloadData()
    }
    
    // MARK: - Selectors
}

//MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

extension BoardView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.currentGuesses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let guesses = datasource?.currentGuesses ?? []
        return guesses[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width-margin)/5
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var left: CGFloat = 2
        var right: CGFloat = 2
        
        return UIEdgeInsets(top: 2, left: left, bottom: 2, right: right)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else { fatalError() }
        
        let guesses = datasource?.currentGuesses ?? []
        if let letter = guesses[indexPath.section][indexPath.row] {
            cell.configure(with: letter)
        }
        return cell
    }
    
    
}
