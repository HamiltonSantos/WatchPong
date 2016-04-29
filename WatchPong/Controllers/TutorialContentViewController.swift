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
    var tutoTitle = ""
    var tutoSubtitle = ""
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var handImageView: UIImageView!
    @IBOutlet weak var handCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handImageView.alpha = 0
        animateHand(1)
        handCenterConstraint.constant = 0
        contentImageView.image = UIImage(named: imageName)
        titleLabel.text = tutoTitle
        subtitleLabel.text = tutoSubtitle
        if index == 2 {
            handImageView.alpha = 1
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func animateHand(interval: NSTimeInterval) {
        UIView.animateWithDuration(1, animations: {
            self.handCenterConstraint.constant = self.view.frame.size.width/4
            self.view.layoutIfNeeded()
        }) { (finished) in
            UIView.animateWithDuration(1.0, animations: {
                self.handCenterConstraint.constant = -(self.view.frame.size.width/4)
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.animateHand(2)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
