//
//  GameOverViewControllerDelegate.swift
//  Aviators
//
//  Created by Сергей Белоусов on 25.07.2023.
//

import Foundation

protocol GameOverViewControllerDelegate: AnyObject {
    func restartGame()
    func exitGame()
}
