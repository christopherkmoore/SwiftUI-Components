//
//  ContentView.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 11/13/24.
//

import SwiftUI

struct ContentView: View {
    @State var isShowing: Bool = false
    @State var completedSteps = 0
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
                
                NavigationLink("Animated Tab Group") {
                    
                    AnimatedTabGroup(numberOfSteps: 4, activeIndex: .constant(1), completedSteps: $completedSteps )
                    
                    Button("Increment") {
                        withAnimation {
                            completedSteps += 1
                        }
                    }
                    
                    Button("Decrease") {
                        withAnimation {
                            completedSteps -= 1
                        }
                    }
                }
                Divider()

                NavigationLink("Distance Chart Tappable") {
                    DistanceChartTappable()
                        .padding(20)

                }
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
