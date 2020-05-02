//
//  ContentView.swift
//  battery-monitor
//
//  Created by Hiromasa Ohno on 2020/04/23.
//  Copyright © 2020 SonicGarden. All rights reserved.
//

import SwiftUI
import LaunchAtLogin

struct ContentView: View {
    @State private var webhook = ""
    @State private var webhookParam = "payload"
    @State private var threshold = 50.0
    @State private var launchAtLogin = false
    
    var popover: NSPopover?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Toggle(isOn: $launchAtLogin) {
                    Text("Launch At Login")
                        .padding(.bottom)
                }
            }
            
            HStack(alignment: .center) {
                Text("Webhook Parameter")
                TextField("Webhook Parameter", text: $webhookParam)
                Button(action: {
                    WebhookNotifier.test(webhookUrl: self.webhook, param: self.webhookParam)
                }){
                    Text("Test Webhook")
                }
            }

            HStack(alignment: .center) {
                Text("Webhook URL")
                TextField("Webhook URL", text: $webhook)
            }
            
            HStack(alignment: .center) {
                Text("Notify when battery is less than \(thresholdAsInt) %")
                Slider(value: $threshold, in: 10...80)
            }
            
            HStack(alignment: .center) {
                Button(action: {
                    self.initValues()
                    self.popover?.performClose(self)
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    UserDefaults.standard.set(self.thresholdAsInt, forKey: "threshold")
                    UserDefaults.standard.set(self.webhook, forKey: "webhook")
                    UserDefaults.standard.set(self.webhookParam, forKey: "webhookParam")
                    UserDefaults.standard.set(self.launchAtLogin, forKey: "launchAtLogin")
                    LaunchAtLogin.isEnabled = self.launchAtLogin
                    self.popover?.performClose(self)
                }) {
                    Text("Save")
                }
            }.padding(.top)
        }.padding()
            .onAppear {
                self.initValues()
        }
    }
    
    var thresholdAsInt: Int {
        get {
            return Int(threshold)
        }
    }
    
    func initValues() {
        let thres = UserDefaults.standard.integer(forKey: "threshold")
        if thres > 0 {
            self.threshold = Double(thres)
        }
        if let url = UserDefaults.standard.string(forKey: "webhook") {
            self.webhook = url
        }
        if let param = UserDefaults.standard.string(forKey: "webhookParam") {
            self.webhookParam = param
        }
        self.launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        print("launchAtLogin => \(self.launchAtLogin)")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
