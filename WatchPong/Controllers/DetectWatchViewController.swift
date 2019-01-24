//
//  DetectWatchViewController.swift
//  WatchPong
//
//  Created by BEPID on 28/04/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class DetectWatchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: AnyObject) {
        
        
        self.dismiss(animated: true) { 
            self.presentedViewController?.navigationController?.popToRootViewController(animated: true)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
