//
// Created by BEPID on 19/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import UIKit



protocol InstantiateViewController {

    associatedtype T

    static var storyboardName : String {get}
    static var identifierName : String {get}

    static func instantiateViewController() -> T
}

extension InstantiateViewController {

    static func instantiateViewController() -> T {
        let vc = UIViewController.instantiate(storyboardName, viewIdentifier: identifierName) as! T
        return vc
    }
    
}