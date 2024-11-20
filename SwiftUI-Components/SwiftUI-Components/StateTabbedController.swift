//
//  StateTabbedController.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 11/19/24.
//

import SwiftUI

import SwiftUI

struct Card: Identifiable, Hashable {
    var id: UUID = UUID()
    var text: String
}

struct StateTabbedController: View {
    @State var stateTasksList: [TappableStateProgress.StateTask] = [
        .init(trackingBubble: .done, description: "Create Invoice"),
        .init(trackingBubble: .done, description: "Invoice Sent"),
        .init(trackingBubble: .notStarted, description: "Invoice Paid")
    ]
    @State private var cards: [Card] = [Card(text: "Card 1"), Card(text: "Card 2")]
    @State private var activeCardIndex: Int? = 0

    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                
                HStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    ForEach(stateTasksList.indices) { index in
                        let stateTask = stateTasksList[index]
                        Button {
                            withAnimation {
                                activeCardIndex = index
                            }
                        } label: {
                            VStack {
                                HStack {
                                    TappableStateProgressCirlce(stateTask: stateTask, reader: geometry, size: 20, isSelected: index == activeCardIndex)
                                    if stateTasksList.count - 1 != index {
                                        Rectangle()
                                            .frame(height: 1)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                
                
                Text(stateTasksList[activeCardIndex ?? 0].description)
            

                
                .padding(.vertical, 10)
                ScrollView(.horizontal) {
                    HStack {
                        Group {
                            SampleScreen()
                            Rectangle()
                                .fill(.blue)
                                .id(1)
                            Capsule()
                                .fill(.orange)
                                .id(2)
                        }
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeCardIndex)
                .scrollIndicators(.never)
                .frame(height: 600)
            }
        }
    }

}

#Preview {
    StateTabbedController()
}

struct SampleScreen: View {
    var body: some View {
        VStack {
            Circle()
                .fill(.red)
                .id(0)
            
            Button("Next") {
                print("Next")
            }
        }
    }
}
