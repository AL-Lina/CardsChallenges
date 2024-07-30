//
//  GameOverScene.swift
//  CardsChallenges
//
//  Created by Alina Sakovskaya on 19.07.24.
//

import UIKit
import SpriteKit
import AudioToolbox

class GameOverScene: SKScene {
    
    var labelForMovies: SKLabelNode!
    var labelForTime: SKLabelNode!
    
    var bgParallax: SKSpriteNode!
    var firstFrameForResults: SKSpriteNode!
    var container: SKSpriteNode!
    var youWinForResults: SKSpriteNode!
    var replayGameButton: SKSpriteNode!
    var menuButton: SKSpriteNode!
    
    var soundActionButton: SKAction!
    
    var text: String?
    var textForTime: String?
    
    
    override func didMove(to view: SKView) {
        setUpScreen()
        setUpScenery()
        setUpAudio()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name == "replay" {
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GamingScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: reveal)
            }
            
            if node.name == "menu" {
                run(soundActionButton)
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                let reveal: SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
    
    func setUpAudio() {
        soundActionButton = SKAction.playSoundFileNamed(soundButton, waitForCompletion: false)
    }
    
    func setUpScenery() {
        labelForMovies = SKLabelNode(fontNamed: fontName)
        labelForMovies.fontSize = 24
        labelForMovies.text = text ?? "GAME OVER"
        labelForMovies.fontColor = SKColor.white
        labelForMovies.position = CGPointMake(self.size.width / 2, self.size.height / 2 - 50)
        labelForMovies.zPosition = 20
        self.addChild(labelForMovies)
        
        labelForTime = SKLabelNode(fontNamed: fontName)
        labelForTime.fontSize = 24
        labelForTime.text = textForTime ?? "GAME OVER"
        labelForTime.fontColor = SKColor.white
        labelForTime.position = CGPointMake(self.size.width / 2, self.size.height / 2 - 75)
        labelForTime.zPosition = 20
        self.addChild(labelForTime)
    }
    
    func setUpScreen() {
        let background = SKSpriteNode(imageNamed: backgroundImage)
        background.anchorPoint = CGPointMake(0, 1)
        background.position = CGPointMake(0, size.height)
        background.zPosition = 0
        background.color = UIColor(white: 0.5, alpha: 0.5)
        background.size = CGSize(width: self.view!.bounds.size.width, height: self.view!.bounds.size.height)
        addChild(background)
        
        self.container = SKSpriteNode()
        self.container.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        self.container.size = CGSize(width: self.view!.bounds.size.width,
                                     height: self.view!.bounds.size.height)
        self.container.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        container.zPosition = 2
        addChild(container)
        
        bgParallax = SKSpriteNode(imageNamed: backgroundParallax)
        bgParallax.position = CGPointMake(size.width/2, size.height / 2)
        bgParallax.size = CGSize(width: size.width + 450, height: size.height + 80)
        bgParallax.zPosition = 2
        addChild(bgParallax)
        
        firstFrameForResults = SKSpriteNode(imageNamed: firstFrame)
        firstFrameForResults.position = CGPointMake(size.width / 2, size.height / 2 - 30)
        firstFrameForResults.size = CGSize(width: 330, height: 180)
        firstFrameForResults.zPosition = 10
        firstFrameForResults.name = "play"
        addChild(firstFrameForResults)
        
        youWinForResults = SKSpriteNode(imageNamed: youWinImage)
        youWinForResults.position = CGPointMake(size.width / 2, size.height / 2 + 100)
        youWinForResults.size = CGSize(width: 330, height: 300)
        youWinForResults.zPosition = 20
        youWinForResults.name = "play"
        addChild(youWinForResults)
        
        replayGameButton = SKSpriteNode(imageNamed: replayGame)
        replayGameButton.position = CGPointMake(self.size.width/2 - 30, self.size.height / 2 - 160)
        replayGameButton.size = CGSize(width: 50, height: 50)
        replayGameButton.zPosition = 20
        replayGameButton.name = "replay"
        addChild(replayGameButton)
        
        menuButton = SKSpriteNode(imageNamed: menuImage)
        menuButton.position = CGPointMake(self.size.width/2 + 30, self.size.height / 2 - 160)
        menuButton.size = CGSize(width: 50, height: 50)
        menuButton.zPosition = 20
        menuButton.name = "menu"
        addChild(menuButton)
    }
}


