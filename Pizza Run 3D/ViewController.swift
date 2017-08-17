// View Controller

import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {
    
    var scnView: SCNView!
    var gameScene: SCNScene!
    var streetNode: SCNNode!
    var playerNode: SCNNode!
    var cityNode: SCNNode!
    var grass1Node: SCNNode!
    var grass2Node: SCNNode!
    var autoScene: SCNScene!
    var auto1Node: SCNNode!
    
    var movePlayerUpAction: SCNAction!
    var movePlayerDownAction: SCNAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupNodes()
        setupActions()
        setupGesture()
    }
    
    func setupScene() {
        scnView = SCNView(frame: self.view.frame)
        self.view.addSubview(scnView)
        gameScene = SCNScene(named: "PizzaRun3D.scnassets/Scenes/gameScene.scn")
        scnView.scene = gameScene
//        scnView.showsStatistics = true
//        scnView.allowsCameraControl = true
    }
    
    func setupNodes() {
        streetNode = gameScene.rootNode.childNode(withName: "strada", recursively: true)!
        playerNode = gameScene.rootNode.childNode(withName: "personaggio", recursively: true)!
        cityNode = gameScene.rootNode.childNode(withName: "citta", recursively: true)!
        grass1Node = gameScene.rootNode.childNode(withName: "erba_1", recursively: true)!
        grass2Node = gameScene.rootNode.childNode(withName: "erba_2", recursively: true)!
        autoScene = SCNScene(named: "PizzaRun3D.scnassets/Scenes/auto_1.scn")
        auto1Node = autoScene.rootNode.childNode(withName: "Auto1", recursively: false)
    }
    
    func setupActions() {
        
        // Move City
        let moveCityAction = SCNAction.moveBy(x: -20, y: 0, z: 0, duration: 360)
        cityNode.runAction(moveCityAction)
        
        // Move Street1 and Street2
        let moveStreetAction = SCNAction.moveBy(x: -950, y: 0, z: 0, duration: 120)
        streetNode.runAction(moveStreetAction)
        
        // Move Player
        let inclineScouterLeftAction = SCNAction.rotateBy(x: -0.5, y: 0, z: 0, duration:0)
        let inclineScouterRightAction = SCNAction.rotateBy(x: 0.5, y: 0, z: 0, duration:0)
        let moveScouterUpAction = SCNAction.moveBy(x: 0, y: 0, z: -0.9, duration: 0.5)
        let moveScouterDownAction = SCNAction.moveBy(x: 0, y: 0, z: 0.9, duration: 0.5)
        
        movePlayerUpAction = SCNAction.sequence([inclineScouterLeftAction, moveScouterUpAction, inclineScouterRightAction])
        movePlayerDownAction = SCNAction.sequence([inclineScouterRightAction, moveScouterDownAction, inclineScouterLeftAction])
        
        // Move Grass1 and Grass2
        let moveGrass1Action = SCNAction.moveBy(x: -10, y: 0, z: 0, duration: 1)
        let moveGrass2Action = SCNAction.moveBy(x: -19.9, y: 0, z: 0, duration: 2)
        let reposeGrassAction = SCNAction.move(to: SCNVector3(x: 7, y: 0.159, z: 3.8), duration: 0)
        
        let grass1Action = SCNAction.sequence([moveGrass1Action, reposeGrassAction])
        let grass2Action = SCNAction.sequence([moveGrass2Action, reposeGrassAction])
      
        grass1Node.runAction(SCNAction.sequence([grass1Action, SCNAction.repeatForever(grass2Action)]))
        grass2Node.runAction(SCNAction.repeatForever(grass2Action))
        
        // Create Cars
        let createCarsAction = SCNAction.run(createCars(node:))
        gameScene.rootNode.runAction(SCNAction.repeatForever(SCNAction.sequence([createCarsAction, SCNAction.wait(duration: 4)])))
    }
    
    func setupGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleGesture(_:)))
        swipeUp.direction = .up
        scnView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleGesture(_:)))
        swipeDown.direction = .down
        scnView.addGestureRecognizer(swipeDown)
    }
    
    func handleGesture(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.up:
            if (playerNode.position.z >= 2.4) {
                playerNode.runAction(movePlayerUpAction)
            }
        case UISwipeGestureRecognizerDirection.down:
            if (playerNode.position.z <= 2.6) {
                playerNode.runAction(movePlayerDownAction)
            }
        default:
            break
        }

    }
    
    func createCars(node: SCNNode) {
        let carNode = auto1Node.clone()
        gameScene.rootNode.addChildNode(carNode)
        
        let positionArray: [Float] = [1.6, 2.4, 3.4]
        let indexArray = Int(arc4random() % 3)
        carNode.position = SCNVector3(x: 20, y: 0.035, z: positionArray[indexArray])
        
        let moveCarAction = SCNAction.moveBy(x: -40, y: 0, z: 0, duration: 3.5)
        let removeCarAction = SCNAction.removeFromParentNode()
        carNode.runAction(SCNAction.sequence([moveCarAction, removeCarAction]))
    }
}
