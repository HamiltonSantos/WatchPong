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
    var points = [SCNNode]()

    // Utils
    let ballInitalPosition : SCNVector3

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

        // Contacts
        self.mySide.physicsBody!.contactTestBitMask = 1
        self.otherSide.physicsBody!.contactTestBitMask = 1

        // Utils
        self.ballInitalPosition = ball.position
    }
    

}