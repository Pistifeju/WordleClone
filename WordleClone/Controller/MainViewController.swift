//
//  MainViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 27..
//

import UIKit


class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    let letters = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    private var keys: [[Cell]] = []
    
    private let answers = [
        "while","could","would","first","sound","light","right","world","large","under","about","other","house","place","point",
        "small","after","water","black","state","again","light","night","early","paper","party","place","group","right","since","those"
    ]
    
    private var answer = ""
    private var guesses: [[Cell?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    private var currentGuessIndex = -1
    
    private let keyboardView = KeyboardView(frame: .zero)
    private let boardView = BoardView(frame: .zero)
    private var currentRow = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for row in letters {
            let chars = Array(row)
            var cells: [Cell] = []
            for i in 0..<chars.count {
                cells.append(Cell(char: chars[i]))
            }
            keys.append(cells)
        }
        
        self.answer = answers.randomElement() ?? "after"
        print(answer)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        
        keyboardView.delegate = self
        keyboardView.datasource = self
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
    
    private func createTopItems() {
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .default)
        let image = UIImage(systemName: "line.3.horizontal", withConfiguration: imgConfig)
        let imageView = UIImageView(image: image)
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: imageView)
        imageView.tintColor = UIColor.black
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.target = self
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.action = #selector(didTapMenu)
    }
    
    private func colorKeys() {
        for i in 0..<guesses[currentRow].count {
            let guessCell = guesses[currentRow][i]
            for j in 0..<self.keys.count {
                for k in 0..<self.keys[j].count {
                    if guessCell?.char == self.keys[j][k].char {
                        if let color = guessCell?.color, color != UIColor.clear {
                            self.keys[j][k].color = color
                        } else {
                            self.keys[j][k].color = UIColor.systemGray2
                        }
                    }
                }
            }
        }
    }
    
    private func boxColor(at x: Int, y: Int) -> UIColor? {
        guard let cell = guesses[x][y] else {
            return UIColor.clear
        }
        
        let indexedAnswer = Array(answer)
        
        if(indexedAnswer[y] == cell.char) {
            return UIColor.systemGreen
        } else if (indexedAnswer.contains(cell.char)) {
            return UIColor.systemOrange
        }
        
        return UIColor.clear
    }
    // MARK: - Selectors
    
    @objc private func didTapMenu() {
        print("ye")
    }
}



// MARK: - BoardViewControllerDataSource

extension MainViewController: BoardViewDataSource {
    
    var currentGuesses: [[Cell?]] {
        return guesses
    }
}

extension MainViewController: KeyboardViewDataSource {
    var keyCells: [[Cell]] {
        return self.keys
    }
}

// MARK: - KeyboardViewDelegate

extension MainViewController: KeyboardViewDelegate {
    func didTapEnter(_ v: KeyboardView) {
        guard let _ = self.guesses[self.currentRow][4] else {
            print("Nem jo, csinalj itt egy shake animaciot pl.")
            return
        }
        
        //Color board
        for i in 0..<self.guesses[self.currentRow].count {
            let color = self.boxColor(at: self.currentRow, y: i)
            self.guesses[self.currentRow][i]?.color = color
        }
        
        //Color keys
        self.colorKeys()
        
        self.boardView.reloadData()
        self.keyboardView.reloadData()
        self.currentRow += 1
        self.currentGuessIndex = -1
    }
    
    func didTapRemoveChar(_ v: KeyboardView) {
        if(self.currentGuessIndex != -1) {
            self.guesses[currentRow][currentGuessIndex] = nil
            self.currentGuessIndex -= 1
            self.boardView.reloadData()
        }
    }
    
    func keyboardView(_ vc: KeyboardView, didTapKey letter: Character) {
        if currentGuessIndex != 4 {
            var stop = false
            for i in 0..<guesses.count {
                for j in 0..<guesses[i].count {
                    
                    if guesses[i][j] == nil {
                        stop = true
                        guesses[i][j] = Cell(char: letter, color: UIColor.clear)
                        currentGuessIndex += 1
                        break
                    }
                }
                
                if stop {
                    break
                }
            }
        }
        
        print(currentGuessIndex)
        print(currentRow)
        boardView.reloadData()
    }
}
