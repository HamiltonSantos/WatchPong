//
//  ConfigViewController.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/13/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {
    
    var config = Configuration.sharedConfig

    @IBOutlet weak var vrSwitch: UISwitch!
    @IBOutlet weak var watchSwitch: UISwitch!
    @IBOutlet weak var scoreTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        vrSwitch.on = config.isVR
        watchSwitch.on = config.useWatch
        scoreTextField.text = "\(config.winningScore)"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressDone(sender: AnyObject) {
        config.updateConfig(vrSwitch.on, useWatch: watchSwitch.on, winningScore: Int(scoreTextField.text!) ?? 10)
        navigationController?.popViewControllerAnimated(true)
    }
}
