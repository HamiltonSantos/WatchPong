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
        sceneView.scene!.paused = true
    }

}
