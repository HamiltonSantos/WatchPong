//
//  AngleUtils.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/12/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import Foundation


func degreesToRadians(degrees: Float) -> Float {
    return (degrees * Float(M_PI)) / 180.0
}

func radiansToDegrees(radians: Float) -> Float {
    return (180.0/Float(M_PI)) * radians
}