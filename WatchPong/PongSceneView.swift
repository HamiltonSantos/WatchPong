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
    
    var motionManager : CMMotionManager?
    var cameraNode : SCNNode?
    static let myScene = SCNScene(named: "art.scnassets/TableTennis.scn")!
    
    @IBInspectable var cameraName:String = "centerCamera"
    
    override func awakeFromNib() {
        // create a new scene
        
        cameraNode = PongSceneView.myScene.rootNode.childNodeWithName("cameraNode", recursively: false)!
        
        cameraNode!.eulerAngles.y = degreesToRadians(180.0)
        
        self.scene = PongSceneView.myScene
        
        
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

extension PongSceneView:SCNSceneRendererDelegate {
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval)
    {
        if let mm = motionManager, let motion = mm.deviceMotion {
            let currentAttitude = motion.attitude
            
            cameraNode!.eulerAngles.x = Float(currentAttitude.roll-90)
            cameraNode!.eulerAngles.z = Float(currentAttitude.pitch)
            cameraNode!.eulerAngles.y = Float(currentAttitude.yaw)
        }
    }
    
}
