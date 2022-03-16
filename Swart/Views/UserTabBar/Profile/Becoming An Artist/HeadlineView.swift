//
//  HeadlineView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 12/11/2021.
//

import SwiftUI

struct HeadlineView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var artistCollectionViewModel = ArtistCollectionViewModel()
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    @Binding var resetToRootView: Bool
    
    @State private var headline = ""
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var textExamples = TextExamples()
    
    var body: some View {

        ZStack {
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
                Spacer(minLength: UIScreen.main.bounds.height * 2/5)
                
                TitleForArtistForm(text: "Give yourself a headline")
                  
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text("Your headline")
                                .font(.system(size: 14)).bold()
                                .padding(.vertical, 7)
                            
                            MultiTextFieldForHeadline(defaultExample: $textExamples.exampleForHeadline, text: $headline)
                                .frame(height: 115)
                                .background(Color.lightGrayForBackground)
                                .cornerRadius(10)
                            
                            HStack {
                                Spacer()
                                
                                Text("\(headline.count)/60")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                                    .padding(.top, 4)
                            }
                        }.padding(.vertical, 20)
                        .padding(.horizontal)
                        .padding(.bottom, keyboardHandler.keyboardHeight)
                        
                        Spacer()
                    
                        HStack {

                            Spacer()
                            
                            NavigationLink(destination: TextPresentationView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button {
                                    if headline.isEmpty {
                                        alertMessage = "Please come out with a headline before continuing."
                                        isAlertPresented = true
                                    } else {
                                        artistCollectionViewModel.addSingleDocumentToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameDocument: "headline", document: headline)
                                        self.isLinkActive = true
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
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct HeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineView(resetToRootView: .constant(false))
    }
}
