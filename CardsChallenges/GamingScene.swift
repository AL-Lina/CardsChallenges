//
//  GamingScene.swift
//  CardsChallenges
//
//  Created by Alina Sakovskaya on 16.07.24.
//

import SpriteKit
import GameplayKit
import AudioToolbox

class GamingScene: SKScene {
    
    var sceneManagerDelegate: SceneManagerDelegate?
    
    let cardsPerRow: Int = 3
    let cardsPerColumn: Int = 4
    let cardsSizeX: CGFloat = 80
    let cardsSizeY: CGFloat = 80
    
    let scorePanel: CGFloat = 150
    
    var cards: [SKSpriteNode] = []
    var cardsBacks: [SKSpriteNode] = []
    var cardsStatus: [Bool] = []
    
    let numberOfTypesOfCards: Int = 8
    
    var cardSequence: [Int] = []
    
    var selectedCardIndex1: Int = -1
    var selectedCardIndex2: Int = -1
    var selectedCardValue: String = ""
    var selectedCard2Value: String = ""
    
    var gameIsPlaying: Bool = false
    var lockInteraction: Bool = false
    
    var scoreBoard: SKSpriteNode!
    var youWinImg: SKSpriteNode!
    var frameForResults: SKSpriteNode!
    var parallax: SKSpriteNode!
    var undoButton: SKSpriteNode!
    var leftButton: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    
    var tryCountCurrent: Int = 0
    var tryCountCurrentLabel: SKLabelNode!
    
    var soundActionButton: SKAction!
    var soundActionMatch: SKAction!
    var soundActionNoMatch: SKAction!
    var soundActionWin: SKAction!
    
    var counter: Int = 0
    var counterTimer = Timer()
    var countdownLabel: SKLabelNode!
    
    var counterMatches: Int = 0
    var bgParallax: SKSpriteNode!
    var darkenLayer: SKSpriteNode!
    
    var gameOverLabel: SKLabelNode!
    
    var pauseTapped = false
    
    override func didMove(to view: SKView) {
        setUpScenery()
        fillCardSequence()
        createCarBoard()
        createScoreBoard()
        setupAudio()
        startCounter()
        createButtons()
    }
    
    func startCounter() {
        counterTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
    }
    
    @objc func decrementCounter() {
        counter += 1
        
        let minutes = counter / 60
        let seconds = counter % 60
        
        var minutesText = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        var secondText = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        countdownLabel.text = "TIME: \(minutesText):\(secondText)"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let positionInScene: CGPoint = touch!.location(in: self)
        let touchedNode: SKSpriteNode = self.atPoint(positionInScene) as! SKSpriteNode
        
        self.processItemTouch(node: touchedNode)
        
        if touchedNode.name == "resetGame" {
            resetGame()
        }
        if touchedNode.name == "goBack" {
            let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = GameScene(size: self.view!.bounds.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: reveal)
        }
        
        if touchedNode.name == "pause" {
            pauseGame()
        }
    }
    
    func setUpScenery() {
        let background = SKSpriteNode(imageNamed: secondBackgroung)
        background.anchorPoint = CGPointMake(0, 1)
        background.position = CGPointMake(0, size.height)
        background.zPosition = 0
        background.size = CGSize(width: self.view!.bounds.size.width, height: self.view!.bounds.size.height)
        addChild(background)
    }
    
    func createCarBoard() {
        let totalEmptyScapeX: CGFloat = self.size.width - (CGFloat(cardsPerRow + 1)) * cardsSizeX
        let offsetX: CGFloat = totalEmptyScapeX / (CGFloat(cardsPerRow) + 2)
        
        let totalEmptySpaceY: CGFloat = self.size.height - scorePanel - (CGFloat(cardsPerColumn + 4)) * cardsSizeY
        let offsetY: CGFloat = totalEmptySpaceY / (CGFloat(cardsPerColumn) + 0.5)
        
        var idx: Int = 0
        for i in 0 ... cardsPerRow {
            for j in 0 ... cardsPerColumn {
                
                let cardIndex: Int = cardSequence[idx]
                idx += 1
                let cardName: String = String(format: "card-%i", cardIndex)
                let card: SKSpriteNode = SKSpriteNode(imageNamed: cardName)
                card.size = CGSize(width: cardsSizeX, height: cardsSizeY)
                card.anchorPoint = CGPoint(x: 0, y: 0)
                
                let posX: CGFloat = offsetX + CGFloat(i) * card.size.width + offsetX * CGFloat(i)
                let posY: CGFloat = offsetY + CGFloat(j) * card.size.height + offsetY * CGFloat(j) + 170
                card.position = CGPoint(x: posX, y: posY)
                card.zPosition = 9
                card.name = String(format: "%i", cardIndex)
                addChild(card)
                cards.append(card)
                
                let cardBack: SKSpriteNode = SKSpriteNode(imageNamed: "Slot")
                cardBack.size = CGSize(width: cardsSizeX, height: cardsSizeY)
                cardBack.anchorPoint = CGPoint(x: 0, y: 0)
                cardBack.zPosition = 10
                cardBack.position = CGPoint(x: posX, y: posY)
                cardBack.name = String(format: "%i", cardIndex)
                addChild(cardBack)
                cardsBacks.append(cardBack)
            }
        }
    }
    
