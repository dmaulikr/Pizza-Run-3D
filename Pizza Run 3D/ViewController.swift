
import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {
    
    var scnView: SCNView!
    var gameScene: SCNScene!
    var street1Node: SCNNode!
    var street2Node: SCNNode!
    var playerNode: SCNNode!
    var cityNode: SCNNode!
    var grass1Node: SCNNode!
    var grass2Node: SCNNode!
    var gallery1Node: SCNNode!
    var gallery2Node: SCNNode!
    
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
        scnView.showsStatistics = true
//        scnView.allowsCameraControl = true
    }
    
    func setupNodes() {
        street1Node = gameScene.rootNode.childNode(withName: "strada_1", recursively: true)!
        street2Node = gameScene.rootNode.childNode(withName: "strada_2", recursively: true)!
        playerNode = gameScene.rootNode.childNode(withName: "personaggio", recursively: true)!
        cityNode = gameScene.rootNode.childNode(withName: "citta", recursively: true)!
        grass1Node = gameScene.rootNode.childNode(withName: "erba_1", recursively: true)!
        grass2Node = gameScene.rootNode.childNode(withName: "erba_2", recursively: true)!
        gallery1Node = gameScene.rootNode.childNode(withName: "galleria_1", recursively: true)!
        gallery2Node = gameScene.rootNode.childNode(withName: "galleria_2", recursively: true)!
    }
    
    func setupActions() {
        
        // Move City
        let moveCityAction = SCNAction.moveBy(x: -20, y: 0, z: 0, duration: 360)
        cityNode.runAction(moveCityAction)
        
        // Move Street1 and Street2
        let moveStreet1Action = SCNAction.moveBy(x: -16, y: 0, z: 0, duration: 2)
        let moveStreet2Action = SCNAction.moveBy(x: -31.9, y: 0, z: 0, duration: 4)
        let reposeStreetAction = SCNAction.move(to: SCNVector3(x: 13.9, y: 0.147, z: 2.315), duration: 0)
        
        let street1Action = SCNAction.sequence([moveStreet1Action, reposeStreetAction])
        let street2Action = SCNAction.sequence([moveStreet2Action, reposeStreetAction])
        
        street1Node.runAction(SCNAction.sequence([street1Action, SCNAction.repeat(street2Action, count: 9)]))
        street2Node.runAction(SCNAction.repeat(street2Action, count: 10))
        
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
        
        // Move Gallery1 and Gallery2
//        let moveGallery1Action = SCNAction.moveBy(x: -100, y: 0, z: 0, duration: 8)
//        let moveGallery2Action = SCNAction.moveBy(x: -125, y: 0, z: 0, duration: 10)
//        let reposeGalleryAction = SCNAction.move(to: SCNVector3(x: 13.9, y: 0.147, z: 2.315), duration: 0)
//
//        let gallery1Action = SCNAction.sequence([moveGallery1Action, reposeGalleryAction])
//        let gallery2Action = SCNAction.sequence([moveGallery2Action, reposeGalleryAction])
//
//        gallery1Node.runAction(SCNAction.sequence([gallery1Action, SCNAction.repeat(gallery2Action, count: 4)]))
//        gallery2Node.runAction(SCNAction.repeat(gallery2Action, count: 5))

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
}
