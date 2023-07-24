//
//  MainMenuViewController.swift
//  Aviators
//
//  Created by Сергей Белоусов on 24.07.2023.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let backgroundImage = UIImageView(image: UIImage(named: "background"))
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("PLAY", for: .normal)
        button.backgroundColor = .purple
        button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let aboutButton: UIButton = {
        let button = UIButton()
        button.setTitle("ABOUT", for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(aboutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [playButton, aboutButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
    }
    
    // MARK: - Private func
    
    @objc private func aboutButtonTapped() {
        showAboutViewController()
    }
    
    @objc private func playTapped() {
        
        guard let url = URL(string: "https://raw.githubusercontent.com/Dante1970/google-data/main/google-data.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(GoogleData.self, from: data)
                
                DispatchQueue.main.async {
                    if responseData.access {
                        self?.showWebView(urlString: responseData.link)
                    } else {
                        self?.showGameViewController()
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    private func showAboutViewController() {
        let aboutVC = AboutViewController()
        aboutVC.modalPresentationStyle = .fullScreen
        present(aboutVC, animated: true, completion: nil)
    }
    
    private func showWebView(urlString: String) {
        DispatchQueue.main.async {
            let webViewController = WebViewViewController(urlString: urlString)
            self.present(webViewController, animated: true)
        }
    }
    
    private func showGameViewController() {
        DispatchQueue.main.async {
            let gameVC = GameViewController()
            gameVC.modalPresentationStyle = .fullScreen
            self.present(gameVC, animated: true)
        }
    }
    
    private func makeUI() {
        view.insertSubview(backgroundImage, at: 0)
        view.addSubview(stackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            playButton.heightAnchor.constraint(equalToConstant: 60),
            aboutButton.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40)
        ])
    }
}
