//
//  MultiTextField.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 10/11/2021.
//

import SwiftUI

// To set custom textfield used for text presentation.
struct MultiTextFieldForPresentation: UIViewRepresentable {
    
    @Binding var defaultExample: String
    @Binding var text: String
    
    func makeCoordinator() -> MultiTextFieldForPresentation.Coordinator {
        return MultiTextFieldForPresentation.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultiTextFieldForPresentation>) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.text = defaultExample
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
            if textView.text == parent.defaultExample {
                textView.text = ""
            }
            textView.textColor = UIColor.black.withAlphaComponent(0.6)
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
