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
        
        guard let url = URL(string: "https://gist.githubusercontent.com/Dante1970/f6dd8bc4d6fb6c3c99b7d5dab3f17f73/raw/f672e5c9d263e61144b907bb3c20ae0517f9f697/google-data.json") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(GoogleData.self, from: data)
                
                DispatchQueue.main.async {
                    if responseData.access {
                        print(responseData.link)
                        self?.showWebView()
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
    
    private func showWebView() {
        print("func showWebView")
//        DispatchQueue.main.async {
//            let webViewController = WebViewController() // Замените на свой класс WebViewController
//            self.present(webViewController, animated: true)
//        }
    }
    
    private func showGameViewController() {
        DispatchQueue.main.async {
            let gameVC = GameViewController()
            self.present(gameVC, animated: true)
        }
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
