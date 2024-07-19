//
//  GameViewController.swift
//  CardsChallenges
//
//  Created by Alina Sakovskaya on 16.07.24.
//

import UIKit
import SpriteKit
import GameplayKit
import SafariServices

protocol SceneManagerDelegate {
    func presentMenuScene()
    func presentGamingScene()
    func presentSafariController()
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentMenuScene()
    }
    
    func present(scene: SKScene, width scaleMode: SKSceneScaleMode) {
        if let view = self.view as! SKView? {
            scene.scaleMode = scaleMode
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
        }
    }
}

extension GameViewController: SceneManagerDelegate, SFSafariViewControllerDelegate {
    
    func presentMenuScene() {
        let menuScene = GameScene()
        menuScene.sceneManagerDelegate = self
        present(scene: menuScene, width: .resizeFill)
    }
    
    func presentGamingScene() {
        let gamingScene = GamingScene()
        gamingScene.sceneManagerDelegate = self
        present(scene: gamingScene, width: .resizeFill)
    }
    
    func presentSafariController() {
        let urlString = "https://www.google.com"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
}
