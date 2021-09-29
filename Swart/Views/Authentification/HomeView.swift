//
//  HomeView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 23/09/2021.
//

import SwiftUI

import SwiftUI
import Firebase
import AuthenticationServices

struct HomeView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color(#colorLiteral(red: 0.06274509804, green: 0, blue: 0.1921568627, alpha: 1)))]
        UINavigationBar.appearance().barTintColor = UIColor(Color(#colorLiteral(red: 0.9674224257, green: 0.9616711736, blue: 0.971843183, alpha: 1)))
        UINavigationBar.appearance().tintColor = UIColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))

    }
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @State private var showLogInSheetView = false

    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9607843137, green: 0.1764705882, blue: 0.2901960784, alpha: 1)), Color(#colorLiteral(red: 0.8551853299, green: 0.8111677766, blue: 0.07408294827, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    
                VStack(spacing: 35) {
                        
                    Spacer()
                        
                    Text("Swart")
                        .font(.custom("AmericanTypewriter", size: 60))
                        .fontWeight(.regular)
                        .font(.largeTitle)
                        .foregroundColor(Color(#colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.9607843137, alpha: 1)))
                        
                    VStack {
                        Button(action: {
                            showLogInSheetView.toggle()
                        }, label: {
                            Text("Create a new account")
                                .frame(width: UIScreen.main.bounds.size.width * 3/4, height: 10, alignment: .center)
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                        .opacity(0.7)
                                        
                                )
                        }).sheet(isPresented: $showLogInSheetView, content: {
                            CreateAccountView(showLogInSheetView: $showLogInSheetView)
                        })
                            
                        NavigationLink(destination: LogInView()
                                        .navigationBarTitle("", displayMode: .inline)) {
                        
                            Text("Log In")
                                .font(.system(size: 19))
                                .foregroundColor(Color(#colorLiteral(red: 0.1025790051, green: 0, blue: 0.3525151312, alpha: 1)))
                                .padding()
                        }
                    }
                    Spacer()
                }
            }.navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
