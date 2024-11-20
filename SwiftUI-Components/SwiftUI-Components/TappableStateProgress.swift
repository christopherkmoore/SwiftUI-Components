//
//  TappableStateProgress.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 11/18/24.
//

import SwiftUI

struct TappableStateProgress: View {
    @Environment(\.colorScheme) var colorScheme
    
    enum Tracking {
        case notStarted
        case inProgress
        case done
        case error
        
        var color: Color {
            switch self {
            case .notStarted: return .white
            case .inProgress: return .yellow
            case .done: return .green
            case .error: return .red
            }
        }
        
        var image: String {
            switch self {
            case .done: return "checkmark.circle.fill"
            case .inProgress: return "progress.indicator"
            case .error: return "xmark.circle.fill"
            default: return "none"
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .notStarted: return 0
            case .inProgress: return 4
            case .done: return 0
            case .error: return 1
            }
        }
        
        func next() -> Tracking {
            switch self {
            case .notStarted: return .inProgress
            case .inProgress: return .done
            case .done: return .error
            case .error: return .notStarted
            }
        }
    }
    
    struct StateTask: Identifiable {
        let id = UUID()
        var trackingBubble: Tracking
        let description: String
        
    }
    
    
    @State var stateTasksList: [StateTask] = [
        .init(trackingBubble: .done, description: "Create Invoice"),
        .init(trackingBubble: .done, description: "Invoice Sent"),
        .init(trackingBubble: .inProgress, description: "Invoice Paid")
    ]
    
    
    // Spacing for the Bubbles [o  o  o  o]
    var spacing: CGFloat {
        1.0 / CGFloat(stateTasksList.count + 1)
    }
    
    // Spacing for the line  --[  ]--
    var lineLength: CGFloat {
        (1.0 - spacing)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle() // Draw the line intersecting everything.
                    .fill(colorScheme == .dark ? Color.white.quinary : Color.black.quinary)
                    .frame(width: ((geometry.size.width * lineLength) - 100), height: 2)
                HStack {
                    Spacer()
                    ForEach($stateTasksList) { $stateTask in
                        ZStack {
                            Spacer()
                            
                            // Draw the Tracking Bubbles with taps for changing state
                            Button {
                                withAnimation {
                                    stateTask.trackingBubble = stateTask.trackingBubble.next()
                                }
                            } label: {
                                TappableStateProgressCirlce(stateTask: stateTask, reader: geometry)
                            }
                            Text(stateTask.description) // Our Labels
                                .font(.system(size: 12))
                                .frame(width: geometry.size.width * spacing, height: 30, alignment: .center)
                                .offset(y: 30)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct TappableStateProgressCirlce: View {
    @Environment(\.colorScheme) var colorScheme
    
    let stateTask: TappableStateProgress.StateTask
    let reader: GeometryProxy
    var size: CGFloat = 25
    var isSelected: Bool = false
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(colorScheme == .light ? Color.black.secondary : Color.white.secondary, lineWidth: 2) // Border
                .fill(.white)   // Use this to fill white over the line
                .fill(stateTask.trackingBubble.color.secondary)
                .frame(width: isSelected ? size * 2.0 : size,
                       height: isSelected ? size * 2.0 : size)
            
            if stateTask.trackingBubble != .notStarted {
                Image(systemName: stateTask.trackingBubble.image)
                    .resizable()
                    .padding(stateTask.trackingBubble.padding)
                    .frame(width: isSelected ? size * 2.0 : size,
                           height: isSelected ? size * 2.0 : size)
                    .foregroundStyle(colorScheme == .light ? .white : .black, .clear)
            }
        }.animation(.default, value: isSelected)
    }
}

#Preview {
    StateProgress()
}
