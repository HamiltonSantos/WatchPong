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

let treshould = Double(3)

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    var mgr: CMMotionManager?
    var session: WCSession?

    var lastDate = Date()

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.

        // Init WCSession
        if WCSession.isSupported() {
            self.session = WCSession.default
        }

        guard let session = session else {
            return

        }
        session.delegate = self
        session.activate()

        // Init CMMotionManager
        mgr = CMMotionManager()

        if mgr?.isAccelerometerAvailable == true {
            mgr?.accelerometerUpdateInterval = 1 / 30

            mgr?.startAccelerometerUpdates(to: OperationQueue.main, withHandler: {
                (data, error) in

                guard let data = data else{
                    return
                }


//                let force = data.getForce()

                // Se meu ultimo lancamento + 1 segundos for maior q o tempo atual
                if self.isValidMoviment(data) {
                    
                    if Date().timeIntervalSince1970 > self.lastDate.addingTimeInterval(1).timeIntervalSince1970 {
                        print("novo")
                        let sendMessage: (String) -> () = { side in
                            let dict = ["x" : data.acceleration.x,
                                        "y" : data.acceleration.y ,
                                        "z" : data.acceleration.z,
                                        "time" : Date().timeIntervalSince1970,
                                        "side" : side] as [String : Any]

                            session.sendMessage(dict as [String : AnyObject],
                                    replyHandler:nil, errorHandler: { (error) in
                                print(error)
                            })

                        }

                        if data.acceleration.y > treshould {
                            print("esquerda")
                            print(data)
                            sendMessage("left")
                            self.lastDate = Date()

                        }else if data.acceleration.x < -treshould {
                            print("direita")
                            print(data)
                            sendMessage("right")
                            self.lastDate = Date()
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

    func isValidMoviment(_ data : CMAccelerometerData) -> Bool{

        if data.acceleration.x < -treshould || data.acceleration.y > treshould{
            return true
        }
        
        return false
    }

}

extension ExtensionDelegate: WCSessionDelegate {
    // MARK: - Delegate
    @available(watchOS 2.2, *) func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(activationState)
    }

    @available(watchOS 2.0, *) func sessionReachabilityDidChange(_ session: WCSession) {
        print(session)
    }
}

