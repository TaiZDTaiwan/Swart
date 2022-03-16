//
//  ArtistTabView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/12/2021.
//

import SwiftUI

struct ArtistTabView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @StateObject var artistCollectionViewModel = ArtistCollectionViewModel()
    @StateObject var requestArtistCollectionViewModel = RequestArtistCollectionViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    
    var body: some View {
        
        ZStack {
            
            TabView {
                ExperiencesArtistView(artistCollectionViewModel: artistCollectionViewModel, requestArtistCollectionViewModel: requestArtistCollectionViewModel)
                    .tabItem {
                        Image(systemName: "music.mic")
                        Text("Perfomances")
                }
            
                CalendarView(calendarViewModel: calendarViewModel)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                }
                
                ProfileArtistView(artistCollectionViewModel: artistCollectionViewModel)
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                }
            }.accentColor(.mainRed)
        }.onAppear {
            calendarViewModel.getBlockedDates(documentId: authentificationViewModel.userId.id ?? "")
            artistCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                requestArtistCollectionViewModel.getRequests(pendingRequest: artistCollectionViewModel.artist.pendingRequest, comingRequest: artistCollectionViewModel.artist.comingRequest, previousRequest: artistCollectionViewModel.artist.previousRequest, documentId: authentificationViewModel.userId.id ?? "") {
                    artistCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                        requestArtistCollectionViewModel.retrieveRequests(pendingRequest: artistCollectionViewModel.artist.pendingRequest, comingRequest: artistCollectionViewModel.artist.comingRequest, previousRequest: artistCollectionViewModel.artist.previousRequest)
                    }
                }
            }
        }
    }
}

struct ArtistTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistTabView()
    }
}
