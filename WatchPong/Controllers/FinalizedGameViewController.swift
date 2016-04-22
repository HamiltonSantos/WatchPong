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
    
    override func viewWillAppear(animated: Bool) {
        winnerLabel.text = userWinner ? "Você Venceu" : "Você Perdeu"
        scoreLabel.text = score
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTouchDone(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
