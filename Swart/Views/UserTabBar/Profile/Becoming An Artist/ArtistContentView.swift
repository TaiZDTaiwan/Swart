//
//  ArtisticalContentView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/11/2021.
//

import SwiftUI
import AVKit
import PhotosUI
import FirebaseStorage
import ActivityIndicatorView

struct ArtistContentView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    @EnvironmentObject var storeArtistContentViewModel: StoreArtistContentViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var artistCollectionViewModel = ArtistCollectionViewModel()
    @ObservedObject var mediaItems = PickedMediaItems()

    @Binding var resetToRootView: Bool
    
    @State var filter: PHPickerFilter = .any(of: [.images, .livePhotos, .videos])
    @State var selectionLimit = 0
    @State private var showSheet = false
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isPresented = false
    @State private var isEditing = false
    @State private var image = UIImage()
    @State private var isLoading = false
    @State private var downloadedPercentage = 0.0
    @State private var percentageToAdd = 0.0
    @State private var downloadIsOver = false
    @State private var artist = Artist(art: "", place: "", address: "", headline: "", textPresentation: "")
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            
            BackgroundForArtistForm()
                
                GeometryReader { geometry in
                    
                    ProgressView("Downloading…", value: downloadedPercentage)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .onReceive(timer) { _ in
                            if isLoading {
                                if percentageToAdd < 1 {
                                    downloadedPercentage = percentageToAdd
                                } else if downloadIsOver {
                                    downloadedPercentage = 1
                                }
                            }
                        }
                }.isHidden(isLoading ? false : true)
                .progressViewStyle(CustomCircularProgressViewStyle())
                    
            VStack(alignment: .leading) {
                
                HStack {
                    BackButtonForArtistForm(presentationMode: _presentationMode)
                    
                    Spacer()
                    
                    if mediaItems.items.isEmpty {
                        DismissButtonForArtistForm(isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                    } else {
                        EditButton()
                            .foregroundColor(.black)
                            .padding()
                    }
                }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                
                Spacer()
                
                VStack(alignment: .leading, spacing: -20) {
                    
                    TitleForArtistForm(text: "Finally, let us admire your art!")
                    
                    CaptionForArtistForm(text: "Add at least 5 photos or videos in your chosen order which describe your artistical talent the best")
                }
                
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                
                    VStack {
                    
                        ZStack {
                            
                            Color.lightGrayForBackground
                            
                            Image("ArtBackground")
                                .resizable()
                                .isHidden(mediaItems.items.isEmpty ? false : true)
                            
                            List {
                                
                                ForEach(mediaItems.items, id: \.id) { item in
                                  
                                    if item.mediaType == .photo {
                                        Image(uiImage: item.photo ?? UIImage())
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 200)
                                            .scaleEffect(anchor: .center)
                                    } else if item.mediaType == .video {
                                        if let url = item.url {
                                            VideoPlayer(player: AVPlayer(url: url))
                                                .frame(height: 200)
                                        } else { EmptyView() }
                                    } else {
                                        if let livePhoto = item.livePhoto {
                                            LivePhotoView(livePhoto: livePhoto)
                                                .frame(height: 200)
                                        } else { EmptyView() }
                                    }
                                }.onMove(perform: move)
                                .onDelete(perform: mediaItems.deleteItemAtGivenIndex)
                                .onLongPressGesture {
                                    withAnimation {
                                        isEditing = true
                                    }
                                }
                            }.frame(width: UIScreen.main.bounds.size.width - 35)
                            .isHidden(mediaItems.items.isEmpty ? true : false)
                            .sheet(isPresented: $showSheet, content: {
                                PhotoPicker(mediaItems: mediaItems, filter: $filter, selectionLimit: $selectionLimit) { _ in
                                    showSheet = false
                                }
                            })
                        }
                    
                        HStack {
                            
                            Button {
                                showSheet = true
                            } label: {
                                ImageForVideoPresentationView(text: "plus")
                                    .foregroundColor(.black)
                            }

                            Spacer()
                            
                            NavigationLink(destination: ReviewProfileView(resetToRootView: $resetToRootView, artist: $artist), isActive: $isLinkActive) {
                                Button(action: {
                                 
                                    isLoading = true
                                    
                                    let firstGroup = DispatchGroup()
                                    
                                    for element in mediaItems.items {
                                        if element.mediaType == .video {
                                            storeArtistContentViewModel.numberOfVideos += 1
                                            firstGroup.enter()
                                            artistCollectionViewModel.uploadArtContentVideos(url: element.url ?? URL(fileURLWithPath: ""), id: authentificationViewModel.userInAuthentification.id ?? "", fileName: "video_" + "\(storeArtistContentViewModel.numberOfVideos)") { result in
                                                switch result {
                                                case .success(let success):
                                                    print(success)
                                                    percentageToAdd += 1 / Double(mediaItems.items.count)
                                                    firstGroup.leave()
                                                case .failure(let error):
                                                    print(error.localizedDescription)
                                                }
                                            }
                                            if let urlConverted = element.url {
                                                storeArtistContentViewModel.urlArrayForVideos.append(urlConverted.absoluteString)
                                            }
                                        } else {
                                            storeArtistContentViewModel.numberOfPhotos += 1
                                            firstGroup.enter()
                                            artistCollectionViewModel.uploadArtContentImages(image: element.photo ?? UIImage(), id: authentificationViewModel.userInAuthentification.id ?? "", fileName: "image_" + "\(storeArtistContentViewModel.numberOfPhotos)") { result in
                                                switch result {
                                                case .success(let success):
                                                    print(success)
                                                    percentageToAdd += 1 / Double(mediaItems.items.count)
                                                    firstGroup.leave()
                                                case .failure(let error):
                                                    print(error.localizedDescription)
                                                }
                                            }
                                        }
                                    }
                                    
                                    firstGroup.notify(queue: .main) {
                                        
                                        artistCollectionViewModel.get(documentPath: authentificationViewModel.userInAuthentification.id ?? "")
                        
                                        let secondGroup = DispatchGroup()
                                            
                                        if storeArtistContentViewModel.numberOfPhotos > 0 {
                                                                
                                            for i in 1..<storeArtistContentViewModel.numberOfPhotos + 1 {
                                                secondGroup.enter()
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.7) {
                                                    
                                                    artistCollectionViewModel.downloadArtContentImages(id: authentificationViewModel.userInAuthentification.id ?? "", fileName: "image_" + "\(i)") { result in
                                                        switch result {
                                                        case .success(let url):
                                                            print("Image downloaded successfully")
                                                            storeArtistContentViewModel.urlArrayForPhotos.append(url)
                                                            secondGroup.leave()
                                                        case .failure(let error):
                                                            print(error.localizedDescription)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        secondGroup.notify(queue: .main) {
                                            
                                            artist = Artist(art: artistCollectionViewModel.artist.art, place: artistCollectionViewModel.artist.place, address: artistCollectionViewModel.artist.address, headline: artistCollectionViewModel.artist.headline, textPresentation: artistCollectionViewModel.artist.textPresentation)
                                            
                                            downloadIsOver = true

                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                isLinkActive = true
                                                isLoading = false
                                            }
                                        }
                                    }
                                }, label: {
                                    ReviewAndSaveButtonForArtistForm(text: "Review profile")
                                })
                            }.isDetailLink(false)
                            .isHidden(mediaItems.items.count > 4 ? false : true)
                        }.padding(EdgeInsets(top: 3, leading: 19, bottom: 0, trailing: 19))
                    }
                }
            }.isHidden(isLoading ? true : false)
            .sheet(isPresented: $isPresented) {
                PhotoPicker(mediaItems: mediaItems, filter: $filter, selectionLimit: $selectionLimit) { _ in
                    isPresented = false
                }
            }
        }.onAppear(perform: {
            storeArtistContentViewModel.numberOfPhotos = 0
            storeArtistContentViewModel.numberOfVideos = 0
            downloadedPercentage = 0
            percentageToAdd = 0
            downloadIsOver = false
        })
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func move(fromOffsets source: IndexSet, toOffsets destination: Int) {
        mediaItems.items.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            isEditing = false
        }
    }
}

struct ArtisticalContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistContentView(resetToRootView: .constant(false))
    }
}

struct CustomCircularProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3, dash: [10, 5]))
                .rotationEffect(.degrees(-90))
                .frame(width: 200)
            
            if let fractionCompleted = configuration.fractionCompleted {
                Text(fractionCompleted < 1 ?
                        "Completed \(Int((configuration.fractionCompleted ?? 0) * 100))%"
                        : "Done!"
                )
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .frame(width: 180)
            }
        }
    }
}
