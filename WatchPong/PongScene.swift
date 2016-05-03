//
// Created by BEPID on 13/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import SceneKit

class PongScene : NSObject {
    
    static let sharedInstance = PongScene()
    
    let sharedScene = SCNScene(named: "art.scnassets/TableTennis.scn")!

    // Nodes
    let ball: SCNNode
    let mySide: SCNNode
    let otherSide: SCNNode
    let centerPoint: SCNNode
    let floor : SCNNode
    var points = [SCNNode]()
    let textPoints : SCNText
    let racket : SCNNode

    // Camera Node
    var cameraNode: SCNNode?

    // Initial Posiitons
    let mySideInitialLeftPosition : SCNVector3
    let mySideInitialRightPosition : SCNVector3
    let mySideInitialCenterPosition : SCNVector3

    let otherSideInitialLeftPosition : SCNVector3
    let otherSideInitialRightPosition : SCNVector3
    let otherSideInitialCenterPosition : SCNVector3

    override init() {
        // ball
        self.ball = sharedScene.childNode("ball")
        // table cides
        self.mySide = sharedScene.childNode("mySide")
        self.otherSide = sharedScene.childNode("otherSide")
        // center points
        self.centerPoint = sharedScene.childNode("centerPoint")
        // mySide points
        self.points.append(sharedScene.childNode("point1"))
        self.points.append(sharedScene.childNode("point2"))
        // floor
        self.floor = sharedScene.childNode("floor")
        // textPoints
        self.textPoints = sharedScene.childNode("textPoints").geometry as! SCNText

        // Contacts
        self.mySide.physicsBody!.contactTestBitMask = 1
        self.otherSide.physicsBody!.contactTestBitMask = 1
        self.floor.physicsBody!.contactTestBitMask = 1

        // racket
        let racketScene = SCNScene(named: "art.scnassets/racket.scn")
        self.racket = racketScene!.childNode("Raquete")
        sharedScene.rootNode.addChildNode(racket)
        self.racket.position = SCNVector3Make(0,5,-6)
        self.racket.rotation = SCNVector4Make(90,0,0,1)
//        self.racket.physicsBody = SCNPhysicsBody(type: .Kinematic,shape: SCNPhysicsShape(node: self.racket, options: nil))
//        self.racket.physicsBody!.affectedByGravity = false
//        self.racket.physicsBody!.contactTestBitMask = 1

        // camera
        cameraNode = sharedScene.childNode("cameraNode")

        // Initial Positions
        self.mySideInitialLeftPosition = sharedScene.childNode("mySideStartPointLeft").position
        self.mySideInitialRightPosition = sharedScene.childNode("mySideStartPointRight").position
        self.mySideInitialCenterPosition = sharedScene.childNode("mySideStartPointCenter").position

        self.otherSideInitialLeftPosition = sharedScene.childNode("otherSideStartPointLeft").position
        self.otherSideInitialRightPosition = sharedScene.childNode("otherSideStartPointRight").position
        self.otherSideInitialCenterPosition = sharedScene.childNode("otherSideStartPointCenter").position
        sharedScene.background.contents = UIImage(named: "sky")
        
    }
    

}