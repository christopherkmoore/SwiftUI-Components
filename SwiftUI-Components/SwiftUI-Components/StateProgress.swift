//
//  StateProgress.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 11/18/24.
//

import SwiftUI

import SwiftUI

struct StateProgress: View {
    enum Bubbles {
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
    }
    
    let states: [Bubbles] = [.done, .done, .inProgress, .error]
    
    var fill: CGFloat {
        CGFloat(states.filter { $0 != .notStarted }.count - 1) * 0.2
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                HStack {
                    Rectangle()
                        .fill(Color.black.quinary)
                        .frame(width: geometry.size.width * fill, height: 2)
                        .offset(x: geometry.size.width * 0.2)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    ForEach(states, id: \.self) { state in
                        StateProgressCirlce(state: state, reader: geometry)
                        Spacer()
                    }
                }
            }
        }
    }
}



struct StateProgressCirlce: View {
    let state: StateProgress.Bubbles
    let reader: GeometryProxy
    let size: CGFloat = 25
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .fill(state.color.secondary)
                .frame(width: size, height: size)
            
            if state != .notStarted {
                Image(systemName: state.image)
                    .resizable()
                    .padding(state.padding)
                    .frame(width: size, height: size)
                    .foregroundStyle(.white, .clear)
            }
            
            Circle()
                .stroke(.black.tertiary)
                .frame(width: size, height: size)
        }
    }
}

#Preview {
    StateProgress()
}
