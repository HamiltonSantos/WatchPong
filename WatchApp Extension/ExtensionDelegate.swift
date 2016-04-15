//
//  ExtensionDelegate.swift
//  WatchApp Extension
//
//  Created by BEPID on 14/04/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import WatchKit
import CoreMotion
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    var mgr: CMMotionManager?
    var session: WCSession?

    var lastDate = NSDate()

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.

        // Init WCSession
        if WCSession.isSupported() {
            self.session = WCSession.defaultSession()
        }

        guard let session = session else {
            return

        }
        session.delegate = self
        session.activateSession()

        // Init CMMotionManager
        mgr = CMMotionManager()

        if mgr?.accelerometerAvailable == true {
            mgr?.accelerometerUpdateInterval = 1 / 30

            mgr?.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {
                (data, error) in

                guard let data = data else{
                    return
                }


                let force = data.getForce()

                let treshould = 1.0

                // Se meu ultimo lancamento + 1 segundos for maior q o tempo atual
                if force > 2.0 {
                    if NSDate().timeIntervalSince1970 > self.lastDate.dateByAddingTimeInterval(1).timeIntervalSince1970 {
                        print("novo")
                        self.lastDate = NSDate()


                        let sendMessage: (String) -> () = { side in
                            let dict = ["x" : data.acceleration.x,
                                        "y" : data.acceleration.y ,
                                        "z" : data.acceleration.z,
                                        "time" : NSDate().timeIntervalSince1970,
                                        "side" : side]

                            session.sendMessage(dict as! [String : AnyObject],
                                    replyHandler: { (reply) in
                                        print(reply)
                                    }, errorHandler: { (error) in
                                print(error)
                            })

                        }

                        if data.acceleration.x > treshould {
                            print("esquerda")
                            print(data)
                            sendMessage("left")

                        }else if data.acceleration.x < -treshould {
                            print("direita")
                            print(data)
                            sendMessage("right")
                        }
                    }
                }

            })
        } else {
            print("no accelerometer")
        }

    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}

extension ExtensionDelegate: WCSessionDelegate {
    // MARK: - Delegate
    @available(watchOS 2.2, *) func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
        print(activationState)
    }

    @available(watchOS 2.0, *) func sessionReachabilityDidChange(session: WCSession) {
        print(session)
    }
}
