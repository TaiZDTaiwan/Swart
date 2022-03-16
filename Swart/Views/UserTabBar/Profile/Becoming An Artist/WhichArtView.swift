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
                
                HStack {
                    Button {
                        artistCollectionViewModel.removeUnfinishedArtistFromDatabase(documentId: authentificationViewModel.userId.id ?? "")
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: -12) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                                .opacity(0.7)
                                .padding()
                            
                            Text("Back")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    
                    DismissButtonForArtistForm(isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                    
                }.padding(.horizontal, 10)
                    
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
                                }.listRowBackground(selectedArt == art ? Color.selectedOrange : Color.lightGrayForBackground.opacity(0.6))
                        }
                
                        HStack {

                            Spacer()
                            
                            NavigationLink(destination: WhereToPerformView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button {
                                    if selectedArtName == "" {
                                        alertMessage = "Please select an art before going to the next step."
                                        isAlertPresented = true
                                    } else {
                                        artistCollectionViewModel.setArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameDocument: "id", document: authentificationViewModel.userId.id ?? "") {
                                            artistCollectionViewModel.addSingleDocumentToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameDocument: "art", document: selectedArtName) {
                                                artistCollectionViewModel.addEmptyDataToArtistCollection(documentId: authentificationViewModel.userId.id ?? "")
                                                self.isLinkActive = true
                                            }
                                        }
                                    }
                                    
                                } label: {
                                    NextButtonForArtistForm()
                                }.alert(isPresented: $isAlertPresented) {
                                    Alert(title: Text(alertMessage))
                                }
                            }.isDetailLink(false)
                        }.padding(.horizontal, 20)
                        .padding(.vertical, 10)
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
