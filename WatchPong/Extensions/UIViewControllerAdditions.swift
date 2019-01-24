//
// Created by BEPID on 22/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{

    static func instantiate(_ storyboardName : String = "Main", viewIdentifier: String) -> UIViewController{
        let storyboard = UIStoryboard(name:storyboardName,bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewIdentifier)
        return vc
    }

}
