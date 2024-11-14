//
//  ContentView.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 11/13/24.
//

import SwiftUI

struct ContentView: View {
    @State var isShowing: Bool = false
    var body: some View {
        LazyVStack(alignment: .leading) {
            
            HStack {
                Text("Collapsable Indicator")
                Spacer()
                CollapseIndicator(isShowing: $isShowing)
            }
            Divider()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
