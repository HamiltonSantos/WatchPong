//
//  GameViewController.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 3/30/16.
//  Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import UIKit
import WatchConnectivity

class VRGameViewController: TransparenetBarViewController {

    let gameController = PongController()

    var session: WCSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().idleTimerDisabled = true

        // Session
        if WCSession.isSupported() {
            self.session = WCSession.defaultSession()
        }

        guard let session = session else {
            return
        }
        session.delegate = self
        session.activateSession()

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

extension VRGameViewController: WCSessionDelegate {
    @available(iOS 9.0, *) func session(session: WCSession, didReceiveMessage message: [String:AnyObject], replyHandler: ([String:AnyObject]) -> Void) {
        print(message)

        guard let side = message["side"] as? String else {
            return
        }

        switch side{
        case "left":
            gameController.processLeftAction()
            break
        case "right":
            gameController.processRightAction()
            break
        default:break
        }


        replyHandler(["message":"foi"])

    }
}