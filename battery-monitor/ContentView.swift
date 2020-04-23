//
//  ContentView.swift
//  battery-monitor
//
//  Created by Hiromasa Ohno on 2020/04/23.
//  Copyright © 2020 SonicGarden. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {}) {
                Text("Quit")
            }
            Text("Hello, World!")
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
