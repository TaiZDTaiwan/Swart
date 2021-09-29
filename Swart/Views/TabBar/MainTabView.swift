//
//  MainTabView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 05/09/2021.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var userRepositoryViewModel: UserRepositoryViewModel
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    init(userRepositoryViewModel: UserRepositoryViewModel) {
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .gray
        _userRepositoryViewModel = .init(initialValue: userRepositoryViewModel)
    }
    
    func test() {
        userRepositoryViewModel.get(documentPath: authentificationViewModel.userInAuthentification.id ?? "")
        print(userRepositoryViewModel.userSwart.email)
    }
    
    var body: some View {
        TabView {
            Button(action: {
                test()
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
            }
            
            Text("Favorite")
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorite")
                        .foregroundColor(.red)
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
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(userRepositoryViewModel: UserRepositoryViewModel())
    }
}
