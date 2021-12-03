//
//  WhereToView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 09/10/2021.
//

import SwiftUI

struct WhereToPerformView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @Binding var resetToRootView: Bool
    
    @State private var selectedPlaceName = ""
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    
    var places = ["Your place", "Audience's place", "Anywhere suits you", "Online only"]
    
    var body: some View {

        ZStack {
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
                Spacer(minLength: 190)

                TitleForArtistForm(text: "Where do you intend to realize your art?")
                                            
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                        ZStack {
                            Color.lightGrayForBackground
                        
                            ScrollView {
                                ForEach(places, id: \.self) { place in
                                    Button {
                                        selectedPlaceName = place
                                    } label: {
                                        Text(place)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                            .frame(width: UIScreen.main.bounds.width - 45, height: 80, alignment: .center)
                                            .font(.system(size: 18))
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(selectedPlaceName == place ? Color.selectedOrange : Color.white))
                                    }
                                }.padding()
                            }
                        }
                
                        HStack {

                            Spacer()
                            
                            NavigationLink(destination: AddressView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button(action: {
                                    if selectedPlaceName == "" {
                                        alertMessage = "Please select a proposition before going to the next step."
                                        isAlertPresented = true
                                    } else {
                                        artistCollectionViewModel.addSingleDocumentToArtistCollection(id: authentificationViewModel.userInAuthentification.id ?? "", nameDocument: "place", document: selectedPlaceName)
                                        self.isLinkActive = true
                                    }
                                }, label: {
                                    NextButtonForArtistForm()
                                }).alert(isPresented: $isAlertPresented) {
                                    Alert(title: Text(alertMessage))
                                }
                            }.isDetailLink(false)
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 19))
                    }
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct WhereToPerformView_Previews: PreviewProvider {
    static var previews: some View {
        WhereToPerformView(resetToRootView: .constant(false))
    }
}
