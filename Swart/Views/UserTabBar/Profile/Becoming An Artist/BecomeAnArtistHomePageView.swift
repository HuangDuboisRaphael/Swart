//
//  SwitchPageTabView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 02/10/2021.
//

import SwiftUI

// Cover view for the artist form, also setting up of a dismiss button which is communicated to all child views for the user to exit the form whenever he wants and delete the artist information already sent to the database.
struct BecomeAnArtistHomePageView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State private var resetToRootView = false
    
    private var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "clear")
                .foregroundColor(.white)
                .opacity(0.7)
        })
    }
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 5) {
                    Image("Artist")
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()
                
                    VStack(alignment: .leading, spacing: 25) {
                        
                        Text("Become an Artist in 10 easy steps")
                            .fontWeight(.semibold)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text("You are about to join the Swart artists community. \nWhether you are professionals or amateurs, Swart is a showcase for your artistic talents. \nMore visibility towards the general public and your peers, the creation of personalized works, teaching, a gain of experience and above all, multiple encounters, this is all that you can expect in using Swart.")
                            .fontWeight(.semibold)
                            .font(.system(size: 13))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                
                    NavigationLink(destination: WhichArtView(resetToRootView: $resetToRootView), isActive: self.$resetToRootView) {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.mainRed)
                                .frame(height: 45)
                                .frame(maxWidth: .infinity)
                            
                            Text("Let's go!").bold()
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            
                        }.padding(.horizontal, 30)
                    }.isDetailLink(false)
         
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
        }.navigationViewStyle(.stack)
    }
}

struct SwitchPageTabView_Previews: PreviewProvider {
    static var previews: some View {
        BecomeAnArtistHomePageView()
    }
}
