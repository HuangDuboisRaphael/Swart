//
//  LogInView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 23/09/2021.
//

import SwiftUI

// To allow user to fill his log in personal information and access to the tab view.
struct LogInView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var email = ""
    @State private var password = ""
    @State private var user: User?
    @State private var showMain = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    
    // MARK: - Body

    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1)), Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
            VStack(spacing: 20) {
                    
                Spacer()
                    
                Text("Swart")
                    .font(.custom("AmericanTypewriter", size: 60))
                    .fontWeight(.regular)
                    .font(.largeTitle)
                    .foregroundColor(.swartWhite)
                    
                VStack(alignment: .trailing) {
                        
                    VStack(spacing: 15) {
                            
                        TextField("Email Address", text: $email)
                            .font(.system(.body))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            
                        SecureField("Password", text: $password)
                            .font(.system(.body))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.password)
                            .disableAutocorrection(true)
                    }
                         
                        NavigationLink(destination: EmailForgotPasswordView()) {
                            
                            Text("Forgot password?").bold()
                                .font(.system(size: 15))
                                .frame(height: 20, alignment: .trailing)
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    
                Button(action: {
                    authentificationViewModel.signInUser(email: email, password: password) { result in
                        switch result {
                        case .success(let message):
                            print(message)
                            self.showMain = true
                        case .failure(let error):
                            alertMessage = error.localizedDescription
                            isAlertPresented = true
                        }
                    }
                }, label: {
                    CustomTextForSmallButton(text: "Log In")
                })
                .fullScreenCover(isPresented: $showMain, content: {
                    UserTabView()
                })
                
                Spacer()
            }.padding(35)
        }.alert(isPresented: $isAlertPresented, content: {
            Alert(title: Text(alertMessage))
        })
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
