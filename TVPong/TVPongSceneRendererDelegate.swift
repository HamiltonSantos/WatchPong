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
