//
//  MainMenuViewController.swift
//  Aviators
//
//  Created by Сергей Белоусов on 24.07.2023.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController {
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("PLAY", for: .normal)
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let aboutButton: UIButton = {
        let button = UIButton()
        button.setTitle("ABOUT", for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [playButton, aboutButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }
    
    @objc private func playTapped() {
        let gameVC = GameViewController()
        present(gameVC, animated: true)
    }
    
    private func makeUI() {
        view.addSubview(stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playButton.heightAnchor.constraint(equalToConstant: 60),
            aboutButton.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40)
        ])
    }
}
