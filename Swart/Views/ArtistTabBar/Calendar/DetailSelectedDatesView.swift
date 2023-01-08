//
//  DetailDayView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 27/12/2021.
//

import SwiftUI
import ActivityIndicatorView

// Let the artist decides wether he will be available at the selected dates and would update accordingly the database: can add unavailabilities in the artist document or delete them from the dedicated array.
struct DetailSelectedDatesView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    @Binding var selectedDates: [String]
    @Binding var selectedDatesForDetailView: [String]
    @Binding var hasEdited: Bool
    
    @State private var datesToDelete: [String] = []
    @State private var hasCheckedAvailable = true
    @State private var hasCheckedBlocked = false
    @State private var isLoading = false
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
            
            ZStack {
                
                VStack(alignment: .leading, spacing: 65) {
                
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "clear")
                        })
                        Spacer()
                    }.padding(.vertical, 25)
                    
                    Text(calendarViewModel.displaySelectedDates(dates: selectedDatesForDetailView))
                        .font(.system(size: 38)).bold()
                    
                    Spacer()
                }
    
                VStack(alignment: .leading, spacing: 30) {
                    
                    Text("Availability")
                        .font(.system(size: 28)).bold()
                        
                    VStack {
                        HStack {
                            Text("Available")
                                .font(.system(size: 22))
                                
                            Spacer()
                                
                            Button {
                                if !hasCheckedAvailable {
                                    hasCheckedAvailable.toggle()
                                    hasCheckedBlocked.toggle()
                                }
                            } label: {
                                CircleForDetailSelectedDates(hasChecked: hasCheckedAvailable)
                            }
                        }
                            
                        Divider()
                            
                        HStack {
                            Text("Blocked")
                                .font(.system(size: 22))
                                
                            Spacer()
                                
                            Button {
                                if !hasCheckedBlocked {
                                    hasCheckedAvailable.toggle()
                                    hasCheckedBlocked.toggle()
                                }
                            } label: {
                                CircleForDetailSelectedDates(hasChecked: hasCheckedBlocked)
                            }
                        }
                    }
                }
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                            
                        Button {
                            if hasCheckedBlocked {
                                isLoading = true
                                calendarViewModel.addBlockedDatesInArtistDocument(documentId: authentificationViewModel.userId.id ?? "", dates: selectedDates) {
                                    calendarViewModel.getBlockedDatesFromArtistDocument(documentId: authentificationViewModel.userId.id ?? "") {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            selectedDates.removeAll()
                                            hasEdited = false
                                            presentationMode.wrappedValue.dismiss()
                                            isLoading = false
                                        }
                                    }
                                }
                            } else {
                                isLoading = true
                                for date in calendarViewModel.blockedDates {
                                    if selectedDates.contains(date) {
                                        datesToDelete.append(date)
                                    }
                                }
                                calendarViewModel.deleteBlockedDatesFromArtistDocument(documentId: authentificationViewModel.userId.id ?? "", dates: datesToDelete) {
                                    calendarViewModel.getBlockedDatesFromArtistDocument(documentId: authentificationViewModel.userId.id ?? "") {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            selectedDates.removeAll()
                                            hasEdited = false
                                            presentationMode.wrappedValue.dismiss()
                                            isLoading = false
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("Save")
                                .font(.system(size: 18)).bold()
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 2)
                                            .frame(width: 85, height: 45)
                                            .foregroundColor(.mainRed))
                        }
                    }.padding(.vertical, 22)
                    .padding(.horizontal)
                }.onAppear {
                    print(selectedDatesForDetailView)
                }
            }.isHidden(isLoading ? true : false)
        }.padding(.horizontal, 20)
    }
}

struct DetailDayView_Previews: PreviewProvider {
    static var previews: some View {
        DetailSelectedDatesView(calendarViewModel: CalendarViewModel(), selectedDates: .constant([]), selectedDatesForDetailView: .constant([]), hasEdited: .constant(false))
    }
}

// MARK: - Refactoring structure

struct CircleForDetailSelectedDates: View {
    var hasChecked: Bool
    
    var body: some View {
        Circle()
            .strokeBorder(Color.black.opacity(0.2), lineWidth: 1)
            .frame(width: 30, height: 30)
            .background(Circle().foregroundColor(hasChecked ? .mainRed : .gray.opacity(0.1)))
            .overlay(Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .isHidden(hasChecked ? false : true))
    }
}
