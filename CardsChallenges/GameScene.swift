//
//  GameScene.swift
//  CardsChallenges
//
//  Created by Alina Sakovskaya on 16.07.24.
//

import SpriteKit
import GameplayKit
import CoreImage
import CoreImage.CIFilterBuiltins

class GameScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    var bgParallax: SKSpriteNode!
    var hatImg: SKSpriteNode!
    var playButton: SKSpriteNode!
    var privacyPolButton: SKSpriteNode!
    var touchednODE: SKSpriteNode!
    
    var soundActionButton: SKAction!
    
    override func didMove(to view: SKView) {
       
        setUpScenery()
        createMenu()
        setupAudio()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if playButton.contains(location) {
                print("play")
                sceneManagerDelegate?.presentGamingScene()
                setupAudio()
                run(soundActionButton)
            }
            
            if privacyPolButton.contains(location) {
                print("privacy")
                sceneManagerDelegate?.presentSafariController()
                setupAudio()
                run(soundActionButton)
            }
        }
    }
    
    
        
   
    func setUpScenery() {
        let background = SKSpriteNode(imageNamed: backgroundImage)
        background.anchorPoint = CGPointMake(0, 1)
        background.position = CGPointMake(0, size.height)
        background.zPosition = 0
        background.size = CGSize(width: self.view!.bounds.size.width, height: self.view!.bounds.size.height)
        addChild(background)
    }
    
    func setupAudio() {
        soundActionButton = SKAction.playSoundFileNamed(soundButton, waitForCompletion: false)
    }
    
    func createMenu() {
        bgParallax = SKSpriteNode(imageNamed: backgroundParallax)
        bgParallax.position = CGPointMake(size.width/2, size.height / 2)
        bgParallax.size = CGSize(width: size.width + 450, height: size.height + 80)
        bgParallax.zPosition = 2
        addChild(bgParallax)
        
        hatImg = SKSpriteNode(imageNamed: hatImage)
        hatImg.position = CGPointMake(size.width/2, size.height / 2 + 150)
        hatImg.size = CGSize(width: 350, height: 350)
        hatImg.zPosition = 10
        addChild(hatImg)
        
        playButton = SKSpriteNode(imageNamed: playNowButton)
        playButton.position = CGPointMake(size.width / 2, size.height / 2 - 50)
        playButton.size = CGSize(width: 250, height: 80)
        playButton.zPosition = 10
        playButton.name = "play"
        addChild(playButton)
        
        privacyPolButton = SKSpriteNode(imageNamed: privacyPoliceButton)
        privacyPolButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 150)
        privacyPolButton.size = CGSize(width: 250, height: 80)
        privacyPolButton.zPosition = 10
        privacyPolButton.name = "privacy"
        addChild(privacyPolButton)
    }
    
}
