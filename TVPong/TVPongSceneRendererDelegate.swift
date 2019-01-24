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