    func shuffleArray<T>( array: inout Array<T>) -> Array<T> {
        var index = array.count - 1
        while index > 0 {
            let j = Int(arc4random_uniform(UInt32(index-1)))
            array.swapAt(index, j)
            index -= 1
        }
        return array
    }
    
    func fillCardSequence() {
        let totalCards :Int = (cardsPerRow + 1) * (cardsPerColumn + 1) / 2
        for i in 1 ... totalCards {
            cardSequence.append(i)
            cardSequence.append(i)
        }
        
        let newSequence = shuffleArray(array: &cardSequence)
        cardSequence.removeAll(keepingCapacity: false)
        cardSequence += newSequence
    }
    
    func setStatusCardFound(cardIndex :Int) {
        cardsStatus[cardIndex] = true
    }
    
    @objc func hideSelectedCards() {
        print("selectedCardIndex1 \(selectedCardIndex1)")
        print("selectedCardIndex2 \(selectedCardIndex2)")
        
        let card1: SKSpriteNode = cards[selectedCardIndex1] as SKSpriteNode
        let card2: SKSpriteNode = cards[selectedCardIndex2] as SKSpriteNode
        
        card1.run(SKAction.unhide())
        card2.run(SKAction.unhide())
        
        selectedCardIndex1 = -1
        selectedCardIndex2 = -1
        lockInteraction = false
    }
    
    @objc func resetSelectedCards() {
        let card1: SKSpriteNode = cardsBacks[selectedCardIndex1] as SKSpriteNode
        let card2: SKSpriteNode = cardsBacks[selectedCardIndex2] as SKSpriteNode
        
        card1.run(SKAction.unhide())
        card2.run(SKAction.unhide())
        
        selectedCardIndex1 = -1
        selectedCardIndex2 = -1
        lockInteraction = false
    }
    
    
    func createScoreBoard() {
        scoreBoard = SKSpriteNode(imageNamed: scoreBoardImage)
        scoreBoard.position = CGPointMake(size.width / 2, size.height / 2 + 270)
        scoreBoard.size = CGSize(width: self.view!.bounds.size.width, height: 50)
        scoreBoard.zPosition = 1
        scoreBoard.name = "scoreboard"
        addChild(scoreBoard)
        
        tryCountCurrentLabel = SKLabelNode(fontNamed: fontName)
        tryCountCurrentLabel.text = "MOVIES: \(tryCountCurrent)"
        tryCountCurrentLabel.fontSize = 20
        tryCountCurrentLabel.fontColor = SKColor.white
        tryCountCurrentLabel.zPosition = 11
        tryCountCurrentLabel.position = CGPointMake(scoreBoard.position.x - 100, scoreBoard.position.y - 5)
        addChild(tryCountCurrentLabel)
        
        countdownLabel = SKLabelNode(fontNamed: fontName)
        countdownLabel.text = "TIME: 00:00"
        countdownLabel.fontSize = 20
        countdownLabel.fontColor = SKColor.white
        countdownLabel.zPosition = 11
        countdownLabel.position = CGPointMake(scoreBoard.position.x + 100, scoreBoard.position.y - 5)
        addChild(countdownLabel)
    }
    
