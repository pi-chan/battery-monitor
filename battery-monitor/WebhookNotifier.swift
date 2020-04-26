//
//  WebhookNotifier.swift
//  battery-monitor
//
//  Created by Hiromasa Ohno on 2020/04/26.
//  Copyright © 2020 SonicGarden. All rights reserved.
//

import Cocoa
import Just

class WebhookNotifier: NSObject {
    static func test(webhookUrl: String) {
        sendRequest(webhookUrl: webhookUrl, body: "Test Request from 'battery-monitor'")
    }
    
    static func notify(webhookUrl: String, threshold: Int) {
        sendRequest(webhookUrl: webhookUrl, body: "Your Mac's battery has less than \(threshold)% remaining.")
    }
    
    private static func sendRequest(webhookUrl: String, body: String) {
        //  talk to registration end point
        Just.post(
            webhookUrl,
            data: ["message": body]
        ) { r in
            if r.ok { /* success! */ }
        }
    }
}
