//
//  PongSceneView.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/12/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import SceneKit
import CoreMotion

class PongSceneView: SCNView {

    var motionManager: CMMotionManager?
    var cameraNode: SCNNode?

    @IBInspectable var cameraName: String = "centerCamera"

    override func awakeFromNib() {
        // create a new scene
        self.scene = PongScene.sharedInstance.sharedScene

        cameraNode = scene!.rootNode.childNodeWithName("cameraNode", recursively: false)!

        // retrieve the SCNView
        self.pointOfView = scene!.rootNode.childNodeWithName(cameraName, recursively: true)

        // Respond to user head movement
        motionManager = CMMotionManager()
        motionManager?.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager?.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical)

        self.delegate = self
        self.antialiasingMode = .Multisampling4X

        self.playing = true
    }


}

extension PongSceneView: SCNSceneRendererDelegate {

    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        if let mm = motionManager, let motion = mm.deviceMotion {
            let currentAttitude = motion.attitude

            cameraNode!.eulerAngles.x = Float(currentAttitude.roll - 90)
            cameraNode!.eulerAngles.z = Float(currentAttitude.pitch)
            cameraNode!.eulerAngles.y = Float(currentAttitude.yaw)

            let ball = PongScene.sharedInstance.ball
            let racket = PongScene.sharedInstance.racket

            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0)
            if ball.presentationNode.position.x >= 0 {
                racket.position.x = ball.presentationNode.position.x
            }else{
                racket.position.x = ball.presentationNode.position.x
            }

            if (ball.presentationNode.position.z < -3) {
                racket.position.z = ball.presentationNode.position.z
                racket.position.y = ball.presentationNode.position.y
            }else {
                if (ball.presentationNode.position.z < 0) {
                    racket.position.z = -6 - ball.presentationNode.position.z
                }

//                racket.position.y = 5
            }

            racket.rotation.z = ball.presentationNode.position.x * 45
            SCNTransaction.commit()
        }
    }

}