    func createButtons() {
        undoButton = SKSpriteNode(imageNamed: undoImage)
        undoButton.position = CGPointMake(size.width / 2 + 150, size.height / 2 - 300)
        undoButton.size = CGSize(width: 50, height: 50)
        undoButton.zPosition = 1
        undoButton.name = "resetGame"
        addChild(undoButton)
        
        leftButton = SKSpriteNode(imageNamed: leftImage)
        leftButton.position = CGPointMake(size.width / 2, size.height / 2 - 300)
        leftButton.size = CGSize(width: 50, height: 50)
        leftButton.zPosition = 1
        leftButton.name = "goBack"
        addChild(leftButton)
        
        pauseButton = SKSpriteNode(imageNamed: pauseImage)
        pauseButton.position = CGPointMake(size.width / 2 - 150, size.height / 2 - 300)
        pauseButton.size = CGSize(width: 50, height: 50)
        pauseButton.zPosition = 1
        pauseButton.name = "pause"
        addChild(pauseButton)
    }
    
    func pauseGame() {
        if pauseTapped == false {
            self.scene?.view?.isPaused = true
            counterTimer.invalidate()
            pauseTapped = true
        } else {
            self.scene?.view?.isPaused = false
            startCounter()
            pauseTapped = false
        }
    }
    
    func resetGame() {
        removeAllCards()
        fillCardSequence()
        createCarBoard()
        tryCountCurrent = 0
        tryCountCurrentLabel?.text = "MOVIES: \(tryCountCurrent)"
        counter = 0
    }
    
    func removeAllCards() {
        for card in cards {
            card.removeFromParent()
        }
        
        for card in cardsBacks {
            card.removeFromParent()
        }
        cards.removeAll(keepingCapacity: false)
        cardsBacks.removeAll(keepingCapacity: false)
        cardsStatus.removeAll(keepingCapacity: false)
        cardSequence.removeAll(keepingCapacity: false)
        
        selectedCardValue = ""
        selectedCard2Value = ""
        selectedCardIndex1 = -1
        selectedCardIndex2 = -1
    }
    
    func setupAudio() {
        soundActionButton = SKAction.playSoundFileNamed(soundButton, waitForCompletion: false)
        soundActionMatch = SKAction.playSoundFileNamed(matchButton, waitForCompletion: false)
        soundActionNoMatch = SKAction.playSoundFileNamed(noMatchSound, waitForCompletion: false)
        soundActionWin = SKAction.playSoundFileNamed(winButtonSound, waitForCompletion: false)
    }
    
    func goToGameOverScene(labelForMovies: SKLabelNode, labelForTime: SKLabelNode) {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let scene = GameOverScene(size: self.size)
        scene.text = labelForMovies.text
        scene.textForTime = labelForTime.text
        self.view?.presentScene(scene, transition: reveal)
    }
    
    
    func processItemTouch(node: SKSpriteNode) {
        if node.name != nil {
            print(node.name!)
            let num: Int? = Int.init(node.name!)
            if num != nil {
                if num! > 0 {
                    if lockInteraction == true {
                        return
                    } else {
                        print("the card with number \(num!) was touched")
                        var i: Int = 0
                        for cardBack in cardsBacks {
                            if cardBack == node {
                                run(soundActionButton)
                                let cardNode: SKSpriteNode = cards[i] as SKSpriteNode
                                if selectedCardIndex1 == -1 {
                                    selectedCardIndex1 = i
                                    selectedCardValue = cardNode.name!
                                    cardBack.run(SKAction.hide())
                                } else if selectedCardIndex2 == -1 {
                                    if i != selectedCardIndex1 {
                                        lockInteraction = true
                                        selectedCardIndex2 = i
                                        selectedCard2Value = cardNode.name!
                                        cardBack.run(SKAction.hide())
                                        if selectedCardValue == selectedCard2Value {
                                            print("we have a match")
                                            counterMatches += 1
                                            tryCountCurrent += 1
                                            tryCountCurrentLabel.text = "MOVIES: \(tryCountCurrent)"
                                            if counterMatches == 10 {
                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                                                run(soundActionWin)
                                                goToGameOverScene(labelForMovies: tryCountCurrentLabel, labelForTime: countdownLabel)
                                            }
                                            Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(hideSelectedCards), userInfo: nil, repeats: false)
                                            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                                            run(soundActionMatch)
                                        } else {
                                            print("no match")
                                            tryCountCurrent += 1
                                            tryCountCurrentLabel.text = "MOVIES: \(tryCountCurrent)"
                                            Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(resetSelectedCards), userInfo: nil, repeats: false)
                                            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                                            run(soundActionNoMatch)
                                        }
                                        
                                    }
                                }
                            }
                            i += 1
                        }
                    }
                    
                }
            }
        }
    }
}
