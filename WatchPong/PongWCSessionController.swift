//
// Created by BEPID on 22/04/16.
// Copyright (c) 2016 Hamilton Santos. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity


class PongWCSessionController: NSObject {

    var session: WCSession?
    var noConnectionVC: UIViewController?
    var pongController : PongController

    init(pongController : PongController) {
        // Session
        self.pongController = pongController

        super.init()

        noConnectionVC = UIViewController.instantiate(viewIdentifier: "openWatchVC")

        if WCSession.isSupported() {
            self.session = WCSession.defaultSession()
        }

        guard let session = session else {
            return
        }
        session.delegate = self
        session.activateSession()
    }
}

extension PongWCSessionController: WCSessionDelegate {

    @available(iOS 9.0, *) func session(session: WCSession, didReceiveMessage message: [String:AnyObject]) {
        print(message)

        guard let side = message["side"] as? String else {
            return
        }

        switch side {
        case "left":
            pongController.processLeftAction()
            break
        case "right":
            pongController.processRightAction()
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


    func sessionIsActive() -> Bool {
        guard let session = session else {
            return false
        }

        guard session.activationState == .Activated && session.reachable == true else {
            return false
        }

        return true
    }

    func updateActive() {
        guard let vc = pongController.viewControllerDelegate else {
            return
        }
        if sessionIsActive() {
            if vc.presentedViewController == noConnectionVC {
                noConnectionVC!.dismissViewControllerAnimated(true, completion: nil)
            }

        } else {
            if vc.presentedViewController == nil {
                vc.presentViewController(noConnectionVC!, animated: true, completion: nil)
            }
        }
    }

}
