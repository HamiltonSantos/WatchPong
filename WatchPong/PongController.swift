//
// Created by BEPID on 13/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import SceneKit

class PongController : NSObject{

    // Scene
    var pongScene = PongScene.sharedInstance
    // Foce
    let force = Float(5.0)
    
    // Contact
    var lastNodeContact : SCNNode?{
        didSet{
            if oldValue != nil && oldValue == lastNodeContact{
                resetBall()
                lastNodeContact = nil
            }
        }
    }
    
    override init() {
        super.init()
        pongScene.sharedScene.physicsWorld.contactDelegate = self
    }
}


// Ball Foce
extension PongController {
    func applyBallFoce(vectorForce: SCNVector3) {
        resetPhysics(pongScene.ball)
        applyForce(pongScene.ball,force: vectorForce * force)
    }

    func applyForce(node: SCNNode, force: SCNVector3) {
        node.physicsBody?.applyForce(force, impulse: true)
    }
}

// Resets
extension PongController{
    func resetPhysics(node: SCNNode) {
        node.physicsBody?.velocity = SCNVector3Zero
        node.physicsBody?.angularVelocity = SCNVector4Zero
    }

    func resetBall(){
        resetPhysics(pongScene.ball)
        pongScene.ball.position = pongScene.ballInitalPosition
    }
}

extension PongController : SCNPhysicsContactDelegate {

    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {

        if contact.nodeB == pongScene.mySide || contact.nodeB == pongScene.otherSide {
            lastNodeContact = contact.nodeB
        }else if contact.nodeA == pongScene.mySide || contact.nodeA == pongScene.otherSide {
            lastNodeContact = contact.nodeA
        }

    }


    func physicsWorld(world: SCNPhysicsWorld, didEndContact contact: SCNPhysicsContact) {
        print(contact)
        
        if contact.nodeB == pongScene.otherSide{
            applyBallFoce(SCNVector3Make(0,1,1))
        }
    }
    
}