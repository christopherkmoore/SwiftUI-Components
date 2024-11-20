//
//  StateTabbedController.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 11/19/24.
//

import SwiftUI

struct StateTabbedController: View {
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
        var shouldConnect: Bool = false
        let description: String
        
    }
    
    @State var stateTasksList: [StateTask] = [
        .init(trackingBubble: .done, description: "Created"),
        .init(trackingBubble: .inProgress, description: "Sent 🚀"),
        .init(trackingBubble: .inProgress, description: "Sent 🚀")
    ]
    
    @State private var activeCardIndex: Int? = 0
    @Namespace private var animation
    
    func checkConnections() {
        for index in 0..<stateTasksList.count - 1 {
            if index + 1 > stateTasksList.count {
                break
            }
            
            let next = stateTasksList[index + 1]
            let current = stateTasksList[index]
            
            if current.trackingBubble != .notStarted {
                stateTasksList[index].shouldConnect = true
            } else if current.trackingBubble == .notStarted {
                stateTasksList[index].shouldConnect = false
                if next.trackingBubble == .notStarted {
                    stateTasksList[index + 1].shouldConnect = false
                }
            } else {
                stateTasksList[index].shouldConnect = false
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                HStack{
                    ForEach(stateTasksList.indices) { index in
                        let stateTask = stateTasksList[index]
                        Button {
                            activeCardIndex = index
                        } label: {
                            HStack {
                                StateTab(stateTask: stateTask, reader: geometry, size: 25, isSelected: index == activeCardIndex, animation: animation)
                                
                                if stateTasksList.count - 1 != index {
                                    Line()
                                        .trim(from: 0.0, to: stateTask.shouldConnect ? 1 : 0)
                                        .stroke(.black, lineWidth: stateTask.shouldConnect ? 1 : 0)
                                        .frame(maxWidth: geometry.size.width / CGFloat((stateTasksList.count + (stateTasksList.count / 2))))
                                }
                            }
                        }.buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal) {
                    HStack {
                        Group {
                            ForEach(0..<stateTasksList.count) { index in
                                SampleScreen(id: index) {
                                    stateTasksList[index].trackingBubble = stateTasksList[index].trackingBubble.next()
                                    
                                    withAnimation {
                                        checkConnections()
                                    }
                                    
                                }
                            }
                        }
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeCardIndex)
                .scrollIndicators(.never)
                .frame(height: (geometry.size.height / 8) * 7 )
                
            }
        }
        .animation(.default, value: activeCardIndex)
        .onAppear(perform: checkConnections)
        
    }
    
}

#Preview {
    StateTabbedController()
}

struct SampleScreen: View {
    let id: Int
    let action: () -> ()
    var body: some View {
        VStack {
            
            Button("Next") {
                action()
            }
            Rectangle()
                .fill(.red)
        }
        .id(id)
        
    }
}


struct StateTab: View {
    @Environment(\.colorScheme) var colorScheme
    
    let stateTask: StateTabbedController.StateTask
    let reader: GeometryProxy
    var size: CGFloat = 25
    var isSelected: Bool = false
    var animation: Namespace.ID
    
    var body: some View {
        VStack(alignment: .listRowSeparatorLeading) {
            if isSelected { }
            ZStack {
                Circle()
                    .stroke(colorScheme == .light ? Color.black.secondary : Color.white.secondary, lineWidth: 2) // Border
                    .fill(.white)   // Use this to fill white over the line
                    .fill(stateTask.trackingBubble.color.secondary)
                    .frame(width: isSelected ? size * 1.5 : size,
                           height: isSelected ? size * 1.5 : size)
                
                if stateTask.trackingBubble != .notStarted {
                    Image(systemName: stateTask.trackingBubble.image)
                        .resizable()
                        .padding(stateTask.trackingBubble.padding)
                        .frame(width: isSelected ? size * 1.5 : size,
                               height: isSelected ? size * 1.5 : size)
                        .foregroundStyle(colorScheme == .light ? .white : .black, .clear)
                }
            }
            if isSelected {
                Text(stateTask.description)
                    .font(.system(size: 14))
                    .matchedGeometryEffect(id: "menuTransition", in: animation)
                    .lineLimit(1)
                
            }
        }
        .animation(.default, value: isSelected)
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}
