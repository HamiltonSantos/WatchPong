//
// Created by BEPID on 13/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import UIKit

class TransparenetBarViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

}