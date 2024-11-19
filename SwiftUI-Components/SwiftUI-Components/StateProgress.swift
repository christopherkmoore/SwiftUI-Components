//
//  StateProgress.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 11/18/24.
//

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
        
        var title: String {
            switch self {
            case .notStarted: return "Not Started"
            case .inProgress: return "In Progress"
            case .done: return "Done"
            case .error: return "Past Due"
            }
        }
    }
    
    let states: [Bubbles] = [.done, .inProgress, .error, .notStarted]
    
    var numberOfLines: Int {
        states.filter { $0 != .notStarted }.count - 1
    }
    var fill: CGFloat {
        CGFloat(numberOfLines) * 0.2
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {

                    HStack {
                        Spacer()
                        ForEach(states.indices) { index in
                            let state = states[index]
                            ZStack {
                                if 0...numberOfLines ~= index {
                                    Rectangle()
                                        .fill(Color.black.quinary)
                                        .frame(width: geometry.size.width * 0.2, height: 2)
                                        .offset(x: geometry.size.width * 0.13)
                                }
                                Spacer()
                                StateProgressCirlce(state: state, reader: geometry)
                                Text(state.title)
                                    .font(.system(size: 12))
                                    .frame(width: geometry.size.width * 0.2, height: 2, alignment: .center)
                                    .frame(idealWidth: geometry.size.width)
                                    .offset(y: 25)
                            }
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
