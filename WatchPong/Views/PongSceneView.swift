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
        self.pointOfView = scene!.rootNode.childNodeWithName(cameraName, recursively: true)

        self.antialiasingMode = .Multisampling4X

        self.delegate = TVPongSceneRendererDelegate.sharedInstance
        if isDelegate {
            self.playing = true
            self.delegate = TVPongSceneRendererDelegate.sharedInstance
        }else {
            self.delegate = nil
        }

    }


}
