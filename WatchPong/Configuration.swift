//
//  Configuration.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/13/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class Configuration: NSObject {
    
    var isVR: Bool
    var winningScore: Int
    var useWatch: Bool
    var seenTutorial = false
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    static let sharedConfig = Configuration()
    
    override init() {
        self.isVR = defaults.boolForKey("isVR")
        self.useWatch = defaults.boolForKey("useWatch")
        self.winningScore = defaults.integerForKey("winningScore")
        self.seenTutorial = defaults.boolForKey("seenTutorial")
    }
    
    func updateConfig(isVR:Bool, useWatch:Bool, winningScore:Int) {
        
        self.isVR = isVR
        self.useWatch = useWatch
        self.winningScore = winningScore
        defaults.setBool(isVR, forKey: "isVR")
        defaults.setBool(useWatch, forKey: "useWatch")
        defaults.setInteger(winningScore, forKey: "winningScore")
        
    }
    
    func seeTutorial() {
        
        seenTutorial = true
        defaults.setBool(seenTutorial, forKey: "seenTutorial")
    }

}
