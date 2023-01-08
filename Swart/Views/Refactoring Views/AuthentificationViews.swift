//
//  UserViews.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/12/2021.
//

import SwiftUI
import ActivityIndicatorView

// Refactoring structures using in authentification views.
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

struct CustomTextForButton: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .frame(maxWidth: .infinity)
            .frame(height: 10, alignment: .center)
            .font(.system(size: 17))
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.lightBlack))
    }
}

struct CustomTextfieldForProfile: View {
    
    var bindingText: Binding<String>
    var text: String
    var textFromDb: String
    
    var body: some View {
        
        TextField("", text: bindingText)
            .foregroundColor(.black)
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
            .foregroundColor(.black)
    }
}

struct CustomTextForSmallButton: View {
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .font(.system(size: 20))
            .foregroundColor(.white)
            .padding(.vertical)
            .padding(.horizontal, 40)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.lightBlack))
    }
}

struct BackwardChevron: View {
    
    var body: some View {
        
        Image(systemName: "chevron.backward")
            .foregroundColor(.black)
            .opacity(0.7)
    }
}

struct TextForAddressPolicy: View {
    
    var body: some View {
        
        Text("We'll only share your address with artists who are booked as outlined in our privacy policy.")
            .fontWeight(.semibold)
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.horizontal)
    }
}

struct LabelForLogOutButton: View {
    
    var body: some View {
        
        Text("Log out")
            .font(.system(size: 20))
            .foregroundColor(.white).bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.mainRed))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.mainRed, lineWidth: 1))
    }
}
