//
//  AboutViewController.swift
//  Aviators
//
//  Created by Сергей Белоусов on 25.07.2023.
//

import UIKit

class AboutViewController: UIViewController {
    
    private let backgroundImage = UIImageView(image: UIImage(named: "background"))

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the world of aviators! Here, you'll find an exciting adventure in the skies. Embark on thrilling air races, complete missions, and become a true aviator!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Exit", for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }

    private func makeUI() {
        view.insertSubview(backgroundImage, at: 0)
        view.addSubview(descriptionLabel)
        view.addSubview(backButton)
        setupConstraints()
    }

    private func setupConstraints() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            backButton.widthAnchor.constraint(equalToConstant: 250),
            backButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

