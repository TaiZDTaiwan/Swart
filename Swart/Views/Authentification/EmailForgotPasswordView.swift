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
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var email = ""
    
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var isLoading = false

    var body: some View {
        
        ZStack {
            Color(.white)
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
            
            VStack(spacing: 25) {
                
                TextField("Email", text: $email)
                    .font(.title3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress).autocapitalization(.none)
                    .disableAutocorrection(true)
                    .isHidden(isLoading ? true : false)
                
                Button(action: {
                    authentificationViewModel.forgotPassword(email: email) { result in
                        switch result {
                        case .success(let message):
                            alertMessage = message
                        case .failure(let error):
                            alertMessage = error.localizedDescription
                        }
                        isAlertPresented = true
                    }
                }, label: {
                    CustomTextForSmallButton(text: "Send")
                        .isHidden(isLoading ? true : false)
                })
                Spacer()
            }.padding()
        }.navigationBarTitle("Forgot password?", displayMode: .large)
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text(alertMessage), message: .none, dismissButton: .default(Text("OK"), action: {
                if alertMessage == "A link to restaure your password has been sent to your mailbox." {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        )}
    }
}

struct EmailForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmailForgotPasswordView()
        }
    }
}
