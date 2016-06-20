//
//  MultiplayerViewController.swift
//  WatchPong
//
//  Created by BEPID on 20/06/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import CoreMotion

class MultiplayerViewController: UIViewController {

    let gameController = GameController()
    let pongController = PongController()

    var motionManager = CMMotionManager()
    
    var lastDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameController.autoConnect = true
        gameController.startBrowsing()
        // Do any additional setup after loading the view.

        motionManager.accelerometerUpdateInterval = 1 / 60
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, error) in

            let treashould : Double = 2
            let x = data?.acceleration.x ?? 0
            if x > treashould || x < -treashould{
                print(data)
                if NSDate().timeIntervalSince1970 > self.lastDate.dateByAddingTimeInterval(1).timeIntervalSince1970 {
                    if x > treashould {
                        self.lastDate = NSDate()
                        self.gameController.sendCommandToTV(CommandType.Right)
                    }else if x < -treashould {
                        self.lastDate = NSDate()
                        self.gameController.sendCommandToTV(CommandType.Left)
                    }
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


