//
//  SelectArtView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/01/2022.
//

import SwiftUI

// First search view where user chooses the art he's interesting in, also the possibility to choose every art proposed.
struct SelectArtView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State private var selectedArt: Art?
    @State private var selectedArtName = ""
    @State private var isLinkActive = false
    
    private let arts: [Art] = ArtListLogo.artsLogo
    
    // MARK: - Body
    
    var body: some View {
        
        NavigationView {
        
            ZStack {
            
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1))]), startPoint: .topLeading, endPoint: .topTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.white)
                    .edgesIgnoringSafeArea(.bottom)
                
                VStack(alignment: .leading, spacing: 44) {
                    
                    HStack {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black).opacity(0.8)
                                .font(.system(size: 19))
                        }

                        Text("What do you want to discover?")
                            .foregroundColor(.black).opacity(0.8)
                            .font(.system(size: 19))
                            .padding(.horizontal, 8)
                        
                        Spacer()
                        
                    }.padding(.top, 25)
                    .padding(.horizontal, 20)

                    VStack(alignment: .leading, spacing: 25) {
                    
                        Text("OPEN FOR ANY ART")
                            .font(.callout).bold()
                            .foregroundColor(.black)
                        
                        NavigationLink(destination: SelectDepartmentView(selectedArtName: $selectedArtName)) {
                       
                            HStack {
                                    
                                Text("Surprise me")
                                    .gradientForeground(colors: [Color(#colorLiteral(red: 0.7490196078, green: 0.1176470588, blue: 0.1843137255, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1))])
                                    .font(.system(size: 19).bold())
                                    
                                Spacer()
                                    
                                Image(systemName: "chevron.forward")
                                    .gradientForeground(colors: [Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1))])
                                    
                            }.padding()
                            .background(RoundedRectangle(cornerRadius: 35)
                                        .fill(Color.white).shadow(radius: 5, y: 3))
                        }
                    }.padding(.horizontal, 20)
                    
                    VStack(alignment: .leading) {
                        Text("ARTS PROPOSED")
                            .font(.callout).bold()
                            .padding(.horizontal, 20)
                            .foregroundColor(.black)
                        
                        List(arts) { art in
                            
                            Button {
                                isLinkActive = true
                                selectedArtName = art.name
                                
                            } label: {
                                
                                HStack {
                                    
                                    Image(art.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                        .padding(.bottom, 10)
                                       
                                    Text(art.name)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        .padding(.horizontal, 15)
                                        .padding(.top, -7)
                                        
                                    Spacer()
                                    
                                    Image(systemName: "chevron.forward")
                                        .foregroundColor(.secondary)
                                }
                            }.listRowBackground(Color.white)
                            .listRowSeparator(.hidden)
                        }.padding(.top, -10)
                        .background(NavigationLink("", destination: SelectDepartmentView(selectedArtName: $selectedArtName), isActive: $isLinkActive))
                    }
                   Spacer()
                }
            }.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }.navigationViewStyle(.stack)
    }
}

struct SelectArtView_Previews: PreviewProvider {
    static var previews: some View {
        SelectArtView()
    }
}
