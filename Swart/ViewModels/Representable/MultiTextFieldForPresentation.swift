//
//  MultiTextField.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 10/11/2021.
//

import SwiftUI

struct MultiTextFieldForPresentation: UIViewRepresentable {
    
    func makeCoordinator() -> MultiTextFieldForPresentation.Coordinator {
        
        return MultiTextFieldForPresentation.Coordinator(parent1: self)
    }
    
    @Binding var text: String
    
    func makeUIView(context: UIViewRepresentableContext<MultiTextFieldForPresentation>) -> UITextView {
        
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.text = "Hello everyone, I'm Max, a jazz lover and enthusiast. Since the age of 8, my saxophone and I have been inseparable. We have played in front of various audiences, from conservatory to local coffees to concert halls!\nSo, if you also admire Charlie Parker, Johnny Griffin, Stan Getz or John Coltrane, or if, on the contrary, jazz is an art that is still unknown to you, I will be happy to come to your place or to welcome you for a memorable performance."
        view.textColor = UIColor.black.withAlphaComponent(0.5)
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiTextFieldForPresentation>) {
        
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: MultiTextFieldForPresentation
        
        init(parent1: MultiTextFieldForPresentation) {
            parent = parent1
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let currentText = textView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            return updatedText.count <= 550
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == "Hello everyone, I'm Max, a jazz lover and enthusiast. Since the age of 8, my saxophone and I have been inseparable. We have played in front of various audiences, from conservatory to local coffees to concert halls!\nSo, if you also admire Charlie Parker, Johnny Griffin, Stan Getz or John Coltrane, or if, on the contrary, jazz is an art that is still unknown to you, I will be happy to come to your place or to welcome you for a memorable performance." {
                textView.text = ""
            }
            textView.textColor = UIColor.black.withAlphaComponent(0.6)
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
