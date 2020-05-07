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
    var prevValue: Int = -1
    var notified = false
    
    func run() {
        var threshold = UserDefaults.standard.integer(forKey: "threshold")
        if threshold == 0 {
            threshold = 50
        }
        Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { timer in
            let percentage = self.batteryPercentage()
            if( !self.notified && percentage > 0 && percentage < self.prevValue && percentage < threshold ) {
                self.notifyToWebhook(threshold: threshold)
                self.notified = true
            } else if (self.notified && percentage > 0 && percentage > self.prevValue && percentage > threshold) {
                // しきい値以上にバッテリーが戻ったら通知済フラグを戻す
                self.notified = false
            }
            self.prevValue = percentage
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
    
    func notifyToWebhook(threshold: Int) {
        if let url = UserDefaults.standard.string(forKey: "webhook"), let param = UserDefaults.standard.string(forKey: "webhookParam") {
            WebhookNotifier.notify(webhookUrl: url, param: param, threshold: threshold)
        }
    }
}
