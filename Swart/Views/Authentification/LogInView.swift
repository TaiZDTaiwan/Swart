//
//  LogInView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 23/09/2021.
//

import SwiftUI
import Firebase
import AuthenticationServices

struct LogInView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var user: User?
    @State private var showMain = false
    
    @State private var isAlertPresented = false
    @State private var alertMessage = ""

    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9607843137, green: 0.1764705882, blue: 0.2901960784, alpha: 1)), Color(#colorLiteral(red: 0.8551853299, green: 0.8111677766, blue: 0.07408294827, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
            VStack(spacing: 20) {
                    
                Spacer()
                    
                Text("Swart")
                    .font(.custom("AmericanTypewriter", size: 60))
                    .fontWeight(.regular)
                    .font(.largeTitle)
                    .foregroundColor(Color(#colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.9607843137, alpha: 1)))
                    
                VStack(alignment: .trailing) {
                        
                    VStack(spacing: 15) {
                            
                        TextField("Email Address", text: $email)
                            .font(.system(.body))
                            .background(Color.gray.opacity(0.1))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            
                        SecureField("Password", text: $password)
                            .font(.system(.body))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.password)
                            .disableAutocorrection(true)
                    }
                         
                        NavigationLink(
                            destination: EmailForgotPasswordView()
                                .navigationBarTitle("Forgot password?", displayMode: .large)) {
                            
                            Text("Forgot password?").bold()
                                .font(.system(size: 15))
                                .frame(width: UIScreen.main.bounds.size.width/2, height: 20, alignment: .trailing)
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    
                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
                        if error != nil {
                            alertMessage = error!.localizedDescription
                            isAlertPresented = true
                        } else {
                            if let user = authDataResult?.user {
                                authentificationViewModel.userInAuthentification.id = user.uid
                                self.showMain = true
                            }
                        }
                    }
                }, label: {
                    Text("Log In")
                        .frame(width: UIScreen.main.bounds.size.width/4, height: 20, alignment: .center)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                .opacity(0.7)
                        )
                })
                .fullScreenCover(isPresented: $showMain, content: {
                    MainTabView.init(userRepositoryViewModel: UserRepositoryViewModel())
                })
                
                Spacer()
            }.padding(35)
        }.alert(isPresented: $isAlertPresented, content: {
            Alert(title: Text(alertMessage))
        })
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
