//
//  GameViewController.swift
//  Aviators
//
//  Created by Сергей Белоусов on 22.07.2023.
//

import UIKit
import SpriteKit
import GameplayKit

final class GameViewController: UIViewController, GameSceneDelegate, GameOverViewControllerDelegate {
    
    // MARK: - Private properties
    
    private var gameScene: GameScene!
    private var gameOverViewController: GameOverViewController?
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let upButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.compact.up")
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(upButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(upButtonTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(upButtonTouchUpOutside), for: .touchUpOutside)
        return button
    }()
    
    private let downButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.compact.down")
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(downButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(downButtonTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(downButtonTouchUpOutside), for: .touchUpOutside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [upButton, downButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView()
        view = skView
        
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            
            gameScene = scene as? GameScene
            gameScene.gameSceneDelegate = self

            skView.presentScene(scene)
            
            makeUI()
        }
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }


    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Public func
    
    func gameOver(score: String) {
        if gameOverViewController == nil {
            gameOverViewController = GameOverViewController()
            gameOverViewController?.delegate = self
        }
        
        if let gameOverVC = gameOverViewController, presentedViewController == nil {
            gameOverVC.score = score
            gameOverVC.modalPresentationStyle = .fullScreen
            present(gameOverVC, animated: true, completion: nil)
        }
    }
    
    func restartGame() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.gameScene.resetTheGame()
        }
    }
    
    func exitGame() {
        dismissToRootViewController()
    }

    
    // MARK: - Private func
    
    @objc private func closeButtonTapped() {
        gameScene.closeButtonTapped()
        dismissToRootViewController()
    }
    
    @objc private func upButtonTouchDown() {
        gameScene.upButtonTouchDown()
    }
    
    @objc private func upButtonTouchUpInside() {
        gameScene.upButtonTouchUpInside()
    }
    
    @objc private func upButtonTouchUpOutside() {
        gameScene.upButtonTouchUpOutside()
    }
    
    @objc private func downButtonTouchDown() {
        gameScene.downButtonTouchDown()
    }
    
    @objc private func downButtonTouchUpInside() {
        gameScene.downButtonTouchUpInside()
    }
    
    @objc private func downButtonTouchUpOutside() {
        gameScene.downButtonTouchUpOutside()
    }
    
    private func makeUI() {
        view.addSubview(closeButton)
        view.addSubview(buttonStackView)
        
        setupConstraints()
    }
    
    private func dismissToRootViewController() {
        var presentingViewController = self.presentingViewController
        while presentingViewController != nil {
            let nextPresentingVC = presentingViewController?.presentingViewController
            presentingViewController?.dismiss(animated: false, completion: nil)
            presentingViewController = nextPresentingVC
        }
    }
    
    private func setupConstraints() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
