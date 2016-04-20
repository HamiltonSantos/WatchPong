//
//  FinalizedGameViewController.swift
//  WatchPong
//
//  Created by BEPID on 19/04/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class FinalizedGameViewController: UIViewController,InstantiateViewController {

    typealias T = FinalizedGameViewController
    static var storyboardName = "Main"
    static var identifierName = "finalizedVC"

    var userWinner : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
