//
//  MainViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 27..
//

import UIKit


class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    let answer = "after"
    private var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    
    private let keyboardView = KeyboardView(frame: .zero)
    private let boardView = BoardView(frame: .zero)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        
        keyboardView.delegate = self
        boardView.datasource = self
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemGray2
        
        view.addSubview(keyboardView)
        view.addSubview(boardView)
        
        NSLayoutConstraint.activate([
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: boardView.trailingAnchor, multiplier: 4),
            boardView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
        ])
    }
    
    // MARK: - Selectors
}

// MARK: - BoardViewControllerDataSource

extension MainViewController: BoardViewControllerDataSource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    func boxColor(at indexPath: IndexPath) -> UIColor? {
        let rowIndex = indexPath.section
        
        let count = guesses[rowIndex].compactMap({ $0 }).count
        guard count == 5 else {
            print("DEBUG: At the end")
            return nil
        }
        
        let indexedAnswer = Array(answer)
        guard let letter = guesses[indexPath.section][indexPath.row],
            indexedAnswer.contains(letter) else {
                return nil
            }
        
        if indexedAnswer[indexPath.row] == letter {
            return UIColor.systemGreen
        }
        
        return UIColor.orange
    }
}

extension MainViewController: KeyboardViewDelegate {
    func keyboardView(_ vc: KeyboardView, didTapKey letter: Character) {
        var stop = false
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    stop = true
                    guesses[i][j] = letter
                    break
                }
            }
            
            if stop {
                break
            }
        }
        
        boardView.reloadData()
        print(letter)
    }
}
