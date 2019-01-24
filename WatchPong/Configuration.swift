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
    let defaults = UserDefaults.standard
    
    
    static let sharedConfig = Configuration()
    
    override init() {
        self.isVR = defaults.bool(forKey: "isVR")
        self.useWatch = defaults.bool(forKey: "useWatch")
        self.winningScore = defaults.integer(forKey: "winningScore")
        if winningScore == 0 {
            winningScore = 7
            defaults.set(winningScore, forKey: "winningScore")
        }
        self.seenTutorial = defaults.bool(forKey: "seenTutorial")
    }
    
    func updateConfig(_ isVR:Bool, useWatch:Bool, winningScore:Int) {
        
        self.isVR = isVR
        self.useWatch = useWatch
        self.winningScore = winningScore
        defaults.set(isVR, forKey: "isVR")
        defaults.set(useWatch, forKey: "useWatch")
        defaults.set(winningScore, forKey: "winningScore")
        
    }
    
    func seeTutorial() {
        
        seenTutorial = true
        defaults.set(seenTutorial, forKey: "seenTutorial")
    }

}
