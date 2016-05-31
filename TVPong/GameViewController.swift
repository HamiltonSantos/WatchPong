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
import GameController

class GameViewController: GCEventViewController {

    @IBOutlet weak var sceneView: PongSceneView!

    var controller  = GCController()
        
        let pongController = TVPongController()
        
//        var sessionController : PongWCSessionController?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            sceneView.scene!.paused = false
            pongController.viewControllerDelegate = self
            
        }
        
        
        @IBAction func leftPressed(sender: AnyObject) {
            pongController.processLeftAction()
        }
        
        @IBAction func rightPressed(sender: AnyObject) {
            pongController.processRightAction()
        }
        
        override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            PongScene.sharedInstance.sharedScene.paused = true
        }
    
    func controllerDidConnect(note : NSNotification) {
        
        GCController.controllers().forEach({ controller in
            
            print(controller)
            if controller.extendedGamepad == nil {
                self.controller = controller
                self.configController(controller)
            }
            
        })
    }
    
    func configController(controller : GCController){
        
        controller.controllerPausedHandler = { controller in
//            self.scene.paused = true
//            self.controllerUserInteractionEnabled = true
//            self.performSegueWithIdentifier("pause", sender: self)
        }
        
        let buttonHandler : GCMotionValueChangedHandler = {
            
            
            
            
            
            
            { (button, value, pressed) in
            print(button)
            print(value)
            print(pressed)
        }
        
        let dpadHandler : GCControllerDirectionPadValueChangedHandler = { dpad, x, y in
            print(dpad)
            print(x)
            print(y)
        }
        
        controller.microGamepad?.buttonA.valueChangedHandler = buttonHandler
        controller.microGamepad?.buttonX.valueChangedHandler = buttonHandler
        
        controller.extendedGamepad?.dpad.valueChangedHandler = dpadHandler
        controller.microGamepad?.dpad.valueChangedHandler = dpadHandler
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.controllerUserInteractionEnabled = false
    }
    
}