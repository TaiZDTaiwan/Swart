//
//  ArtistTabView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/12/2021.
//

import SwiftUI

struct ArtistTabView: View {
    var body: some View {
        
        TabView {
            Text("Today")
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Today")
            }
            
            Text("Inbox")
                .tabItem {
                    Image(systemName: "bubble.left")
                    Text("Inbox")
            }
            
            Text("Calendar")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
            }
            
            Text("Insights")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Insights")
            }
            
            ProfileArtistView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
            }
        }
    }
}

struct ArtistTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistTabView()
    }
}
