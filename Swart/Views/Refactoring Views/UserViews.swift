//
//  UserViews.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/12/2021.
//

import SwiftUI
import ActivityIndicatorView

struct ActivityIndicator: View {
    
    var isLoadingBinding: Binding<Bool>
    var isLoading: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ActivityIndicatorView(isVisible: isLoadingBinding, type: .arcs)
                .foregroundColor(.mainRed)
                .frame(width: 70, height: 70, alignment: .center)
                .isHidden(isLoading ? false : true)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

struct CustomTextfieldForProfile: View {
    var bindingText: Binding<String>
    var text: String
    var textFromDb: String
    
    var body: some View {
        TextField("", text: bindingText)
            .placeholder(when: text.isEmpty) {
                Text(textFromDb).foregroundColor(.black)
                    .disableAutocorrection(true)
            }
    }
}

struct CustomTextForProfile: View {
    var text: String
    
    var body: some View {
        Text(text)
            .bold()
            .font(.system(size: 12))
    }
}

struct BackwardChevron: View {
    
    var body: some View {
        Image(systemName: "chevron.backward")
            .foregroundColor(.black)
            .opacity(0.7)
    }
}
