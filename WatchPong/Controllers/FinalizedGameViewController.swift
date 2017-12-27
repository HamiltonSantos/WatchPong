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

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    
    var userWinner : Bool = false
    var score:String = "0 - 0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        winnerLabel.text = userWinner ? "You Win \\o/" : "You Lost :/"
        scoreLabel.text = score
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTouchDone(_ sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PongScene.sharedInstance.textPoints.string = "\(0) - \(0)"
    }

}
