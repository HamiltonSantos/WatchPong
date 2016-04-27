//
//  TutorialContainerViewController.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/27/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class TutorialContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissTutorial(sender: AnyObject) {
        Configuration.sharedConfig.seeTutorial()
        dismissViewControllerAnimated(true, completion: nil)
    }

    

}
