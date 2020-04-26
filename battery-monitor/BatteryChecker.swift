//
//  BatteryChecker.swift
//  battery-monitor
//
//  Created by Hiromasa Ohno on 2020/04/23.
//  Copyright © 2020 SonicGarden. All rights reserved.
//

import Cocoa
import Foundation
import IOKit.ps

class BatteryChecker: NSObject {
    func run() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            let percentage = self.batteryPercentage()
            print("Battery: \(percentage) %")
        }
    }
      
    func batteryPercentage() -> Int {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        
        // Pull out a list of power sources
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
        
        // For each power source...
        for ps in sources {
            // Fetch the information for a given power source out of our snapshot
            let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as! [String: AnyObject]
            
            // Pull out the name and capacity
            if let _ = info[kIOPSNameKey] as? String,
                let capacity = info[kIOPSCurrentCapacityKey] as? Float,
                let max = info[kIOPSMaxCapacityKey] as? Float {
                return Int(capacity / max * 100)
            }
        }
        
        return -1
    }
}