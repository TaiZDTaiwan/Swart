//
//  VideoPresentationView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 12/10/2021.
//

import SwiftUI
import AVKit
import PhotosUI
import FirebaseStorage

struct VideoPresentationView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    @EnvironmentObject var storeArtistContentViewModel: StoreArtistContentViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var artistCollectionViewModel = ArtistCollectionViewModel()
    @ObservedObject var mediaItems = PickedMediaItems()
        
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
    @State private var url: URL = URL(fileURLWithPath: "")
    @State private var textUrl = ""
    
    var body: some View {
        
        ZStack {
            
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: -20) {
                    
                    TitleForArtistForm(text: "... now in video")
                    
                    CaptionForArtistForm(text: "This step is not mandatory and can be realized later. But keep in mind, this format is an opportunity to get closer to your future audience and express freely your creativity !")
                }
                
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                
                    VStack {
                    
                        ZStack {
                            
                            Color.lightGrayForBackground
                            
                            VideoPlayer(player: player)
                                .frame(minHeight: 200)
                                .isHidden(isVideoPresenting ? false : true)
                            
                            Button {
                                isPresented = true
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.white)
                                        .padding(EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40))
                                    
                                    if !isVideoPresenting {
                                        Image(systemName: "video.badge.plus")
                                            .resizable()
                                            .frame(width: 110, height: 75)
                                            .foregroundColor(.mainRed)
                                    }
                                }
                            }.isHidden(isVideoPresenting ? true : false)
                        }
                        
                        HStack {
                            HStack(spacing: 30) {
                                Button {
                                    isPresented = true
                                } label: {
                                    ImageForVideoPresentationView(text: "plus")
                                        .foregroundColor(.black)
                                }.isHidden(isVideoPresenting ? false : true)
                                
                                Button {
                                    isAlertDeleteVideoPresented = true
                                } label: {
                                    ImageForVideoPresentationView(text: "trash")
                                        .foregroundColor(.mainRed)
                                }.isHidden(isVideoPresenting ? false : true)
                                .alert(isPresented: $isAlertDeleteVideoPresented) {
                                    Alert(
                                        title: Text("You are about to delete the current video. Do you confirm?"),
                                        message: .none,
                                        primaryButton: .destructive(Text("Confirm")) {
                                            mediaItems.deleteAll()
                                            isVideoPresenting = false
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }

                            Spacer()
                            
                            NavigationLink(destination: ArtistContentView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button(action: {
                                    if isVideoPresenting {
                                        artistCollectionViewModel.uploadPresentationVideo(url: self.url, id: authentificationViewModel.userInAuthentification.id ?? "")
                                        storeArtistContentViewModel.hasUploadedPresentationVideo = true
                                    }
                                    self.isLinkActive = true
                                }, label: {
                                    textLabel()
                                })
                            }.isDetailLink(false)
                        }.padding(EdgeInsets(top: 3, leading: 19, bottom: 0, trailing: 19))
                    }
                }
            }.sheet(isPresented: $isPresented, onDismiss: didDismiss) {
                PhotoPicker(mediaItems: mediaItems, filter: $filter, selectionLimit: $selectionLimit) { _ in
                    isPresented = false
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
        
    private func didDismiss() {
        
        mediaItems.deleteAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
        
            if mediaItems.items.count > 0 {
                if let url = mediaItems.items[0].url {
                    self.url = url
                    textUrl = url.absoluteString
                    player = AVPlayer(url: URL(string: textUrl)!)
                    isVideoPresenting = true
                }
            } else {
                isVideoPresenting = false
            }
        }
    }
    
    private func textLabel() -> some View {
        return Group {
            if isVideoPresenting {
                TextLabelNextForArtistForm()
            } else {
                TextLabelIgnoreForArtistForm()
            }
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
