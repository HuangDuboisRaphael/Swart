//
//  CreateAccountView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 13/08/2021.
//

import SwiftUI
import ActivityIndicatorView

// To let user create a new account and send his information to the database in a new document in user collection.
// After creation, accessing to the main tab view.
struct CreateAccountView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var showLogInSheetView: Bool
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthday = Date()
    @State private var email = ""
    @State private var password = ""
    @State private var rePassword = ""
    @State private var user: User?
    @State private var showMain = false
    @State private var accessToTabView = false
    @State private var isLoading = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    
    private let datesFormattersViewModel = DatesFormattersViewModel()
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
                
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1)), Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .opacity(0.3)
                
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
                
            ScrollView {
                    
                VStack(spacing: 20) {
                    ZStack {
                        HStack {
                            Button(action: {
                                self.showLogInSheetView = false
                            }, label: {
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                            })
                            Spacer()
                        }
                        HStack {
                            Text("Finish signing up")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        CustomTextField(text: "First name", bindingText: $firstName)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                            
                        CustomTextField(text: "Last name", bindingText: $lastName)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                            
                        CaptionText(text: "Make sure it matches the name on your government ID.")
                    }
                        
                    VStack(alignment: .leading) {
                            
                        HStack {
                            DatePicker(selection: $birthday, in: ...Date(), displayedComponents: .date) {
                                    Text("Birthday (mm/dd/yyyy)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.lightGray)
                            }
                        }.padding(5)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.gray, lineWidth: 2))
                            
                        CaptionText(text: "To sign up, you need to be at least 18. Your birthday won't be shared with other people using Swart.")
                    }
                        
                    VStack(spacing: 10) {
                            
                        CustomTextField(text: "Email Address", bindingText: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        CustomSecureField(text: "Password", bindingText: $password)
                        
                        CustomSecureField(text: "Confirm Password", bindingText: $rePassword)
                    }
                        
                    VStack(spacing: 20) {
                        Group {
                            Text("By selecting Agree and continue below, I agree to Swart's")
                                + Text(" Terms of Service").foregroundColor(.blue).underline()
                                + Text(" and")
                                + Text(" Privacy Policy").foregroundColor(.blue).underline()
                                + Text(".")
                        }.font(.system(.caption))
                        .foregroundColor(Color(.gray))
                            
                        Button(action: {
                            createUserInDatabase()
                        }, label: {
                            CustomTextForButton(text: "Agree and continue")
                                .padding(.top, 10)
                        })
                    }
                }.padding()
                .padding(.horizontal, 8)
            }.isHidden(isLoading ? true : false)
        }.navigationBarTitle(Text("Finish signing up"), displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            self.showLogInSheetView = false
        }, label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.black)
                .opacity(0.7)
        }))
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text(alertMessage), dismissButton: .default(Text("Ok"), action: {
                if accessToTabView {
                    showMain = true
                }
            }))
        }
        .fullScreenCover(isPresented: $showMain, content: {
            UserTabView()
        })
    }
    
    // MARK: - Methods
    
    private func createUserInDatabase() {
        let personalInformation = [firstName, lastName, email, password, rePassword]
        let userIsAdult = datesFormattersViewModel.userIs18(birthdate: birthday)
    
        if personalInformation.contains("") {
            alertMessage = "Please fill all required information."
            isAlertPresented = true
            
        } else if userIsAdult == false {
            alertMessage = "You cannot create an account if you are under 18."
            isAlertPresented = true
            
        } else if password != rePassword {
            alertMessage = "Please insert same passwords."
            isAlertPresented = true
            
        } else {
            isLoading = true
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let birthdate = formatter.string(from: birthday)
            
            let newUser = User(firstName: firstName, lastName: lastName, birthdate: birthdate, address: "", department: "", email: email, profilePhoto: "", wishlist: [], pendingRequest: [], comingRequest: [], previousRequest: [])
            
            authentificationViewModel.createUserInDatabase(email: email, password: password, rePassword: rePassword, newUser: newUser, progressEmail: { result in
                switch result {
                case .success(let message):
                    alertMessage = message
                    isAlertPresented = true
                    accessToTabView = true
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    isAlertPresented = true
                    isLoading = false
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(showLogInSheetView: .constant(false))
    }
}

// MARK: - Refactoring structures

struct CustomTextField: View {
    let text: String
    let bindingText: Binding<String>
    
    var body: some View {
        TextField(text, text: bindingText)
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray, lineWidth: 2))
            .font(.system(size: 14))
            .disableAutocorrection(true)
    }
}

struct CaptionText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(.caption))
            .foregroundColor(Color(.gray))
    }
}

struct CustomSecureField: View {
    let text: String
    let bindingText: Binding<String>
    
    var body: some View {
        SecureField(text, text: bindingText)
            .padding(10)
            .overlay(RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray, lineWidth: 2))
            .font(.system(size: 14))
            .disableAutocorrection(true)
            .textContentType(.newPassword)
            .autocapitalization(.none)
    }
}
