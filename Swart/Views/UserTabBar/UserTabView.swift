//
//  UserTabView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 05/09/2021.
//

import SwiftUI

struct UserTabView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @StateObject var userCollectionViewModel = UserCollectionViewModel()
    @StateObject var requestUserCollectionViewModel = RequestUserCollectionViewModel()
    @StateObject var wishlistViewModel = WishlistViewModel()
    
    @State var fromTabBar = true

    var body: some View {
        
        TabView {
        
            SearchArtistView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
            }
            
            WishlistView(wishlistViewModel: wishlistViewModel, userCollectionViewModel: userCollectionViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Wishlist")
            }
            
            ExperiencesView(userCollectionViewModel: userCollectionViewModel, requestUserCollectionViewModel: requestUserCollectionViewModel)
                .tabItem {
                    Image(systemName: "wand.and.stars")
                    Text("Experiences")
            }
            
            ProfileUserView(userCollectionViewModel: userCollectionViewModel)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
            }
        }.accentColor(.mainRed)
        .onAppear {
            userCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                for wish in userCollectionViewModel.user.wishlist {
                    wishlistViewModel.getArtistsInWishlist(documentId: wish)
                }
                
                requestUserCollectionViewModel.getRequests(pendingRequest: userCollectionViewModel.user.pendingRequest, comingRequest: userCollectionViewModel.user.comingRequest, previousRequest: userCollectionViewModel.user.previousRequest, documentId: authentificationViewModel.userId.id ?? "") {
                    userCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                        requestUserCollectionViewModel.retrieveRequests(pendingRequest: userCollectionViewModel.user.pendingRequest, comingRequest: userCollectionViewModel.user.comingRequest, previousRequest: userCollectionViewModel.user.previousRequest)
                    }
                }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView()
    }
}
