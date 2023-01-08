//
//  SelectDepartmentView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 22/01/2022.
//

import SwiftUI

// Second search view where user selects between one to four departments to filter his artists search.
struct SelectDepartmentView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @Binding var selectedArtName: String
    
    @State private var isLinkActive = false
    @State private var selection = ""
    @State private var selectedDepartments: [String] = [""]
    @State private var hasEdited = false
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    // MARK: - Body
    
    var body: some View {

        ZStack {
            
            BackgroundForArtistForm()
        
            GeometryReader { proxy in
                
                VStack {
                    
                   Spacer()
                    
                    ZStack {
                        
                        VStack {
                            
                            HStack {
                            
                                TitleForArtistForm(text: "In which department?")
                
                                Spacer()
                            }.padding(.horizontal, 12)
                
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: selectedDepartments.count < 5 ? CGFloat(selectedDepartments.count) * 65 + 200 : 460)
                                .foregroundColor(Color.white)
                                .overlay(
                                    
                                ZStack {
                                    
                                    VStack {
                                        
                                        ZStack {
                                            
                                            HStack {
                                                Text(selectedArtName)
                                                    .fontWeight(.semibold)
                                                    .font(.system(size: 19))
                                                    .gradientForeground(colors: [Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1))])
                                            }
                                        
                                            HStack {
                                                
                                                Button {
                                                    selectedArtName = ""
                                                    presentationMode.wrappedValue.dismiss()
                                                } label: {
                                                    Image(systemName: "chevron.backward")
                                                        .foregroundColor(.black).opacity(0.6)
                                                        .font(.system(size: 19))
                                                }
                                                Spacer()
                                            }
                                        }
                                        Spacer()
                                    }.padding(.horizontal, 32)
                                    .padding(.top, 30)
                                        
                                    VStack {
                                            
                                        ForEach(Array(zip(selectedDepartments.indices, selectedDepartments)), id: \.0) { index, department in
                                                
                                            ZStack {
                                                    
                                                HStack {
                                                    
                                                    Text(department)
                                                        .foregroundColor(.black).opacity(0.6)
                                                        .font(.system(size: 21))
                                                        .padding(.horizontal, 5)
                                                            
                                                    Spacer()
                                                        
                                                    Button {
                                                        selectedDepartments.remove(at: index)
                                                    } label: {
                                                        Image(systemName: "xmark")
                                                            .foregroundColor(.mainRed).opacity(0.6)
                                                            .font(.system(size: 21))
                                                            .padding(.trailing, 7)
                                                    }
                                                }.padding()
                                                .background(RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color.white).shadow(radius: 5, y: 3))
                                                .isHidden(department == "" ? true : false)
                                                
                                                Menu {
                                                    Picker(selection: $selection, label: EmptyView()) {
                                
                                                        ForEach(Department.names, id: \.self) { name in
                                                                
                                                            Text(name)
                                                        }
                                                    }
                                                } label: {
                                                            
                                                    HStack {
                                                                
                                                        Text("Add a department")
                                                            .foregroundColor(.black).opacity(0.6)
                                                            .font(.system(size: 21))
                                                            .padding(.horizontal, 5)
                                                                    
                                                        Spacer()
                                                                    
                                                        Image(systemName: "plus")
                                                            .foregroundColor(.black).opacity(0.6)
                                                            .font(.system(size: 21))
                                                            .padding(.trailing, 5)
                                                    }.padding()
                                                    .background(RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color.white).shadow(radius: 5, y: 3))
                                                }.isHidden(department == "" ? false : true)
                                                .isHidden(selectedDepartments.count > 4 ? true : false)
                                            }.padding(.horizontal, 32)
                                            
                                        }.onChange(of: selection) { newDepartment in
                                            if !selectedDepartments.contains(newDepartment) && selectedDepartments.count < 5 {
                                                selectedDepartments.insert(newDepartment, at: selectedDepartments.count - 1)
                                            }
                                        }
                                    }.padding(.top, -25)
                                    .padding(.bottom, selectedDepartments.count == 5 ? -50 : 0)
                                    
                                    VStack {
                                        
                                        Spacer()
                                        
                                        HStack {

                                            Spacer()
                                            
                                            NavigationLink(destination: SelectPlaceView(selectedArtName: $selectedArtName, selectedDepartments: $selectedDepartments), isActive: $isLinkActive) {
                                                Button(action: {
                                                    isLinkActive = true
                                                }, label: {
                                                    Text("Next").bold()
                                                        .frame(width: 50, height: 5, alignment: .center)
                                                        .font(.system(size: 18))
                                                        .foregroundColor(.white)
                                                        .padding()
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .foregroundColor(.mainRed).opacity(0.8))
                                                }).isHidden(hasEdited ? false : true)
                                            }
                                        }.padding(.horizontal, 20)
                                        .padding(.bottom, proxy.safeAreaInsets.top)
                                    }
                                })
                        }
                    }
                }.edgesIgnoringSafeArea(.bottom)
            }.onReceive(timer) { _ in
                if selectedDepartments.count > 1 {
                    hasEdited = true
                } else {
                    hasEdited = false
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct SelectDepartmentView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDepartmentView(selectedArtName: .constant(""))
    }
}
