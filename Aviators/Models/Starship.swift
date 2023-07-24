//
//  Airplane.swift
//  Aviators
//
//  Created by Сергей Белоусов on 24.07.2023.
//

import UIKit
import SpriteKit

class Starship: SKSpriteNode {
    
    enum Starship {
        case up
        case down
    }
    
    private var starshipIsMoving = false
    private var starshipMove: Starship = .up
    private let starshipSpeed: CGFloat = 10
    
    func moveUp() {
        starshipIsMoving = true
        starshipMove = .up
    }
    
    func moveDown() {
        starshipIsMoving = true
        starshipMove = .down
    }
    
    func stopMoving() {
        starshipIsMoving = false
    }
    
    // Метод для обновления позиции самолета в зависимости от его движения
    func updatePosition() {
        guard let scene = scene else { return }
        
        let minHeight = -scene.frame.size.height / 2 + 300
        let maxHeight = scene.frame.size.height / 2 - 300
        
        if starshipIsMoving {
            switch starshipMove {
            case .up:
                if position.y + starshipSpeed < maxHeight {
                    position.y += starshipSpeed
                } else {
                    position.y = maxHeight
                }
            case .down:
                if position.y - starshipSpeed > minHeight {
                    position.y -= starshipSpeed
                } else {
                    position.y = minHeight
                }
            }
        }
    }
}
