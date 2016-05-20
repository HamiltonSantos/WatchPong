//
//  GameViewController.swift
//  TVPong
//
//  Created by Hamilton Carlos da Silva Santos on 5/20/16.
//  Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    @IBOutlet weak var sceneView: PongSceneView!
        
        let gameController = TVPongController()
        
//        var sessionController : PongWCSessionController?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            sceneView.scene!.paused = false
            gameController.viewControllerDelegate = self
            
        }
        
        
        @IBAction func leftPressed(sender: AnyObject) {
            gameController.processLeftAction()
        }
        
        @IBAction func rightPressed(sender: AnyObject) {
            gameController.processRightAction()
        }
        
        override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            PongScene.sharedInstance.sharedScene.paused = true
        }

}
