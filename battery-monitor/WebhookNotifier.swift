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
    static func test(webhookUrl: String, param: String) {
        sendRequest(webhookUrl: webhookUrl, param: param, body: "Test Request from 'battery-monitor'")
    }
    
    static func notify(webhookUrl: String, param: String, threshold: Int) {
        sendRequest(webhookUrl: webhookUrl, param: param, body: "Your Mac's battery has less than \(threshold)% remaining.")
    }
    
    private static func sendRequest(webhookUrl: String, param: String, body: String) {
        //  talk to registration end point
        let data = [param: body]
        Just.post(
            webhookUrl,
            json: data
        ) { r in
            if r.ok { /* success! */ }
        }
    }
}
