//
//  UserTabView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 05/09/2021.
//

import SwiftUI

struct UserTabView: View {
    
    @ObservedObject var userCollectionViewModel: UserCollectionViewModel
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    init(userRepositoryViewModel: UserCollectionViewModel) {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .gray
        _userCollectionViewModel = .init(initialValue: userRepositoryViewModel)
    }
    
    func test() {
        userCollectionViewModel.get(documentPath: authentificationViewModel.userInAuthentification.id ?? "")
        print(userCollectionViewModel.userSwart.email)
    }
    
    var body: some View {
        TabView {
        
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
            }
            
            Text("Favorite")
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorite")
            }
            
            Text("Experiences")
                .tabItem {
                    Image(systemName: "wand.and.stars")
                    Text("Experiences")
            }
            
            Text("Messages")
                .tabItem {
                    Image(systemName: "bubble.right")
                    Text("Messages")
            }
            
            ProfileUserView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView(userRepositoryViewModel: UserCollectionViewModel())
    }
}
