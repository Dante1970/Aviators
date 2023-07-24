//
//  GameOverViewController.swift
//  Aviators
//
//  Created by Сергей Белоусов on 23.07.2023.
//

import UIKit

class GameOverViewController: UIViewController, GameOverViewControllerDelegate {
    
    // MARK: - Public properties
    
    weak var delegate: GameOverViewControllerDelegate?
    
    var score: String? = nil
    
    // MARK: - Private properties
    
    private let backgroundImage = UIImageView(image: UIImage(named: "background"))
    
    private let GameOverLabel: UILabel = {
       let label = UILabel()
       label.text = "Game Over"
       label.font = UIFont.systemFont(ofSize: 40)
       label.textColor = .red
       return label
    }()
    
    private lazy var scoreLabel: UILabel = {
       let label = UILabel()
        label.text = "Your Scores: \(score ?? "0")"
       return label
    }()
    
    private let highScoreLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 20)
       label.textColor = .yellow
       return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [GameOverLabel, scoreLabel, highScoreLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Restart", for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exit", for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(exitGame), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [restartButton, exitButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelStackView, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        
        updateHighScoreLabel()
    }
    
    // MARK: - Public func
    
    @objc func restartGame() {
        delegate?.restartGame()
    }
    
    @objc func exitGame() {
        delegate?.exitGame()
    }
    
    // MARK: - Private func
    
    private func makeUI() {
        view.backgroundColor = .black
        
        view.insertSubview(backgroundImage, at: 0)
        
        view.addSubview(mainStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func updateHighScoreLabel() {
        let highScore = GameManager.shared.loadHighScore()
        highScoreLabel.text = "High Score: \(highScore)"
    }
    
    // MARK: - deinit
    
    deinit {
        print("GameOverViewController deinit")
    }
}
