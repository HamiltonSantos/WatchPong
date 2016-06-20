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
    
    var lastDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()

        pongController.twoPlayers = true
        
        gameControllerManager.delegate = self
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
        
        if NSDate().timeIntervalSince1970 > self.lastDate.dateByAddingTimeInterval(1).timeIntervalSince1970 {
            if totalX > 3 {
                lastDate = NSDate()
                pongController.processLeftAction()
            } else if totalX < -3 {
                lastDate = NSDate()
                pongController.processRightAction()
            }
        }
    }

}

extension MultiplayerViewController : GameControllerManagerDelegate {
    
    func didReceiveData(fromPlayer player: Int, data: NSData){
        
    }
    
    func didReceiveCommand(fromPlayer player: Int, command: CommandType){
        switch command {
        case .Left:
            pongController.applyOtherBallForce()
            break
        case .Right:
            pongController.applyOtherBallForce()
            break
        default: break
        }
    }
    
    func playerDidConnect(player: Int){
        
    }
    
    func playerDidDisconnect(player: Int){
        
    }
}