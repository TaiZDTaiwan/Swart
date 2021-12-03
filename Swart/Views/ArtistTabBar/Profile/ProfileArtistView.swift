//
//  ProfileArtistView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 01/12/2021.
//

import SwiftUI

struct ProfileArtistView: View {
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 30) {
                        
                    Text("ARTIST")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()
                    
                    VStack(spacing: 28) {
                        
                        NavigationLink(destination: NotificationsView()) {
                            
                            HStack {
                                
                                Image(systemName: "paintbrush.pointed")
                                    .foregroundColor(.black)
                                
                                Text("My Arts")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                    
                        NavigationLink(destination: NotificationsView()) {
                            
                            HStack {
                                
                                Image(systemName: "plus.app")
                                    .foregroundColor(.black)
                                
                                Text("Create a new art listing")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }.padding(.vertical, 30)
                .padding(.horizontal, 22)
                
                Divider()
                    .padding(.horizontal, 15)
                
                VStack(alignment: .leading, spacing: 30) {
                        
                    Text("ACCOUNT")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()
                    
                    VStack(spacing: 28) {
                        
                        NavigationLink(destination: NotificationsView()) {
                            
                            HStack {
                                
                                Image(systemName: "person")
                                    .foregroundColor(.black)
                                
                                Text("Your profile")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                    
                        NavigationLink(destination: NotificationsView()) {
                            
                            HStack {
                                
                                Image(systemName: "gearshape")
                                    .foregroundColor(.black)
                                
                                Text("Settings")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            
                            HStack {
                                
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.black)
                                
                                Text("Get help")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            
                            HStack {
                                
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.black)
                                
                                Text("Explore hosting ressources")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            
                            HStack {
                                
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.black)
                                
                                Text("Visit our community forum")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            
                            HStack {
                                
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.black)
                                
                                Text("Give us feedback")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            
                            HStack {
                                
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.black)
                                
                                Text("Refer a host")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }.padding(.vertical, 30)
                .padding(.horizontal, 22)
                
                Divider()
                    .padding(.horizontal, 15)
                
                VStack(spacing: 20) {
                    
                    NavigationLink(destination: NotificationsView()) {
                    
                        Text("Switch to user mode")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black, lineWidth: 1))
                    }
                    
                    NavigationLink(destination: NotificationsView()) {
                    
                        Text("Log out")
                            .font(.system(size: 20))
                            .foregroundColor(.white).bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.mainRed))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.mainRed, lineWidth: 1))
                    }
                }.padding(.vertical, 30)
                .padding(.horizontal, 30)
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileArtistView()
    }
}
