//
//  ItemsView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 16/10/2021.
//

import SwiftUI
import AVKit
import PhotosUI
import SDWebImageSwiftUI

struct ReviewProfileView: View {
    
    @EnvironmentObject var storeArtistContentViewModel: StoreArtistContentViewModel
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var artistCollectionViewModel = ArtistCollectionViewModel()
    @StateObject var playerViewModel = PlayerViewModel()
    
    @Binding var resetToRootView: Bool
    @Binding var artist: Artist

    @State private var currentIndexForPhotos = 0
    @State private var currentIndexForVideos = 0
    @State private var isAlertDismissPresented = false
    @State private var isLinkActive = false
    @State private var selectionMediaIndex = "📸"
    @State private var mediaOptions: [String] = ["📸", "🎞️"]
    @State private var isShowing = true
    @State private var isPhotoTapped = true
    @State private var showSheet = false
    @State private var urlProfileImage = ""
    @State private var urlVideoPresentation = ""
    @State private var displayAllMedia = false
    @State private var showArtistTabBar = false
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
                    
            VStack(alignment: .leading) {
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        artistCollectionViewModel.deleteArtContentMedia(id: authentificationViewModel.userInAuthentification.id ?? "", nbOfPhotos: storeArtistContentViewModel.numberOfPhotos, nbOfVideos: storeArtistContentViewModel.numberOfVideos)
                    }, label: {
                        HStack(spacing: -12) {
                            BackwardChevron()
                                .padding()
                            
                            Text("Back")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                    }).alert(isPresented: $isAlertDismissPresented) {
                        Alert(
                            title: Text("You are about to undo current artist form."),
                            message: .none,
                            primaryButton: .destructive(Text("Confirm")) {
                                self.resetToRootView = false
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isAlertDismissPresented.toggle()
                    }, label: {
                        Image(systemName: "clear")
                            .foregroundColor(.black)
                            .opacity(0.8)
                            .padding()
                    })
                }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                
                ScrollView {
                    
                    VStack {
                        
                        ZStack {
      
                            List {
        
                                TabView(selection: $currentIndexForPhotos) {
                                    
                                    ForEach(0..<storeArtistContentViewModel.numberOfPhotos) { index in
                                            
                                        AnimatedImage(url: URL(string: storeArtistContentViewModel.urlArrayForPhotos[index])!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 350)
                                            .scaleEffect(anchor: .center)
                                    }
                                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                    .ignoresSafeArea()
                            }.ignoresSafeArea()
                            .isHidden(storeArtistContentViewModel.numberOfPhotos == 0 || !isPhotoTapped ? true : false)
                            .onAppear(perform: {
                                UITableView.appearance().separatorStyle = .none
                                UITableView.appearance().backgroundColor = .white
                            })
                            .frame(height: 350)
                            .environment(\.defaultMinListRowHeight, 250)
                            
                            List {
                    
                                TabView(selection: $currentIndexForVideos) {
                                        
                                    ForEach(0..<storeArtistContentViewModel.numberOfVideos) { index in
                                            
                                        VideoPlayer(player: playerViewModel.player)
                                            .onAppear {
                                                playerViewModel.player = AVPlayer(url: URL(string: storeArtistContentViewModel.urlArrayForVideos[index])!)
                                            }
                                    }
                                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            }.isHidden(storeArtistContentViewModel.numberOfVideos == 0 || isPhotoTapped ? true : false)
                            .onAppear(perform: {
                                UITableView.appearance().separatorStyle = .none
                                UITableView.appearance().backgroundColor = .white
                            })
                            .frame(height: 350)
                            .environment(\.defaultMinListRowHeight, 250)
                        }.padding(.top, -50)
                        
                        VStack {
                            
                            HStack {
                                
                                Text(isPhotoTapped ? "\(String(currentIndexForPhotos + 1))/\(String(storeArtistContentViewModel.numberOfPhotos))" : "\(String(currentIndexForVideos + 1))/\(String(storeArtistContentViewModel.numberOfVideos))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                                    
                            HStack {
                                
                                Button {
                                    currentIndexForPhotos = 0
                                    playerViewModel.player.pause()
                                    isPhotoTapped = true
                                } label: {
                                    MediaLabelForReviewProfileView(icon: "📸", isPhotoTapped: isPhotoTapped)
                                }
                                
                                Spacer()
                                
                                Button {
                                    currentIndexForVideos = 0
                                    playerViewModel.player.pause()
                                    isPhotoTapped = false
                                } label: {
                                    MediaLabelForReviewProfileView(icon: "🎞️", isPhotoTapped: !isPhotoTapped)
                                }
                            }
                            .padding(.horizontal, displayAllMedia ? 1 : -20)
                            .isHidden(displayAllMedia ? false : true)
                        }.padding(.top, -70)
                        .padding(.horizontal, 25)
                    }
                    
                    VStack(spacing: 22) {
                        
                        HStack {
                    
                            Text(artist.headline)
                                .font(.system(size: 21)).bold()
                        
                                Spacer()
                            
                            Button {
                                showSheet = true
                            } label: {
                                ZStack {
                                    AnimatedImage(url: URL(string: urlProfileImage))
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .isHidden(storeArtistContentViewModel.hasUploadedProfilePhoto ? false : true)
                                    
                                    Image(systemName: "play.fill")
                                        .foregroundColor(storeArtistContentViewModel.hasUploadedProfilePhoto ? .white : .black)
                                        .opacity(0.7)
                                        .isHidden(storeArtistContentViewModel.hasUploadedPresentationVideo ? false : true)
                                }
                            }.disabled(storeArtistContentViewModel.hasUploadedPresentationVideo ? false : true)
                            .padding(.top, 8)
                        }.padding(.top, 18)
                        
                        Divider()
                        
                        HStack {
                            Text(artist.textPresentation)
                            
                            Spacer()
                        }
                        
                        Divider()
                        
                        VStack(spacing: 10) {
                            
                            DisplayInformationInReviewProfileView(text: Text("Location"))
                                .font(.headline)
                               
                            DisplayInformationInReviewProfileView(text: Text(artist.address))
                                .font(.system(size: 18))
                                .padding(.top, 6)
                            
                            DisplayInformationInReviewProfileView(text: Text("We'll only share your address with guests who are booked as outlined in our ").font(.footnote) + Text("privacy policy.").underline()).font(.footnote)

                        }
                    }.padding(.vertical, displayAllMedia ? -6 : -62)
                    .padding(.horizontal, 25)
                }
                
                VStack {
                    
                    Divider()
                
                    HStack {
                    
                        Spacer()
                        
                        Button(action: {
                            self.showArtistTabBar = true
                        }, label: {
                            ReviewAndSaveButtonForArtistForm(text: "Save profile")
                        })
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 19))
                }
            }.sheet(isPresented: $showSheet, content: {
                DisplayVideoPresentationView(urlVideoPresentation: $urlVideoPresentation)
            })
        }.onAppear(perform: {
            artistCollectionViewModel.downloadProfileImage(id: authentificationViewModel.userInAuthentification.id ?? "") { result in
                switch result {
                case .success(let url):
                    urlProfileImage = url
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            artistCollectionViewModel.downloadPresentationVideo(id: authentificationViewModel.userInAuthentification.id ?? "") { result in
                switch result {
                case .success(let url):
                    urlVideoPresentation = url
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            if storeArtistContentViewModel.numberOfPhotos > 0 && storeArtistContentViewModel.numberOfVideos > 0 {
                displayAllMedia = true
            }
            
            if storeArtistContentViewModel.numberOfPhotos == 0 && storeArtistContentViewModel.numberOfVideos > 0 {
                isPhotoTapped = false
            }
        })
        .fullScreenCover(isPresented: $showArtistTabBar, content: {
            ArtistTabView.init()
        })
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct ReviewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewProfileView(resetToRootView: .constant(false), artist: .constant(Artist(art: "", place: "", address: "", headline: "", textPresentation: "")))
            .environmentObject(StoreArtistContentViewModel())
            .environmentObject(AuthentificationViewModel())
    }
}

struct DisplayVideoPresentationView: View {
    
    @EnvironmentObject var storeArtistContentViewModel: StoreArtistContentViewModel
    
    @Binding var urlVideoPresentation: String
    
    var body: some View {
        ZStack {
            VideoPlayer(player: AVPlayer(url: URL(string: urlVideoPresentation)!))
        }
    }
}

class PlayerViewModel: ObservableObject {
    @Published var player = AVPlayer()
}

struct MediaLabelForReviewProfileView: View {
    
    var icon: String
    var isPhotoTapped: Bool
    
    var body: some View {
        Text(icon)
            .padding(.vertical, 10)
            .padding(.horizontal, UIScreen.main.bounds.width / 5.5)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.lightGrayForBackground, lineWidth: 3))
            .background(isPhotoTapped ? Color.white : Color.lightGrayForBackground)
    }
}

struct DisplayInformationInReviewProfileView: View {
    
    var text: Text
    
    var body: some View {
        HStack {
            text
            
            Spacer()
        }
    }
}
