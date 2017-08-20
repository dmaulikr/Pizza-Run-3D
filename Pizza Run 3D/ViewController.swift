// View Controller

import UIKit
import SceneKit
import SpriteKit
import AVFoundation

class ViewController: UIViewController {
    
    var scnView: SCNView!
    var gameScene: SCNScene!
    var streetNode: SCNNode!
    var playerNode: SCNNode!
    var cityNode: SCNNode!
    var autoScene: SCNScene!
    var auto1Node: SCNNode!
    var pizzaScena: SCNScene!
    var pizzaNode: SCNNode!
    var audioGame: AVAudioPlayer!
    
    var movePlayerUpAction: SCNAction!
    var movePlayerDownAction: SCNAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupNodes()
        setupActions()
        setupGesture()
        setupAudio()
    }
    
    func setupScene() {
        scnView = SCNView(frame: self.view.frame)
        self.view.addSubview(scnView)
        gameScene = SCNScene(named: "PizzaRun3D.scnassets/Scenes/gameScene.scn")
        scnView.scene = gameScene
        scnView.showsStatistics = true
        //        scnView.allowsCameraControl = true
    }
    
    func setupNodes() {
        streetNode = gameScene.rootNode.childNode(withName: "strada", recursively: true)!
        playerNode = gameScene.rootNode.childNode(withName: "personaggio", recursively: true)!
        cityNode = gameScene.rootNode.childNode(withName: "citta", recursively: true)!
        autoScene = SCNScene(named: "PizzaRun3D.scnassets/Scenes/auto_1.scn")
        auto1Node = autoScene.rootNode.childNode(withName: "Auto1", recursively: false)
        pizzaScena = SCNScene(named: "PizzaRun3D.scnassets/Scenes/pizza.scn")
        pizzaNode = pizzaScena.rootNode.childNode(withName: "Pizza", recursively: false)
        createCars(node: pizzaNode)
    }
    
    func setupActions() {
        
        // Move City
        let moveCityAction = SCNAction.moveBy(x: -20, y: 0, z: 0, duration: 360)
        cityNode.runAction(moveCityAction)
        
        // Move Street
        let moveStreetAction = SCNAction.moveBy(x: -950, y: 0, z: 0, duration: 120)
        streetNode.runAction(moveStreetAction)
        
        // Move Player
        let inclineScouterLeftAction = SCNAction.rotateBy(x: -0.5, y: 0, z: 0, duration:0)
        let inclineScouterRightAction = SCNAction.rotateBy(x: 0.5, y: 0, z: 0, duration:0)
        let moveScouterUpAction = SCNAction.moveBy(x: 0, y: 0, z: -0.9, duration: 0.5)
        let moveScouterDownAction = SCNAction.moveBy(x: 0, y: 0, z: 0.9, duration: 0.5)
        
        movePlayerUpAction = SCNAction.sequence([inclineScouterLeftAction, moveScouterUpAction, inclineScouterRightAction])
        movePlayerDownAction = SCNAction.sequence([inclineScouterRightAction, moveScouterDownAction, inclineScouterLeftAction])
        
        // Create Cars
//        let createCarsAction = SCNAction.run(createCars(node:))
//        gameScene.rootNode.runAction(SCNAction.repeatForever(SCNAction.sequence([createCarsAction, SCNAction.wait(duration: 2)])))
        
        // Create Pizza
        let createPizzaAction = SCNAction.run(createPizza(node:))
        gameScene.rootNode.runAction(SCNAction.repeatForever(SCNAction.sequence([createPizzaAction, SCNAction.wait(duration: 3)])))
    }
    
    func setupGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleGesture(_:)))
        swipeUp.direction = .up
        scnView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleGesture(_:)))
        swipeDown.direction = .down
        scnView.addGestureRecognizer(swipeDown)
    }
    
    func setupAudio() {
        let soundURL = Bundle.main.url(forResource: "PizzaRun3D.scnassets/Sounds/musicGame", withExtension: "mp3")
        
        do {
            audioGame = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch  {
            print(error)
        }
        
        audioGame.play()
        
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
        
        let moveCarAction = SCNAction.moveBy(x: -40, y: 0, z: 0, duration: 7)
        let removeCarAction = SCNAction.removeFromParentNode()
        carNode.runAction(SCNAction.sequence([moveCarAction, removeCarAction]))
    }
    
    func createPizza(node: SCNNode) {
        let pizza = pizzaNode.clone()
        gameScene.rootNode.addChildNode(pizza)
        
        let positionArray: [Float] = [3.4, 1.5, 1.8]
        let indexArray = Int(arc4random() % 3)
        pizza.position = SCNVector3(x: 20, y: 0.28, z: positionArray[indexArray])
        
        let movePizzaAction = SCNAction.moveBy(x: -40, y: 0, z: 0, duration: 6)
        let removePizzaAction = SCNAction.removeFromParentNode()
        pizza.runAction(SCNAction.sequence([movePizzaAction, removePizzaAction]))
    }
}
