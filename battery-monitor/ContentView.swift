//
//  ContentView.swift
//  battery-monitor
//
//  Created by Hiromasa Ohno on 2020/04/23.
//  Copyright © 2020 SonicGarden. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var webhook = ""
    @State private var threshold = 50.0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text("Webhook URL")
                TextField("Webhook URL", text: $webhook, onEditingChanged: { _ in
                    print("\(self.webhook)")
                    UserDefaults.standard.set(self.webhook, forKey: "webhook")
                })
                Button(action: {
                    WebhookNotifier.test(webhookUrl: self.webhook)
                }){
                    Text("Test Webhook")
                }
            }
            
            HStack(alignment: .center) {
                Text("Notify when battery is less than \(thresholdAsInt) %")
                Slider(value: $threshold, in: 10...80, onEditingChanged: { _ in
                    print("\(self.thresholdAsInt)")
                    UserDefaults.standard.set(self.thresholdAsInt, forKey: "threshold")
                })
            }
        }.padding()
            .onAppear {
                let thres = UserDefaults.standard.integer(forKey: "threshold")
                print(thres)
                if thres > 0 {
                    self.threshold = Double(thres)
                }
                if let url = UserDefaults.standard.string(forKey: "webhook") {
                    print(url)
                    self.webhook = url
                }
        }
    }
    
    var thresholdAsInt: Int {
        get {
            return Int(threshold)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
