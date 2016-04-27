//
//  TutorialContentViewController.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/25/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {
    
    var index = 0
    var imageName = ""
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentImageView.image = UIImage(named: imageName)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
