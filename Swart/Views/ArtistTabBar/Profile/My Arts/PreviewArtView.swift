//
//  PreviewArtView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 03/12/2021.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI

struct PreviewArtView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var artistCollectionViewModel: ArtistCollectionViewModel
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
                    
            VStack(alignment: .leading) {
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    BackwardChevron()
                        .padding()
                })
                
                CustomScrollViewToPreviewArtist(artContentMedia: artistCollectionViewModel.artist.artContentMedia, headline: artistCollectionViewModel.artist.headline, profilePhoto: artistCollectionViewModel.artist.profilePhoto, presentationVideo: artistCollectionViewModel.artist.presentationVideo, textPresentation: artistCollectionViewModel.artist.textPresentation, address: artistCollectionViewModel.artist.address)
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
