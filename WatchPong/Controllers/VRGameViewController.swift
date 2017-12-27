//
//  GameViewController.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 3/30/16.
//  Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import WatchConnectivity

class VRGameViewController: TransparenetBarViewController {

    let gameController = PongController()

    @IBOutlet weak var sceneViewLeft: PongSceneView!
    @IBOutlet weak var sceneViewRight: PongSceneView!

    var sessionController : PongWCSessionController?

    override func viewDidLoad() {
        super.viewDidLoad()

        PongScene.sharedInstance.sharedScene.isPaused = false
        
        gameController.viewControllerDelegate = self

        sessionController = PongWCSessionController(pongController: gameController)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PongScene.sharedInstance.sharedScene.isPaused = true
    }
    
    @IBAction func letPressed(_ sender: AnyObject) {
        gameController.processLeftAction()
    }
    
    @IBAction func rightPressed(_ sender: AnyObject) {
        gameController.processRightAction()
    }

}
