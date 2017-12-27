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
    
    var lastDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameController.autoConnect = true
        gameController.startBrowsing()
        // Do any additional setup after loading the view.

        motionManager.accelerometerUpdateInterval = 1 / 60
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in

            let treashould : Double = 2
            let x = data?.acceleration.x ?? 0
            if x > treashould || x < -treashould{
                print(data)
                if Date().timeIntervalSince1970 > self.lastDate.addingTimeInterval(1).timeIntervalSince1970 {
                    if x > treashould {
                        self.lastDate = Date()
                        self.gameController.sendCommandToTV(CommandType.right)
                    }else if x < -treashould {
                        self.lastDate = Date()
                        self.gameController.sendCommandToTV(CommandType.left)
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


