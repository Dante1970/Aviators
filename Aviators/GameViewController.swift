//
//  GameViewController.swift
//  Aviators
//
//  Created by Сергей Белоусов on 22.07.2023.
//

import UIKit
import SpriteKit
import GameplayKit

final class GameViewController: UIViewController {
    
    private var gameScene: GameScene!
    private var gameOverViewController: GameOverViewController?
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        button.addTarget(self, action: #selector(closeButtonTupped), for: .touchUpInside)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView()
        view = skView
        
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            
            gameScene = scene as? GameScene

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
    
    // MARK: - Private func
    
    // actions for close button
    @objc
    private func closeButtonTupped() {
        if gameOverViewController == nil {
            gameOverViewController = GameOverViewController()
        }
        
        // Present the GameOverViewController
        if let gameOverVC = gameOverViewController {
            present(gameOverVC, animated: true, completion: nil)
        }
        
        gameScene.closeButtonTupped()
    }
    
    // actions for up button
    @objc
    private func upButtonTouchDown() {
        gameScene.upButtonTouchDown()
    }
    
    @objc
    private func upButtonTouchUpInside() {
        gameScene.upButtonTouchUpInside()
    }
    
    @objc
    private func upButtonTouchUpOutside() {
        gameScene.upButtonTouchUpOutside()
    }
    
    // actions for down button
    @objc
    private func downButtonTouchDown() {
        gameScene.downButtonTouchDown()
    }
    
    @objc
    private func downButtonTouchUpInside() {
        gameScene.downButtonTouchUpInside()
    }
    
    @objc
    private func downButtonTouchUpOutside() {
        gameScene.downButtonTouchUpOutside()
    }
    
    private func makeUI() {
        view.addSubview(closeButton)
        view.addSubview(buttonStackView)
        
        setupConstraints()
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
