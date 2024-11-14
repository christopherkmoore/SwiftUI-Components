//
//  CollapsableIndicator.swift
//  SwiftUI-Components
//
//  Created by Christopher Moore on 11/13/24.
//

import SwiftUI

struct CollapseIndicator: View {
    @Binding var isShowing: Bool
    var body: some View {
        Button {
            withAnimation {
                isShowing.toggle()
            }
        } label: {
            Image(systemName: "chevron.right")
                .rotationEffect(isShowing ? .degrees(90.0) : .zero)
                .tint(.black)
        }
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = false
    Text(isShowing ? "Open" : "Closed")
        .padding(10)
    CollapseIndicator(isShowing: $isShowing)
}
