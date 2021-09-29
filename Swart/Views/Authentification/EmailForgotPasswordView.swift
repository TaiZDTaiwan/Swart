//
//  EmailForgotPasswordView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 15/08/2021.
//

import SwiftUI
import Firebase
import ActivityIndicatorView

struct EmailForgotPasswordView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var email = ""
    
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var isLoading = false

    var body: some View {
        
        ZStack {
            Color(.white)
            
            GeometryReader { geometry in
                ActivityIndicatorView(isVisible: $isLoading, type: .flickeringDots)
                    .foregroundColor(Color(#colorLiteral(red: 0.5565254092, green: 0.5570400953, blue: 0.5776087046, alpha: 1)))
                    .frame(width: 80, height: 80, alignment: .center)
                    .opacity(0.8)
                    .isHidden(isLoading ? false : true)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            
            VStack(spacing: 25) {
                
                TextField("Email", text: $email)
                    .font(.title3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress).autocapitalization(.none)
                    .disableAutocorrection(true)
                    .isHidden(isLoading ? true : false)
                
                Button(action: {
                    forgotPassword(for: email)
                }, label: {
                    Text("Send")
                        .frame(width: UIScreen.main.bounds.size.width/4, height: 20, alignment: .center)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                .opacity(0.7))
                        .isHidden(isLoading ? true : false)
                })
                Spacer()
            }.padding()
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text(alertMessage), message: .none, dismissButton: .default(Text("OK"), action: {
                if isLoading {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        )}
    }
    
    private func forgotPassword(for email: String)  {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                alertMessage = error!.localizedDescription
                isAlertPresented = true
            } else {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    alertMessage = "Mot de passe envoyé"
                    isAlertPresented = true
                }
            }
        }
    }
}

struct EmailForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmailForgotPasswordView()
        }
    }
}
