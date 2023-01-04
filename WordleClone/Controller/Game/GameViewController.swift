//
//  GameViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 27..
//

import UIKit

protocol GameViewControllerDelegate: AnyObject {
    func didFinishGame(user: User)
}

class GameViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: GameViewControllerDelegate?
    
    let letters = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    private var keys: [[Cell]] = []
    
    private let answers = [
        "while","could","would","first","sound","light","right","world","large","under","about","other","house","place","point",
        "small","after","water","black","state","again","light","night","early","paper","party","place","group","right","since","those"
    ]
    
    private var didWin = false
    private var wordle: Wordle
    private var answer = ""
    private var guesses: [[Cell?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    private var currentGuessIndex = -1
    
    private var user: User
    private var endGamePopUpView = EndGamePopUpView()
    private let keyboardView = KeyboardView(frame: .zero)
    private let boardView = BoardView(frame: .zero)
    private var currentRow = 0
    
    private var exitButton = GameViewTopButton(image: "arrowshape.left")
    private var gameRulesButton = GameViewTopButton(image: "questionmark.diamond")
    private var statisticsButton = GameViewTopButton(image: "chart.bar.xaxis")
    
    // MARK: - LifeCycle
    
    init(with wordle: Wordle, user: User) {
        self.wordle = wordle

        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endGamePopUpView.delegate = self
        
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
        
        exitButton.addTarget(self, action: #selector(didTapExit(sender:)), for: .touchUpInside)
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
            boardView.topAnchor.constraint(equalToSystemSpacingBelow: exitButton.bottomAnchor, multiplier: 2),
            keyboardView.topAnchor.constraint(equalToSystemSpacingBelow: boardView.bottomAnchor, multiplier: 2),
        ])
    }
    
    private func addEndGamePopUpViewToView() {
        view.addSubview(endGamePopUpView)
        
        NSLayoutConstraint.activate([
            endGamePopUpView.topAnchor.constraint(equalTo: view.topAnchor),
            endGamePopUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            endGamePopUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            endGamePopUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func createTopItems() {
        view.addSubview(exitButton)
        view.addSubview(gameRulesButton)
        view.addSubview(statisticsButton)
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            exitButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            gameRulesButton.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor),
            statisticsButton.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor),
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
    
    private func disableKeyboardAfterGameEnds() {
        self.keyboardView.isUserInteractionEnabled = false
    }
    
    private func updateUserStats(didWin: Bool) {
        if didWin {
            self.user.stats.wins += 1
            self.user.stats.streak += 1
            if self.user.stats.streak > self.user.stats.maxStreak {
                self.user.stats.maxStreak = self.user.stats.streak
            }
        } else {
            self.user.stats.losses += 1
            self.user.stats.streak = 0
        }
        
        self.endGamePopUpView.setStatValues(with: self.user)
        
        UserService.shared.uploadGame(user: self.user) { error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            
            self.delegate?.didFinishGame(user: self.user)
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
    }
    
    @objc private func didTapExit(sender: UIButton) {
        self.animateButtonTap(button: sender)
        
        let alert = UIAlertController(title: "Do you want to exit?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
//        AuthService.shared.signOut { [weak self] error in
//            guard let strongSelf = self else { return }
//            if let error = error {
//                AlertManager.showLogoutErrorAlert(on: strongSelf, with: error)
//                return
//            }
//
//            if let sceneDelegate = strongSelf.view.window?.windowScene?.delegate as? SceneDelegate {
//                sceneDelegate.checkAuthentication()
//            }
//        }
        
        self.present(alert, animated: true)
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

extension GameViewController: BoardViewDataSource {
    
    var currentGuesses: [[Cell?]] {
        return guesses
    }
}

extension GameViewController: KeyboardViewDataSource {
    var keyCells: [[Cell]] {
        return self.keys
    }
}

// MARK: - KeyboardViewDelegate

extension GameViewController: KeyboardViewDelegate {
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
            //PopUp View
            self.updateUserStats(didWin: true)
            DispatchQueue.main.async {
                self.addEndGamePopUpViewToView()
                self.disableKeyboardAfterGameEnds()
                self.endGamePopUpView.animateIn(didWin: true)
            }
        } else {
            self.currentRow += 1
            self.currentGuessIndex = -1
            if currentRow == 6 {
                //user lost
                self.updateUserStats(didWin: false)
                DispatchQueue.main.async {
                    self.addEndGamePopUpViewToView()
                    self.disableKeyboardAfterGameEnds()
                    self.endGamePopUpView.animateIn(didWin: false)
                }
            }
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

// MARK: - EndGamePopUpViewDelegate

extension GameViewController: EndGamePopUpViewDelegate {
    func didTapMenu() {
        self.dismiss(animated: true)
    }
}
