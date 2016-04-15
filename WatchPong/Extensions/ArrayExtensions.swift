//
// Created by BEPID on 12/04/16.
// Copyright (c) 2016 BEPID. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}