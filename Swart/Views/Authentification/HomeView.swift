//
//  HomeView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 23/09/2021.
//

import SwiftUI

// Home view where user can select to create a new account or log in.
struct HomeView: View {
    
    // To set up in all project specific UI for navigation bars, textfiels and table views.
    init() {
        UINavigationBar.appearance().tintColor = UIColor(.black)
        UITextField.appearance().clearButtonMode = .whileEditing
        UITableView.appearance().backgroundColor = UIColor(.white)
    }
    
    // MARK: - Properties

    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @State private var showLogInSheetView = false
    @State private var hasSignedIn = false
    let registration = UserDefaults.standard.bool(forKey: "registering")
    
    // MARK: - Body

    var body: some View {
        
        if authentificationViewModel.pastUserId.id != "" && !registration {
            UserTabView()
        } else {
            NavigationView {
                
                ZStack {
                    
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1)), Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                        
                    VStack(spacing: 35) {
                            
                        Spacer()
                            
                        Text("Swart")
                            .font(.custom("AmericanTypewriter", size: 60))
                            .fontWeight(.regular)
                            .font(.largeTitle)
                            .foregroundColor(.swartWhite)
                            
                        VStack {
                            Button(action: {
                                showLogInSheetView.toggle()
                            }, label: {
                                CustomTextForButton(text: "Create a new account")
                                    .padding(.horizontal, 40)
                                
                            }).sheet(isPresented: $showLogInSheetView, content: {
                                CreateAccountView(showLogInSheetView: $showLogInSheetView)
                            })
                                
                            NavigationLink(destination: LogInView()
                                            .navigationBarTitle("", displayMode: .inline)) {
                            
                                Text("Log In")
                                    .font(.system(size: 19))
                                    .foregroundColor(.black).opacity(0.8)
                                    .padding()
                            }
                        }
                        Spacer()
                    }.onAppear {
                        authentificationViewModel.userAlreadySignedIn()
                    }
                }.navigationBarHidden(true)
            }.accentColor(.black)
            .navigationViewStyle(.stack)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
