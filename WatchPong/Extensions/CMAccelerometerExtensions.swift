//
// Created by BEPID on 14/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import CoreMotion

extension CMAccelerometerData{
    func getForce() -> Double{
        var absolute: Double = 0

        absolute = absolute+abs(self.acceleration.x)
        absolute = absolute+abs(self.acceleration.y)
        absolute = absolute+abs(self.acceleration.z)

        return absolute
    }
}