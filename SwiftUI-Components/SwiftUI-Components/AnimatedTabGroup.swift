//
//  AnimatedTabGroup.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 12/6/24.
//

import SwiftUI

struct AnimatedTabGroup: View {
    var numberOfSteps: Int
    @Binding var activeIndex: Int
    @Binding var completedSteps: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< numberOfSteps, id: \.self) { step in
                Circle()
                    .stroke(lineWidth: step <= completedSteps ? 25 : 3)
                    .frame(width: 40, height: step <= completedSteps ? 15 : 40)
                    .foregroundStyle( step < completedSteps ? .green : Color(uiColor: UIColor.systemGray))
                    .overlay {
                        if step < completedSteps {
                            Image(systemName: "checkmark")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .transition(.scale)
                        }
                    }
                
                if step < completedSteps - 1 {
                    ZStack {
                        Rectangle()
                            .frame(height: 3)
                            .foregroundStyle(Color(uiColor: UIColor.systemGray))
                        Rectangle()
                            .frame(height: 3)
                            .frame(maxWidth: step >= completedSteps ? 0 : .infinity, alignment: .leading)
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .frame(height: 50)
    }
}


#Preview {
    AnimatedTabGroup(numberOfSteps: 3, activeIndex: .constant(2), completedSteps: .constant(1))
}
