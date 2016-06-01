//
//  TVGameViewController.swift
//  WatchPong
//
//  Created by Felipe Lukavei Ferreira on 5/31/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import GameController

class TVGameViewController: UIViewController, ReactToMotionEvents {

    let controllers = GCController.controllers()

    override func viewDidLoad() {
        super.viewDidLoad()

        for gamepad in controllers{
//            if let motion = gamepad.motion{
//                let motionHandler = GCMotionValueChangedHandler(motionBegan(.MotionShake, withEvent: )
//            }
            
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.motionDelegate = self
    }
    
    func motionUpdate(motion: GCMotion) {
        print("x: \(motion.userAcceleration.x)   y: \(motion.userAcceleration.y)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: CONTROLLER



}
