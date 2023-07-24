//
//  GameManager.swift
//  Aviators
//
//  Created by Сергей Белоусов on 25.07.2023.
//

import Foundation

class GameManager {
    static let shared = GameManager()
    
    private let highScoreKey = "HighScore"
    
    private init() {}
    
    func loadHighScore() -> Int {
        return UserDefaults.standard.integer(forKey: highScoreKey)
    }
    
    func saveHighScore(score: Int) {
        UserDefaults.standard.set(score, forKey: highScoreKey)
    }
    
    func updateHighScoreIfNeeded(with currentScore: Int) {
        let highScore = loadHighScore()
        
        if currentScore > highScore {
            saveHighScore(score: currentScore)
        }
    }
}

