//
//  HomeView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 23/09/2021.
//

import SwiftUI
import Firebase
import AuthenticationServices

struct HomeView: View {
    
    init() {
        UINavigationBar.appearance().tintColor = UIColor(.black)
    }
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @State private var showLogInSheetView = false

    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.7142756581, blue: 0.59502846, alpha: 1)), Color(#colorLiteral(red: 0.7496727109, green: 0.1164080873, blue: 0.1838892698, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    
                VStack(spacing: 35) {
                        
                    Spacer()
                        
                    Text("Swart")
                        .font(.custom("AmericanTypewriter", size: 60))
                        .fontWeight(.regular)
                        .font(.largeTitle)
                        .foregroundColor(.swartWhite)
                        
                    VStack {
                        Button(action: {
                            showLogInSheetView.toggle()
                        }, label: {
                            CustomTextForButton(text: "Create a new account")
                            
                        }).sheet(isPresented: $showLogInSheetView, content: {
                            CreateAccountView(showLogInSheetView: $showLogInSheetView)
                        })
                            
                        NavigationLink(destination: LogInView()
                                        .navigationBarTitle("", displayMode: .inline)) {
                        
                            Text("Log In")
                                .font(.system(size: 19))
                                .foregroundColor(.black).opacity(0.8)
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

struct CustomTextForButton: View {
    var text: String
    
    var body: some View {
        Text(text)
            .frame(width: UIScreen.main.bounds.size.width * 3/4, height: 10, alignment: .center)
            .font(.system(size: 17))
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.lightBlack))
    }
}
