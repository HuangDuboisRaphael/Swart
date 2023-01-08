//
//  SearchArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 04/01/2022.
//

import SwiftUI

// Home user tab view where he can start searching for artists.
struct SearchArtistView: View {
    
    // MARK: - Property
    
    @State private var showSheet = false
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    Image("SearchBackground")
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                        .scaledToFill()
                    
                    Spacer()
                }
                
                VStack {
                            
                    Button {
                        showSheet = true
                            
                    } label: {
                                
                        ZStack {
                                    
                            RoundedRectangle(cornerRadius: 18)
                                .frame(height: 45)
                                .frame(width: UIScreen.main.bounds.width - 50)
                                .foregroundColor(.white)
                                      
                            HStack {
                                        
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.mainRed)
                                    .font(.title2)
                                            
                                Text("What do you want to discover?")
                                    .foregroundColor(.black)
                                    .font(.system(size: 17)).bold()
                            }
                        }
                    }
                    Spacer()
                }.padding(.vertical, 20)
                .fullScreenCover(isPresented: $showSheet, content: {
                    SelectArtView()
                })
            }.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }.navigationViewStyle(.stack)
    }
}

struct SearchArtistView_Previews: PreviewProvider {
    static var previews: some View {
        SearchArtistView()
    }
}
