//
//  MultiplayerViewController.swift
//  WatchPong
//
//  Created by BEPID on 20/06/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import GameController
import SceneKit

class MultiplayerViewController: UIViewController, ReactToMotionEvents {

    let gameControllerManager = GameControllerManager()

    let pongController = PongController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.motionDelegate = self
        pongController.pongScene.sharedScene.paused = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func motionUpdate(motion: GCMotion) -> Void {
//        print(motion.gravity)
//        print(motion.userAcceleration)

        let totalX = motion.gravity.x + motion.userAcceleration.x
        let totalY = motion.gravity.y + motion.userAcceleration.y
        let totalZ = motion.gravity.z + motion.userAcceleration.z

        let treshould: Double = 3
        if (totalX > treshould || totalX < -treshould) {
            print(" ---- ")
            print("x: \(totalX)")
            print("y: \(totalY)")
            print("z: \(totalZ)")
            print(" ---- ")
        }
        if totalX > 3 {
            pongController.processRightAction()
        } else if totalX < -3 {
            pongController.processLeftAction()
        }
    }

}
