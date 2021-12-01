//
//  WhichArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 03/10/2021.
//

import SwiftUI

struct WhichArtView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @Binding var resetToRootView: Bool
    
    @State private var selectedArt: Art?
    @State private var selectedArtName = ""
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    
    var arts: [Art] = ArtList.arts
    
    var body: some View {

        ZStack {
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                    
                TitleForArtistForm(text: "What type of art do you want to perform?")
                                            
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                        List(arts) { art in
                            Button {
                                selectedArt = art
                                selectedArtName = art.name
                            } label: {
                                HStack {
                                    Text(art.name)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                        
                                    Spacer()
                            
                                    Image(art.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 60)
                                        .cornerRadius(4)
                                    }
                                }
                            .listRowBackground(selectedArt == art ? Color.selectedOrange : Color.white)
                        }
                
                        HStack {

                            Spacer()
                            
                            NavigationLink(destination: WhereToPerformView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button(action: {
                                    if selectedArtName == "" {
                                        alertMessage = "Please select an art before going to the next step."
                                        isAlertPresented = true
                                    } else {
                                        artistCollectionViewModel.setArtistCollection(id: authentificationViewModel.userInAuthentification.id ?? "", nameDocument: "art", document: selectedArtName)
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

struct WhichArtistView_Previews: PreviewProvider {
    static var previews: some View {
        WhichArtView(resetToRootView: .constant(false))
    }
}
