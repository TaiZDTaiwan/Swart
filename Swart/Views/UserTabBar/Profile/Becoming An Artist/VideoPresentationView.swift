//
//  VideoPresentationView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 12/10/2021.
//

import SwiftUI
import AVKit
import PhotosUI

struct VideoPresentationView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var artistCollectionViewModel = ArtistCollectionViewModel()
    @StateObject var mediaItems = PhotoPickerViewModel()
        
    @Binding var resetToRootView: Bool
    
    @State var filter: PHPickerFilter = .videos
    @State var selectionLimit = 1
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var isAlertDeleteVideoPresented = false
    @State private var alertMessage = ""
    @State private var isPresented = false
    @State private var isVideoPresenting = false
    @State private var player = AVPlayer()
    
    var body: some View {
        
        ZStack {
            
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
                VStack(alignment: .leading, spacing: -20) {
                    
                    TitleForArtistForm(text: "... now in video")
                    
                    CaptionForArtistForm(text: "This step is not mandatory and can be realized later. But keep in mind, this format is an opportunity to get closer to your future audience and express freely your creativity !")
                }.padding(.top, 15)
                
                ZStack {
                    
                    Color(.white)
                        .ignoresSafeArea()
                
                    VStack {
                    
                        ZStack {
                            
                            Color.lightGrayForBackground
                            
                            if mediaItems.items.count > 0 {
                            
                                VideoPlayer(player: AVPlayer(url: mediaItems.items[0].url!))
                                    .frame(minHeight: 200)
                                    .isHidden(mediaItems.items.count > 0 ? false : true)
                            }
                            
                            Button {
                                isPresented = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.white)
                                        .padding(40)
                                    
                                    Image(systemName: "video.badge.plus")
                                        .resizable()
                                        .frame(width: 110, height: 75)
                                        .foregroundColor(.mainRed)
                                }
                            }.isHidden(mediaItems.items.count > 0 ? true : false)
                        }
                        
                        HStack {
                           
                            Button {
                                isAlertDeleteVideoPresented = true
                            } label: {
                                ImageForVideoPresentationView(text: "trash")
                                    .foregroundColor(.black)
                            }.isHidden(mediaItems.items.count > 0 ? false : true)
                            .alert(isPresented: $isAlertDeleteVideoPresented) {
                                Alert(
                                    title: Text("You are about to delete the current video. Do you confirm?"),
                                    message: .none,
                                    primaryButton: .destructive(Text("Confirm")) {
                                        mediaItems.deleteAll()
                                    },
                                    secondaryButton: .cancel()
                                )
                            }

                            Spacer()
                            
                            NavigationLink(destination: ArtistContentView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button(action: {
                                    if mediaItems.items.count > 0 {
                        
                                        artistCollectionViewModel.uploadVideoPresentationToDatabase(localFile: mediaItems.items[0].url!, documentId: authentificationViewModel.userId.id ?? "", nameDocument: "presentationVideo") { result in
                                            switch result {
                                            case .success(let success):
                                                print(success)
                                            case .failure(let error):
                                                print(error.localizedDescription)
                                            }
                                        }
                                    } else {
                                        artistCollectionViewModel.addSingleDocumentToArtistCollection(documentId: authentificationViewModel.userId.id ?? "", nameDocument: "presentationVideo", document: "")
                                    }
                                    self.isLinkActive = true
                                }, label: {
                                    textLabel(count: mediaItems.items.count)
                                })
                            }.isDetailLink(false)
                        }.padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }.sheet(isPresented: $isPresented, onDismiss: didDismiss, content: {
                PhotoPicker(mediaItems: mediaItems, filter: $filter, selectionLimit: $selectionLimit) { _ in
                    isPresented = false
                }
            })
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func textLabel(count: Int) -> some View {
        return Group {
            if count > 0 {
                TextLabelNextForArtistForm()
            } else {
                TextLabelIgnoreForArtistForm()
            }
        }
    }
    
    private func didDismiss() {
        if mediaItems.items.count > 0 {
            mediaItems.items.remove(at: 0)
        }
    }
}

struct ArtistVideoPresentationView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPresentationView(resetToRootView: .constant(false))
    }
}

struct ImageForVideoPresentationView: View {
    
    var text: String
    
    var body: some View {
        Image(systemName: text)
            .resizable()
            .frame(width: 23, height: 23)
    }
}
