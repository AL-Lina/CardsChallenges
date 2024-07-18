//
//  GameOverScene.swift
//  CardsChallenges
//
//  Created by Alina Sakovskaya on 19.07.24.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var labelForMovies: SKLabelNode!
    var labelForTime: SKLabelNode!
    var labelForYouWin: SKLabelNode!
    
    var text: String?
    var textForTime: String?
    
    var sceneManagerDelegate: SceneManagerDelegate?
  
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        setUpScenery()
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
        }
    }
    
    func setUpScenery() {
        let message = "YOU WIN!!!"
        labelForYouWin = SKLabelNode(fontNamed: fontName)
        labelForYouWin.fontSize = 50
        labelForYouWin.text = message
          labelForYouWin.fontColor = SKColor.black
        labelForYouWin.position = CGPointMake(self.size.width/2, self.size.height/2 + 50)
        self.addChild(labelForYouWin)
        
        labelForMovies = SKLabelNode(fontNamed: fontName)
        labelForMovies.fontSize = 40
        labelForMovies.text = text ?? "GAME OVER"
          labelForMovies.fontColor = SKColor.black
        labelForMovies.position = CGPointMake(self.size.width/2, self.size.height/2)
        self.addChild(labelForMovies)
        
        let timeLabel = "Time"
        labelForTime = SKLabelNode(fontNamed: fontName)
        labelForTime.fontSize = 40
        labelForTime.text = textForTime ?? "GAME OVER"
          labelForTime.fontColor = SKColor.black
        labelForTime.position = CGPointMake(self.size.width/2, self.size.height/2 - 50)
        self.addChild(labelForTime)
        
        let replayMessage = "Replay Game"
        var replayButton = SKLabelNode(fontNamed: fontName)
        replayButton.text = replayMessage
          replayButton.fontColor = SKColor.black
        replayButton.position = CGPointMake(self.size.width/2, self.size.height / 2 - 200)
        replayButton.name = "replay"
        self.addChild(replayButton)
    }
}


