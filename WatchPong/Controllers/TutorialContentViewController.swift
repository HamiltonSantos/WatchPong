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
    
    @IBOutlet weak var ballView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var handImageView: UIImageView!
    @IBOutlet weak var handCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ballVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var ballHorizontalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var ballSizeConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handImageView.alpha = 0
        ballView.alpha = 0
        animateLeft()
        handCenterConstraint.constant = 0
        contentImageView.image = UIImage(named: imageName)
        titleLabel.text = tutoTitle
        subtitleLabel.text = tutoSubtitle
        if index == 2 {
            handImageView.alpha = 1
            ballView.alpha = 1
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func animateLeft() {
        UIView.animateWithDuration(1, animations: {
            self.handCenterConstraint.constant = -(self.view.frame.size.width/4)
            self.ballSizeConstraint.constant = 10
            self.ballVerticalCenterConstraint.constant = self.view.frame.size.height/4
            self.ballHorizontalCenterConstraint.constant = self.handCenterConstraint.constant
            self.view.layoutIfNeeded()
        }) { (finished) in
            UIView.animateWithDuration(1, animations: {
                self.handCenterConstraint.constant = 0
                self.ballSizeConstraint.constant = 5
                self.ballVerticalCenterConstraint.constant = -(self.view.frame.size.height/4)
                self.ballHorizontalCenterConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.animateRight()
            }
        }
    }
    
    func animateRight() {
        UIView.animateWithDuration(1, animations: {
            self.handCenterConstraint.constant = self.view.frame.size.width/4
            self.ballSizeConstraint.constant = 10
            self.ballVerticalCenterConstraint.constant = self.view.frame.size.height/4
            self.ballHorizontalCenterConstraint.constant = self.handCenterConstraint.constant
            self.view.layoutIfNeeded()
        }) { (finished) in
            UIView.animateWithDuration(1, animations: {
                self.handCenterConstraint.constant = 0
                self.ballSizeConstraint.constant = 5
                self.ballVerticalCenterConstraint.constant = -(self.view.frame.size.height/4)
                self.ballHorizontalCenterConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.animateLeft()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
