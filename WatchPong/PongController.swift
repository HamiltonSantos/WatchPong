//
// Created by BEPID on 13/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import SceneKit

// Constants
let force = Float(5.5)
let defaultForceVector = SCNVector3Make(0, 1, -1)

class PongController: NSObject {
    
    weak var viewControllerDelegate : UIViewController?
    
    let tableSound = SCNAudioSource(fileNamed: "art.scnassets/ping.mp3")
    let racketSound = SCNAudioSource(fileNamed: "art.scnassets/pong.mp3")
    let endGameSound = SCNAudioSource(fileNamed: "art.scnassets/endGame.mp3")
    let clapSound = SCNAudioSource(fileNamed: "art.scnassets/clapping.mp3")
    let winningScore = Configuration.sharedConfig.winningScore

    // Scene
    var pongScene = PongScene.sharedInstance
    // Utils
    var myTurn = true
    var myPoints = 0 {
        didSet {
            updatePointsText()
            if (myPoints >= winningScore){
                dispatch_async(dispatch_get_main_queue(), { 
                    self.viewControllerDelegate?.performSegueWithIdentifier("endGame", sender: nil)
                })
                
            }
        }
    }
    var otherPoints = 0 {
        didSet {
            updatePointsText()
            if (otherPoints >= winningScore){
                dispatch_async(dispatch_get_main_queue(), {
                    let vc = FinalizedGameViewController.instantiateViewController()
                    vc.userWinner = false
                    vc.score = "\(self.myPoints) - \(self.otherPoints)"
                    self.viewControllerDelegate?.navigationController?.pushViewController(vc, animated: true)
                })
                
            }
        }
    }

    // Contact
    var lastSideContact: SCNNode? {
        didSet {
            if oldValue != nil && oldValue == lastSideContact {

                if lastSideContact == pongScene.mySide {
                    otherPoints += 1
                    myTurn = false
                } else {
                    myPoints += 1
                    myTurn = true
                }
                playClapSound()
                resetGamePositions()
            }
        }
    }

    override init() {
        super.init()
        pongScene.sharedScene.physicsWorld.contactDelegate = self
        tableSound?.load()
        racketSound?.load()
        clapSound?.load()
        endGameSound?.load()
        resetGamePositions()
        updatePointsText()
    }
}


// Ball Force

extension PongController {

    func applyOtherBallForce() {
        let force = pongScene.points.randomItem().position.normalized() - pongScene.ball.presentationNode.position.normalized()
        applyBallFoce(SCNVector3Make(force.x, 1, 1))
        playRacketSound()
    }

    func applyBallFoce(vectorForce: SCNVector3) {
        resetVelocity(pongScene.ball)
        applyForce(pongScene.ball, force: vectorForce * force)
        playRacketSound()
        myTurn = false
    }

    func applyForce(node: SCNNode, force: SCNVector3) {
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.applyForce(force, impulse: true)
    }
}

// Sounds

extension PongController {
    
    func playRacketSound() {
        pongScene.ball.runAction(.playAudioSource(racketSound!, waitForCompletion: false))
    }
    
    func playTableSound() {
        pongScene.ball.runAction(.playAudioSource(tableSound!, waitForCompletion: false))
    }
    
    func playClapSound() {
        pongScene.ball.runAction(.playAudioSource(clapSound!, waitForCompletion: false))
    }
    
}

// Resets

extension PongController {
    func resetVelocity(node: SCNNode) {
        node.physicsBody?.velocity = SCNVector3Zero
        node.physicsBody?.angularVelocity = SCNVector4Zero
    }

    func resetGamePositions() {
        resetBall()
        lastSideContact = nil
        pongScene.ball.physicsBody!.affectedByGravity = false
    }

    func resetBall() {
        resetVelocity(pongScene.ball)
        if (myTurn) {
            changeBallPosition(pongScene.mySideInitialCenterPosition)
        } else {
            changeBallPosition(pongScene.otherSideInitialCenterPosition)
            delay(1) {
                self.applyOtherBallForce()
            }
        }
    }

    func changeBallPosition(position: SCNVector3) {
        pongScene.ball.position = position
    }
}

// Process Actions

extension PongController {

    func processLeftAction(force: SCNVector3 = defaultForceVector) {
        let x = pongScene.ball.presentationNode.position.x
        guard x <= 0 && myTurn else {
            return
        }

        processAction(pongScene.mySideInitialLeftPosition, force: force)
    }

    func processRightAction(force: SCNVector3 = defaultForceVector) {
        let x = pongScene.ball.presentationNode.position.x
        guard x >= 0 && myTurn else {
            return
        }

        processAction(pongScene.mySideInitialRightPosition, force: force)
    }

    func processAction(position: SCNVector3, force: SCNVector3 = defaultForceVector) {
        let x = pongScene.ball.presentationNode.position.x

        if x == 0 {
            changeBallPosition(position)
        }

        let forceToApply = pongScene.centerPoint.position.normalized() - pongScene.ball.presentationNode.position.normalized()

        applyBallFoce(SCNVector3Make(forceToApply.x, 1, -1))
    }

}

// Contact Delegate

extension PongController: SCNPhysicsContactDelegate {

    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {

        if contact.nodeB == pongScene.mySide || contact.nodeB == pongScene.otherSide {
            lastSideContact = contact.nodeB
        } else if contact.nodeA == pongScene.mySide || contact.nodeA == pongScene.otherSide {
            lastSideContact = contact.nodeA
        }

        if (contact.nodeA == pongScene.mySide || contact.nodeB == pongScene.mySide){
            myTurn = true
        }

        if (contact.nodeB == pongScene.floor) {
            if lastSideContact == pongScene.mySide {
                otherPoints += 1
                myTurn = false
                resetGamePositions()
            } else {
                myPoints += 1
                myTurn = true
                resetGamePositions()
            }
            playClapSound()
        }
        playTableSound()

    }


    func physicsWorld(world: SCNPhysicsWorld, didEndContact contact: SCNPhysicsContact) {
        print(contact)

        if contact.nodeB == pongScene.otherSide {
            applyOtherBallForce()
            myTurn = false
        }
    }

}

// Points

extension PongController {
    func updatePointsText() {
        pongScene.textPoints.string = "\(myPoints) - \(otherPoints)"
    }
}