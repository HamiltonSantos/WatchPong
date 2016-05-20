//
//  TVPongSceneRendererDelegate.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 5/20/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import GameController
import SceneKit

class TVPongSceneRendererDelegate: NSObject, SCNSceneRendererDelegate {
    
    var motionManager: GCMotion
    let pongScene = PongScene.sharedInstance
    static let sharedInstance = TVPongSceneRendererDelegate()
    
    override init() {
        motionManager = GCMotion()
        super.init()
        initCamera()
    }
    
    func initCamera() {
        // Respond to user head movement
        
//        motionManager.deviceMotionUpdateInterval = 1.0 / 60
//        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical)
//        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
//            (motion: CMDeviceMotion?, error) in
//            
//            if let motion = motion {
//                let currentAttitude = motion.attitude
//                let cameraNode = self.pongScene.cameraNode
//                SCNTransaction.begin()
//                SCNTransaction.setAnimationDuration(0.05)
//
//                cameraNode!.eulerAngles.x = Float(currentAttitude.roll - 90)
//                cameraNode!.eulerAngles.z = Float(currentAttitude.pitch)
//                cameraNode!.eulerAngles.y = Float(currentAttitude.yaw)
//                
//                SCNTransaction.commit()
//            }
//        
//        }
    }
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        let racket = pongScene.racket
        let ball = pongScene.ball
        
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0)
        
        racket.position.x = ball.presentationNode.position.x
        
        
        if (ball.presentationNode.position.z < 0) {
            let newPositionZ = -6 - ball.presentationNode.position.z
            if newPositionZ < ball.presentationNode.position.z {
                racket.position.z = newPositionZ
            }else{
                racket.position.z = ball.presentationNode.position.z
            }
        }
        
        if ball.presentationNode.position.y > 3{
            
        }
        
        
        
        racket.rotation.z = ball.presentationNode.position.x * 45
        SCNTransaction.commit()
    }

}
