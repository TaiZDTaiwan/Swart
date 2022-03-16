//
//  WishlistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 29/01/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

struct WishlistView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @StateObject var addressViewModel = AddressViewModel()
    
    @ObservedObject var wishlistViewModel: WishlistViewModel
    @ObservedObject var userCollectionViewModel: UserCollectionViewModel
    
    @State private var player = AVPlayer()
    @State private var selectedArtist = Artist(id: "", art: "", place: "", address: "", department: "", headline: "", textPresentation: "", profilePhoto: "", presentationVideo: "", artContentMedia: [], blockedDates: [], pendingRequest: [], comingRequest: [], previousRequest: [])
    @State private var isPresented = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
            
                Color.white
                
                Text("No artists have been added yet")
                    .font(Font.system(size: 18).italic())
                    .foregroundColor(.black).opacity(0.9)
                    .isHidden(wishlistViewModel.wishedArtistsResult.count > 0 ? true : false)
                
                List(wishlistViewModel.wishedArtistsResult, id: \.self) { artist in
                    
                    VStack(alignment: .leading) {
                        
                        TabView {
                            
                            ForEach(artist.artContentMedia, id: \.self) { url in
                                
                                if url.contains("image") {
                                
                                    AnimatedImage(url: URL(string: url)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 335)
                                } else {
                                    VideoPlayer(player: player)
                                        .onAppear {
                                            player = AVPlayer(url: URL(string: url)!)
                                        }
                                }
                            }
                        }.tabViewStyle(PageTabViewStyle())
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text(artist.headline)
                                .foregroundColor(.black)
                                .font(.custom("ArialIMT", size: 19))
                                .lineLimit(1)
                            
                            Text("À " + addressViewModel.determineCity(address: artist.address) + " / " + addressViewModel.rewriteDepartment(department: artist.department))
                                .foregroundColor(.black).opacity(0.6)
                                .font(Font.system(size: 18).italic())
                                .lineLimit(1)
                                
                        }.padding(.horizontal, 12)
                        .padding(.top, -5)
                        
                        Spacer(minLength: 7)
                            
                    }.onTapGesture(perform: {
                        selectedArtist = artist
                        isPresented = true
                    })
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.white)
                }.isHidden(wishlistViewModel.wishedArtistsResult.count > 0 ? false : true)
                .fullScreenCover(isPresented: $isPresented, content: {
                    PreviewWishedArtistView(wishlistViewModel: wishlistViewModel, userCollectionViewModel: userCollectionViewModel, selectedArtist: $selectedArtist)
                })
                .environment(\.defaultMinListRowHeight, 315)
                .listStyle(GroupedListStyle())
                .navigationTitle("Wishlist")
            }
        }
    }
}

struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        WishlistView(wishlistViewModel: WishlistViewModel(), userCollectionViewModel: UserCollectionViewModel())
    }
}
