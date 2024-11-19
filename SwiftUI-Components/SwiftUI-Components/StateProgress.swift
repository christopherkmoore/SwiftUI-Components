//
//  StateProgress.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 11/18/24.
//

import SwiftUI

struct StateProgress: View {
   @Environment(\.colorScheme) var colorScheme
   
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
         case .done: return "Report Created"
         case .error: return "Past Due"
         }
      }
   }
   
   let states: [Bubbles] = [.done, .inProgress, .error, .notStarted, .notStarted, .notStarted]
   

   // Spacing for the Bubbles [o  o  o  o]
   var spacing: CGFloat {
      1.0 / CGFloat(states.count + 1)
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
               .frame(width: ((geometry.size.width * lineLength) - 40), height: 2)
            HStack {
               Spacer()
               ForEach(states.indices) { index in
                  let state = states[index]
                  ZStack {
                     Spacer()
                     
                     // Draw the Bubbles
                     StateProgressCirlce(state: state, reader: geometry)
                     
                     Text(state.title) // Our Labels
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

struct StateProgressCirlce: View {
   @Environment(\.colorScheme) var colorScheme
   
   let state: StateProgress.Bubbles
   let reader: GeometryProxy
   let size: CGFloat = 25
   
   var body: some View {
      ZStack {
         Circle()
            .stroke(colorScheme == .light ? Color.black.secondary : Color.white.secondary, lineWidth: 2) // Border
            .fill(.white)   // Use this to fill white over the line
            .fill(state.color.secondary)
            .frame(width: size, height: size)
         
         if state != .notStarted {
            Image(systemName: state.image)
               .resizable()
               .padding(state.padding)
               .frame(width: size, height: size)
               .foregroundStyle(colorScheme == .light ? .white : .black, .clear)
         }
      }
   }
}

#Preview {
   StateProgress()
}
