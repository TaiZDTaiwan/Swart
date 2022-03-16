//
//  SearchArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 04/01/2022.
//

import SwiftUI

struct SearchArtistView: View {
    
    @State private var showSheet = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                VStack {
                    Image("SearchBackground")
                        .resizable()
                        .edgesIgnoringSafeArea(.top)
                        .scaledToFill()
                    
                    Spacer()
                }
                
                VStack {
                            
                    Button {
                        showSheet = true
                            
                    } label: {
                                
                        ZStack {
                                    
                            RoundedRectangle(cornerRadius: 18)
                                .frame(height: 45)
                                .frame(width: UIScreen.main.bounds.width - 50)
                                .foregroundColor(.white)
                                      
                            HStack {
                                        
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.mainRed)
                                    .font(.title2)
                                            
                                Text("What do you want to discover?")
                                    .foregroundColor(.black)
                                    .font(.system(size: 17)).bold()
                            }
                        }
                    }
                    Spacer()
                }.padding(.vertical, 20)
                .fullScreenCover(isPresented: $showSheet, content: {
                    SelectArtView()
                })
            }.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}

struct SearchArtistView_Previews: PreviewProvider {
    static var previews: some View {
        SearchArtistView()
    }
}