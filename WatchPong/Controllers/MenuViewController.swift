//
//  MenuViewController.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/13/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class MenuViewController: TransparentBarViewController {
    
    var configuration = Configuration.sharedConfig

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if !configuration.seenTutorial {
//            performSegueWithIdentifier("tutorialSegue", sender: nil)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressStart(_ sender: AnyObject) {
    
        if configuration.isVR {
            
            performSegue(withIdentifier: "vrSegue", sender: self)
        
        } else {
            
            performSegue(withIdentifier: "noVRSegue", sender: self)
        }
        
    }

}
