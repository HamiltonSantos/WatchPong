//
// Created by BEPID on 29/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit
import SceneKit

class PongSceneRendererDelegate: NSObject, SCNSceneRendererDelegate {

    var motionManager: CMMotionManager
    let pongScene = PongScene.sharedInstance
    static let sharedInstance = PongSceneRendererDelegate()

    override init() {
        motionManager = CMMotionManager()
        super.init()
        initCamera()
    }

    func initCamera() {
        // Respond to user head movement

        motionManager.deviceMotionUpdateInterval = 1.0 / 30
        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryZVertical)
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) {
            (motion: CMDeviceMotion?, error) in

            if let motion = motion {
                let currentAttitude = motion.attitude
                let cameraNode = self.pongScene.cameraNode
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.05

                cameraNode!.eulerAngles.x = Float(currentAttitude.roll - 90)
                cameraNode!.eulerAngles.z = Float(currentAttitude.pitch)
                cameraNode!.eulerAngles.y = Float(currentAttitude.yaw)

                SCNTransaction.commit()
            }

        }
    }

    func renderer(_ aRenderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let racket = pongScene.racket
        let ball = pongScene.ball

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0

        racket.position.x = ball.presentation.position.x


        if (ball.presentation.position.z < 0) {
            let newPositionZ = -6 - ball.presentation.position.z
            if newPositionZ < ball.presentation.position.z {
                racket.position.z = newPositionZ
            }else{
                racket.position.z = ball.presentation.position.z
            }
        }

        if ball.presentation.position.y > 3{
            
        }



        racket.rotation.z = ball.presentation.position.x * 45
        SCNTransaction.commit()
    }

}
