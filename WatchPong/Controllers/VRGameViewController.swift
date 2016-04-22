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

    @IBOutlet weak var sceneViewLeft: PongSceneView!
    @IBOutlet weak var sceneViewRight: PongSceneView!
    
    var session: WCSession?

    var vc : UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        vc = UIViewController.instantiate(viewIdentifier: "openWatchVC")
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

        sceneViewLeft.scene!.paused = false
        
        gameController.viewControllerDelegate = self

        updateActive()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        sceneViewLeft.scene!.paused = true
    }

}

extension VRGameViewController: WCSessionDelegate {

    @available(iOS 9.0, *) func session(session: WCSession, didReceiveMessage message: [String:AnyObject]) {
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
    }

    @available(iOS 9.3, *) func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
        updateActive()
        print(session)
    }

    @available(iOS 9.0, *) func sessionReachabilityDidChange(session: WCSession) {
        updateActive()
        print(session)
    }

    @available(iOS 9.0, *) func sessionWatchStateDidChange(session: WCSession) {
        updateActive()
        print(session)
    }


    func sessionIsActive() -> Bool{
        guard let session = session else {
            return false
        }

        guard session.activationState == .Activated && session.reachable == true else {
            return false
        }

        return true
    }

    func updateActive(){
        if sessionIsActive(){
            if self.presentedViewController == vc {
                vc!.dismissViewControllerAnimated(true,completion: nil)
            }

        }else {
            if self.presentedViewController == nil {
                self.presentViewController(vc!,animated: true,completion: nil)
            }
        }
    }

}

