//
//  EmailForgotPasswordView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 15/08/2021.
//

import SwiftUI
import ActivityIndicatorView

// To allow user to change his log in password.

struct EmailForgotPasswordView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var email = ""
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var isMailRestaured = false
    
    // MARK: - Body

    var body: some View {
        
        ZStack {
            Color(.white)
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
            
            VStack(spacing: 25) {
                
                TextField("Email", text: $email)
                    .font(.title3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress).autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button(action: {
                    isLoading = true
                    
                    authentificationViewModel.forgotPassword(email: email) { result in
                        switch result {
                        case .success(let message):
                            alertMessage = message
                            isMailRestaured = true
                        case .failure(let error):
                            alertMessage = error.localizedDescription
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isLoading = false
                        isAlertPresented = true
                    }
                }, label: {
                    CustomTextForSmallButton(text: "Send")
                })
                Spacer()
            }.isHidden(isLoading ? true : false)
            .padding()
        }.navigationBarTitle("Forgot password?", displayMode: .large)
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text(alertMessage), message: .none, dismissButton: .default(Text("OK"), action: {
                if isMailRestaured {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        )}
    }
}

struct EmailForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmailForgotPasswordView()
        }
    }
}
