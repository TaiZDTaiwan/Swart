//
//  EditHeadlineView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 18/12/2021.
//

import SwiftUI
import ActivityIndicatorView

struct EditHeadlineView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    @State private var headline = ""
    @State private var headlineCopy = ""
    @State private var hasEdited = false
    @State private var isLoading = false
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
        
            VStack {
                
                HStack {
                
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        BackwardChevron()
                            .padding()
                    })
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading, spacing: 5) {
                    
                        Text("Headline")
                            .font(.title).bold()
                        
                        Text("Feel free to edit your current headline")
                            .font(.footnote)
                    }

                    MultiTextFieldForHeadline(defaultExample: $artistCollectionViewModel.artist.headline, text: $headline)
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
                }.padding(.horizontal, 20)
                
                Spacer()
                
                HStack {
                    Spacer()
                
                    ZStack {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 85, height: 45)
                            .foregroundColor(.mainRed)
                            .opacity(hasEdited ? 1 : 0.2)
                        
                        Button {
                            isLoading = true
                            artistCollectionViewModel.addSingleDocumentToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameDocument: "headline", document: headline) {
                                artistCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        self.presentationMode.wrappedValue.dismiss()
                                        isLoading = false
                                    }
                                }
                            }
                        } label: {
                            Text("Save")
                                .font(.system(size: 18)).bold()
                                .foregroundColor(.white)
                        }.disabled(hasEdited ? false : true)
                    }.padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }.onAppear(perform: {
                    headlineCopy = headline
                })
                .onReceive(timer) { _ in
                    if headlineCopy != headline && !headline.isEmpty {
                        hasEdited = true
                    }
                    if headline.isEmpty {
                        hasEdited = false
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }.isHidden(isLoading ? true : false)
        }
    }
}

struct EditHeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        EditHeadlineView(artistCollectionViewModel: ArtistCollectionViewModel())
    }
}
