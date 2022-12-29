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
    private var guesses: [[Cell]] = Array(repeating: Array(repeating: Cell(char: nil, color: UIColor.clear), count: 5), count: 6)
    
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
        self.view.backgroundColor = .white
        
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
    
    func boxColor(at x: Int, y: Int) -> UIColor? {
        guard let char = guesses[x][y].char else {
            return UIColor.clear
        }
        
        let indexedAnswer = Array(answer)
        
        if(indexedAnswer[y] == char) {
            return UIColor.systemGreen
        } else if (indexedAnswer.contains(char)) {
            return UIColor.systemOrange
        }
        
        return UIColor.clear
    }
    // MARK: - Selectors
}

// MARK: - BoardViewControllerDataSource

extension MainViewController: BoardViewControllerDataSource {
    
    var currentGuesses: [[Cell]] {
        return guesses
    }
}

extension MainViewController: KeyboardViewDelegate {
    func keyboardView(_ vc: KeyboardView, didTapKey letter: Character) {
        var stop = false
        var endRow = false
        var row: Int = 0
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j].char == nil {
                    stop = true
                    guesses[i][j] = Cell(char: letter, color: UIColor.clear)
                    
                    if j == 4 {
                        endRow = true
                        row = i
                    }
                    
                    break
                }
            }
            
            if stop {
                break
            }
        }
        
        if endRow {
            for i in 0..<guesses[row].count {
                guesses[row][i].color = boxColor(at: row, y: i)
            }
        }
        
        boardView.reloadData()
    }
}
