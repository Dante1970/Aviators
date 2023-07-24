//
//  GameOverViewController.swift
//  Aviators
//
//  Created by Сергей Белоусов on 23.07.2023.
//

import UIKit

class GameOverViewController: UIViewController {
    
    private let GameOverLabel: UILabel = {
       let label = UILabel()
       label.text = "Game Over"
       return label
    }()
    
    private let scoreLabel: UILabel = {
       let label = UILabel()
       label.text = "Your Scores:"
       return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [GameOverLabel, scoreLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }
    
    private func makeUI() {
        view.backgroundColor = .black
        
        view.addSubview(labelStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
