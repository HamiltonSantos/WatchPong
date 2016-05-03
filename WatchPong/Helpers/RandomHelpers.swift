//
// Created by BEPID on 29/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation


func frandom(max: UInt32) -> Float {
    return Float(arc4random()) / Float(UINT32_MAX) + Float(arc4random_uniform(max))
}

func frandom2(max: UInt32) -> Float {
    return Float(arc4random()) / Float(UINT32_MAX) + Float(arc4random_uniform(max + max)) - Float(max)
}