//
//  PongSceneView.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/12/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import SceneKit


class PongSceneView: SCNView {
    
    @IBInspectable var cameraName: String = "centerCamera"
    @IBInspectable var isDelegate : Bool = false
    
    override func awakeFromNib() {
        // create a new scene
        super.awakeFromNib()
        self.scene = PongScene.sharedInstance.sharedScene
        
        // retrieve the SCNView
        self.pointOfView = scene!.rootNode.childNode(withName: cameraName, recursively: true)
        
        if isDelegate {
            self.isPlaying = true
            self.antialiasingMode = .multisampling4X
            #if os(tvOS)
                self.delegate = TVPongSceneRendererDelegate.sharedInstance
            #else
                self.delegate = PongSceneRendererDelegate.sharedInstance
            #endif
        }else {
            self.delegate = nil
        }
        
    }
    
    
}
