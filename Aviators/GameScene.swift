//
//  GameScene.swift
//  Aviators
//
//  Created by Сергей Белоусов on 22.07.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    weak var gameSceneDelegate: GameSceneDelegate?
    
    private var isGameStarted = false
    
    private var speedGravity: Double = -0.2
    
    private let starshipCategory: UInt32 = 0x1 << 0
    private let asteroidCategory: UInt32 = 0x1 << 1
    private let bonusCategory: UInt32 = 0x1 << 2
    
    private var starship: Starship!
    
    private var scoreLabel: SKLabelNode!
    private var score = 0
    
    private var timerLabel: SKLabelNode!
    private var timer: Timer?
    private var secondsPassed: Int = 0
    
    // MARK: - didMove
    
    override func didMove(to view: SKView) {
        
        let spaceBackground = SKSpriteNode(imageNamed: "spaceBackground")
        spaceBackground.zPosition = 0
        addChild(spaceBackground)
        
        physicsWorld.contactDelegate = self
        
        self.size = CGSize(
            width: UIScreen.main.bounds.width * 2,
            height: UIScreen.main.bounds.height * 2)
        
        physicsWorld.gravity = CGVector(dx: speedGravity, dy: 0)

        setupStarship()
        
        // generation asteroid
        let asteroidCreate = SKAction.run {
            let asteroid = self.createAsteroid()
            self.addChild(asteroid)
        }
        let asteroidPerSecond: Double = 0.5
        let asteroidCreationDelay = SKAction.wait(forDuration: 1.0 / asteroidPerSecond, withRange: 0.5)
        let asteroidSequenceAction = SKAction.sequence([asteroidCreate, asteroidCreationDelay])
        let asteroidRunAction = SKAction.repeatForever(asteroidSequenceAction)
        
        run(asteroidRunAction)
        
        // generation bonus
        let bonusCreate = SKAction.run {
            let bonus = self.createBonus()
            self.addChild(bonus)
        }
        let bonusPerSecond: Double = 0.1
        let bonusCreationDelay = SKAction.wait(forDuration: 1.0 / bonusPerSecond, withRange: 0.5)
        let bonusSequenceAction = SKAction.sequence([bonusCreate, bonusCreationDelay])
        let bonusRunAction = SKAction.repeatForever(bonusSequenceAction)
        
        run(bonusRunAction)

        createScoreLabel()
        score = 0

        createTimer()
        startTimer()
    }
    
    // MARK: - Public func
    
    // actions for close button tupped
    func closeButtonTapped() {
        isPaused = !isPaused
    }
    
    // actions for up button
    func upButtonTouchDown() {
        starship.moveUp()
    }
    
    func upButtonTouchUpInside() {
        starship.stopMoving()
    }
    
    func upButtonTouchUpOutside() {
        starship.stopMoving()
    }
    
    // actions for down button
    func downButtonTouchDown() {
        starship.moveDown()
    }
    
    func downButtonTouchUpInside() {
        starship.stopMoving()
    }
    
    func downButtonTouchUpOutside() {
        starship.stopMoving()
    }
    
    // MARK: update
    
    override func update(_ currentTime: TimeInterval) {
        starship.updatePosition()
    }
    
    // MARK: - didSimulatePhysics
    
    override func didSimulatePhysics() {
        
        if isGameStarted {
            GameManager.shared.updateHighScoreIfNeeded(with: score)
            scoreLabel.text = "Score: \(score)"
        }
        
        GameManager.shared.updateHighScoreIfNeeded(with: score)
        
        enumerateChildNodes(withName: "asteroid") { asteroid, stop in
            let widthScreen = UIScreen.main.bounds.width + asteroid.frame.size.width
            if asteroid.position.x < -widthScreen {
                asteroid.removeFromParent()
                self.score += 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
        
        enumerateChildNodes(withName: "bonus") { bonus, stop in
            let widthScreen = UIScreen.main.bounds.width + bonus.frame.size.width
            if bonus.position.x < -widthScreen {
                bonus.removeFromParent()
            }
        }
    }
    
    // MARK: - Public func
    
    func resetTheGame() {
        enumerateChildNodes(withName: "asteroid") { node, _ in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "bonus") { node, _ in
            node.removeFromParent()
        }

        starship.removeFromParent()
        setupStarship()

        secondsPassed = 0
        updateTimerLabel()

        isPaused = false

        speedGravity = -0.2
        physicsWorld.gravity = CGVector(dx: speedGravity, dy: 0)
        updateGravityForNodes()
        
        isGameStarted = false
    }
    
    // MARK: - Private func
    
    private func createScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score \(score)")
        scoreLabel.zPosition = 1
        scoreLabel.position = CGPoint(
            x: frame.size.width / scoreLabel.frame.size.width,
            y: UIScreen.main.bounds.height - scoreLabel.frame.size.width)
        addChild(scoreLabel)
    }
    
    private func createTimer() {
        timerLabel = SKLabelNode(text: "Time: \(secondsPassed)")
        timerLabel.zPosition = 1
        timerLabel.position = CGPoint(
            x: -frame.size.width / 2 + timerLabel.frame.size.width + 60,
            y: UIScreen.main.bounds.height - timerLabel.frame.size.width)
        addChild(timerLabel)
    }
    
    private func startTimer() {
        let timeInterval: TimeInterval = 1.0
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        isGameStarted = true
    }
    
    @objc
    private func updateTimer() {
        secondsPassed += 1
        
        updateTimerLabel()
    }
    
    private func updateTimerLabel() {
        timerLabel.text = "Time: \(secondsPassed)"
        updateSpeedGravity()
    }
    
    private func updateSpeedGravity() {
        if secondsPassed % 20 == 0 {
            speedGravity -= 0.5
            physicsWorld.gravity = CGVector(dx: speedGravity, dy: 0)

            updateGravityForNodes()
        }
    }
    
    private func updateGravityForNodes() {
        enumerateChildNodes(withName: "asteroid") { asteroid, stop in
            asteroid.physicsBody?.velocity.dy = CGFloat(drand48() * 2 - 1) * CGFloat(self.speedGravity)
        }
        enumerateChildNodes(withName: "bonus") { bonus, stop in
            bonus.physicsBody?.velocity.dy = CGFloat(drand48() * 2 - 1) * CGFloat(self.speedGravity)
        }
    }
    
    private func setupStarship() {
        starship = Starship(imageNamed: "starship")
        starship.zPosition = 1
        starship.position.x = -UIScreen.main.bounds.width + (starship.size.width / 2) + 40
        
        starship.physicsBody = SKPhysicsBody(texture: starship.texture!, size: starship.size)
        starship.physicsBody?.isDynamic = false
        starship.physicsBody?.categoryBitMask = starshipCategory
        starship.physicsBody?.collisionBitMask = asteroidCategory | asteroidCategory
        starship.physicsBody?.contactTestBitMask = asteroidCategory

        addChild(starship)
    }
    
    private func createAsteroid() -> SKSpriteNode {
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        
        let screenHeight = UIScreen.main.bounds.height
        let asteroidHeight = asteroid.size.height
        let airplaneHeight = starship.size.height
        let minYPosition: CGFloat = -screenHeight + asteroidHeight + airplaneHeight
        let maxYPosition: CGFloat = screenHeight - asteroidHeight - airplaneHeight
        
        asteroid.zPosition = 1
        asteroid.position.y = CGFloat.random(in: minYPosition...maxYPosition)
        asteroid.position.x = frame.size.width + asteroid.size.width
        
        asteroid.physicsBody = SKPhysicsBody(texture: asteroid.texture!, size: asteroid.size)
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.collisionBitMask = starshipCategory
        asteroid.physicsBody?.contactTestBitMask = starshipCategory
        
        let asteroidSpeedY: CGFloat = 100
        asteroid.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 5
        asteroid.physicsBody?.velocity.dy = CGFloat(drand48() * 2 - 1) * asteroidSpeedY
        
        asteroid.name = "asteroid"
        
        return asteroid
    }
    
    private func createBonus() -> SKSpriteNode {
        let bonus = SKSpriteNode(imageNamed: "bonus")
        bonus.size = CGSize(width: 100, height: 100)
        
        let screenHeight = UIScreen.main.bounds.height
        let bonusHeight = bonus.size.height
        let airplaneHeight = starship.size.height
        let minYPosition: CGFloat = -screenHeight + bonusHeight + airplaneHeight
        let maxYPosition: CGFloat = screenHeight - bonusHeight - airplaneHeight
        bonus.position.y = CGFloat.random(in: minYPosition...maxYPosition)
        bonus.position.x = frame.size.width + bonus.size.width
        bonus.zPosition = 1
        
        bonus.physicsBody = SKPhysicsBody(texture: bonus.texture!, size: bonus.size)
        bonus.physicsBody?.categoryBitMask = bonusCategory
        bonus.physicsBody?.collisionBitMask = starshipCategory
        bonus.physicsBody?.contactTestBitMask = starshipCategory
        
        let asteroidSpeedY: CGFloat = 100
        bonus.physicsBody?.angularVelocity = CGFloat(drand48() * 2 - 1) * 5
        bonus.physicsBody?.velocity.dy = CGFloat(drand48() * 2 - 1) * asteroidSpeedY
        
        bonus.name = "bonus"
        
        return bonus
    }
}

// MARK: - Extension



// MARK: SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Contact airplane with asteroid
        if contact.bodyA.categoryBitMask == starshipCategory && contact.bodyB.categoryBitMask == asteroidCategory || contact.bodyB.categoryBitMask == starshipCategory && contact.bodyA.categoryBitMask == asteroidCategory {
            
            isPaused = true
            gameSceneDelegate?.gameOver(score: String(score))
            
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
            
        }
        
        // Contact airplane with bonus
        if contact.bodyA.categoryBitMask == starshipCategory && contact.bodyB.categoryBitMask == bonusCategory || contact.bodyB.categoryBitMask == starshipCategory && contact.bodyA.categoryBitMask == bonusCategory {
            self.score += 20
            self.scoreLabel.text = "Score: \(self.score)"
            
            let bonusNode: SKSpriteNode?
            if contact.bodyA.categoryBitMask == bonusCategory {
                bonusNode = contact.bodyA.node as? SKSpriteNode
            } else {
                bonusNode = contact.bodyB.node as? SKSpriteNode
            }

            // Remove the bonusNode from the scene
            if let nodeToRemove = bonusNode {
                nodeToRemove.removeFromParent()
            }
        }
    }
}

