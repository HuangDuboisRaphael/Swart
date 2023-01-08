//
//  MultiTextFieldForHeadline.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 12/11/2021.
//

import SwiftUI

// To set custom textfield used for headline.
struct MultiTextFieldForHeadline: UIViewRepresentable {
    
    @Binding var defaultExample: String
    @Binding var text: String
    
    func makeCoordinator() -> MultiTextFieldForHeadline.Coordinator {
        return MultiTextFieldForHeadline.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultiTextFieldForHeadline>) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 26)
        view.text = defaultExample
        view.textColor = UIColor.black.withAlphaComponent(0.9)
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiTextFieldForHeadline>) {
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: MultiTextFieldForHeadline
        
        init(parent1: MultiTextFieldForHeadline) {
            parent = parent1
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let currentText = textView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            return updatedText.count <= 60
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.defaultExample {
                textView.text = ""
            }
            textView.textColor = UIColor.black.withAlphaComponent(0.9)
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
