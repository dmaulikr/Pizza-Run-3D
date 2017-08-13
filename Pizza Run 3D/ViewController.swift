
import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {
    
    var scnView: SCNView!
    var gameScene: SCNScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
    }
    
    func setupScene() {
        scnView = SCNView(frame: self.view.frame)
        self.view.addSubview(scnView)
        gameScene = SCNScene(named: "PizzaRun3D.scnassets/Scenes/gameScene.scn")
        scnView.scene = gameScene
    }
    

}

