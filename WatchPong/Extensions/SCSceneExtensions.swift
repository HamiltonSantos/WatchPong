//
// Created by BEPID on 13/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import SceneKit

extension SCNScene {

    func childNode(name : String) -> SCNNode {
        return self.rootNode.childNodeWithName(name,recursively: true)!
    }
}