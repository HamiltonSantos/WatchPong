//
//  GameViewController.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 3/30/16.
//  Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion

class VRGameViewController: UIViewController, SCNSceneRendererDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}


