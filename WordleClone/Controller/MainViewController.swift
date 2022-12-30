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
    
    private var settingsButton: MainViewTopButton = MainViewTopButton(image: "gearshape")
    private var gameRulesButton: MainViewTopButton = MainViewTopButton(image: "questionmark.diamond")
    private var statisticsButton: MainViewTopButton = MainViewTopButton(image: "chart.bar.xaxis")
    
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
        
        settingsButton.addTarget(self, action: #selector(didTapSettings(sender:)), for: .touchUpInside)
        gameRulesButton.addTarget(self, action: #selector(didTapRules(sender:)), for: .touchUpInside)
        statisticsButton.addTarget(self, action: #selector(didTapStatistics(sender:)), for: .touchUpInside)
        
        keyboardView.delegate = self
        keyboardView.datasource = self
        boardView.datasource = self
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = UIColor.systemBackground
        
        self.createTopItems()
        self.navigationController?.navigationBar.isHidden = true
        
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
            boardView.topAnchor.constraint(equalToSystemSpacingBelow: settingsButton.bottomAnchor, multiplier: 2),
            keyboardView.topAnchor.constraint(equalToSystemSpacingBelow: boardView.bottomAnchor, multiplier: 2),
        ])
        
    }
    
    private func createTopItems() {
        view.addSubview(settingsButton)
        view.addSubview(gameRulesButton)
        view.addSubview(statisticsButton)
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            settingsButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            gameRulesButton.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor),
            statisticsButton.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: gameRulesButton.trailingAnchor, multiplier: 4),
            gameRulesButton.leadingAnchor.constraint(equalToSystemSpacingAfter: statisticsButton.trailingAnchor, multiplier: 2),
        ])
    }
    
    private func colorKeys() {
        for i in 0..<guesses[currentRow].count {
            let guessCell = guesses[currentRow][i]
            for j in 0..<self.keys.count {
                for k in 0..<self.keys[j].count {
                    if guessCell?.char == self.keys[j][k].char {
                        if let color = guessCell?.color, color != UIColor.clear {
                            if self.keys[j][k].color != UIColor.systemGreen {
                                self.keys[j][k].color = color
                            }
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
    
    private func checkWin() -> Bool{
        let countGreens = self.guesses[currentRow].filter({$0?.color == UIColor.systemGreen}).count
        
        return countGreens == 5
        
    }
    
    private func animateButtonTap(button: UIButton) {
        UIView.animate(withDuration: 0.25,
                       animations: {
            //Fade-out
            button.layer.opacity = 0.5
        }) { (completed) in
            UIView.animate(withDuration: 0.25,
                           animations: {
                //Fade-out
                button.layer.opacity = 1
            })
        }
    }
    // MARK: - Selectors
    
    @objc private func didTapStatistics(sender: UIButton) {
        self.animateButtonTap(button: sender)
    }
    
    @objc private func didTapRules(sender: UIButton) {
        self.animateButtonTap(button: sender)
        let vc = RulesViewController()
        self.present(vc, animated: true)
        print("didtaprues")
    }
    
    @objc private func didTapSettings(sender: UIButton) {
        self.animateButtonTap(button: sender)
        AuthService.shared.signOut { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                AlertManager.showLogoutErrorAlert(on: strongSelf, with: error)
                return
            }
            
            if let sceneDelegate = strongSelf.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                AlertManager.showLogoutErrorAlert(on: strongSelf, with: error)
                return
            }
            
            if let sceneDelegate = strongSelf.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
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
        
        //Check win
        self.boardView.reloadData(won: nil, at: nil)
        self.keyboardView.reloadData()
        
        if self.checkWin() {
            self.boardView.reloadData(won: true, at: currentRow)
        } else {
            self.currentRow += 1
            self.currentGuessIndex = -1
        }
    }
    
    func didTapRemoveChar(_ v: KeyboardView) {
        if(self.currentGuessIndex != -1) {
            self.guesses[currentRow][currentGuessIndex] = nil
            self.currentGuessIndex -= 1
            self.boardView.reloadData(won: nil, at: nil)
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
        
        boardView.reloadData(won: nil, at: nil)
    }
}
