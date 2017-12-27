//
//  NoVRGameViewController.swift
//  WatchPong
//
//  Created by BEPID on 13/04/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import SceneKit

class NoVRGameViewController: TransparenetBarViewController {
    
    @IBOutlet weak var sceneView: PongSceneView!

    let gameController = PongController()

    var sessionController : PongWCSessionController?

    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var buttonRight: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene!.isPaused = false
        gameController.viewControllerDelegate = self

        if Configuration.sharedConfig.useWatch {
            buttonLeft.isEnabled = false
            buttonRight.isEnabled = false
            sessionController = PongWCSessionController(pongController: gameController)
        }
    }


    @IBAction func leftPressed(_ sender: AnyObject) {
        gameController.processLeftAction()
    }
    
    @IBAction func rightPressed(_ sender: AnyObject) {
        gameController.processRightAction()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PongScene.sharedInstance.sharedScene.isPaused = true
    }

}
