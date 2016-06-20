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

    weak var viewControllerDelegate: UIViewController?

    let tableSound = SCNAudioSource(fileNamed: "art.scnassets/ball1.mp3")
    let racketSound = SCNAudioSource(fileNamed: "art.scnassets/paddle1.mp3")
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
            if (myPoints >= winningScore) {
                dispatch_async(dispatch_get_main_queue(), {
                    let vc = FinalizedGameViewController.instantiateViewController()
                    vc.userWinner = true
                    vc.score = "\(self.myPoints) - \(self.otherPoints)"
                    self.viewControllerDelegate?.navigationController?.pushViewController(vc, animated: true)
                })

            }
        }
    }
    var otherPoints = 0 {
        didSet {
            updatePointsText()
            if (otherPoints >= winningScore) {
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
    var lastSideContact: SCNNode?

    override init() {
        super.init()
        pongScene.sharedScene.physicsWorld.contactDelegate = self
//        tableSound!.load()
//        racketSound!.load()
//        clapSound!.load()
//        endGameSound!.load()
        resetGamePositions()
        updatePointsText()
    }
}


// Ball Force

extension PongController {

    func applyOtherBallForce() {
//        let force = SCNVector3Make(frandom2(6), frandom(4), frandom(4)) - pongScene.ball.presentationNode.position.normalized()
        let ballPosition = pongScene.ball.presentationNode.position
        let randomX = frandom(1) - 0.5
        let randomY = 0.6
        let zExtra = abs((ballPosition.z / 5.5))
        let randomZ =  zExtra + 0.8
//        print("random x \(randomX)") MUDEI ISTO
        applyBallFoce(SCNVector3Make(Float(randomX), Float(randomY), Float(randomZ)))
        self.myTurn = false
    }

    func applyBallFoce(vectorForce: SCNVector3) {
        resetVelocity(pongScene.ball)
        applyForce(pongScene.ball, force: vectorForce * force)
        myTurn = false
    }

    func applyForce(node: SCNNode, force: SCNVector3) {

//        print("Force: \(force)") MUDEI ISTO
//        print("Position: \(node.presentationNode.position)") MUDEI ISTO
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.applyForce(force, impulse: true)
        playRacketSound()
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
        lastSideContact = nil
        pongScene.ball.physicsBody!.clearAllForces()
        pongScene.ball.physicsBody!.affectedByGravity = false
        resetBall()
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
        let ballPosition = pongScene.ball.presentationNode.position

        let x = ballPosition.x

        if x == 0 {
            changeBallPosition(position)
        }

        let xForce = pongScene.centerPoint.position.normalized() - ballPosition.normalized()
        let zExtra = abs((ballPosition.z / 5.2)) * -1
        let zForce = zExtra + -0.25

        applyBallFoce(SCNVector3Make(xForce.x, 1, zForce))
    }

}

// Contact Delegate

extension PongController: SCNPhysicsContactDelegate {

    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        
//        print(NSThread.currentThread()) MUDEI ISTO

        let oldLastSide = lastSideContact
        if contact.nodeB == pongScene.mySide || contact.nodeB == pongScene.otherSide {
            lastSideContact = contact.nodeB
        } else if contact.nodeA == pongScene.mySide || contact.nodeA == pongScene.otherSide {
            lastSideContact = contact.nodeA
        }

        guard oldLastSide != lastSideContact else {

            if lastSideContact == pongScene.mySide {
                otherPoints += 1
                myTurn = false
            } else {
                myPoints += 1
                myTurn = true
            }
            playClapSound()
            resetGamePositions()

            return
        }

        if (contact.nodeA == pongScene.mySide || contact.nodeB == pongScene.mySide) {
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
//        print(contact)

        if contact.nodeB == pongScene.otherSide {
            delay(0.25) {
                self.applyOtherBallForce()
            }
        }
    }

}

// Points

extension PongController {
    func updatePointsText() {
        pongScene.textPoints.string = "\(myPoints) - \(otherPoints)"
        print(pongScene.textPoints.string) //MUDEI ISTO
    }
}