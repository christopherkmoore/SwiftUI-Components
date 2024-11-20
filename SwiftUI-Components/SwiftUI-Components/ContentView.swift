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
        NavigationStack {
            LazyVStack(alignment: .leading) {
                NavigationLink("Collapsable Indicator") {
                    CollapseIndicator(isShowing: $isShowing)
                }
                Divider()
                
                NavigationLink("State Progress Bar") {

                   TappableStateProgress()
                      .offset(y: 100)
                }
                Divider()
                NavigationLink("State Tabbed Controller") {

                    StateTabbedController()
                }
                Divider()
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
