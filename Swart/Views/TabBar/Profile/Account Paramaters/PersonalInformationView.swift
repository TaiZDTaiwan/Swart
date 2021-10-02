//
//  PersonalInformationView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 08/09/2021.
//

import SwiftUI

struct PersonalInformationView: View {
    
    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    @StateObject var userRepositoryViewModel = UserRepositoryViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthdate = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var genderIsShown = false
    
    @State private var lastSelectedIndex: Int?
    
    let genderArray = ["Not specified", "Male", "Female", "Other"]
    
    var btnBack : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .opacity(0.7)
                }
            }
        }
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                Text("First name")
                    .bold()
                    .font(.system(size: 12))
                        
                TextField("", text: $firstName)
                    .placeholder(when: firstName.isEmpty) {
                        Text(userRepositoryViewModel.userSwart.firstName).foregroundColor(.black)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }
            }.padding()
                
            Divider()
                    
            VStack(alignment: .leading) {
                Text("Last name")
                    .bold()
                    .font(.system(size: 12))
                            
                TextField("", text: $lastName)
                    .placeholder(when: lastName.isEmpty) {
                        Text(userRepositoryViewModel.userSwart.lastName).foregroundColor(.black)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }
                }.padding()
                            
            Divider()
                    
            VStack(alignment: .leading) {
                Text("Birth date (MM/DD/YYYY)")
                    .bold()
                    .font(.system(size: 12))
                            
                TextField("", text: $birthdate)
                    .placeholder(when: birthdate.isEmpty) {
                        Text(userRepositoryViewModel.userSwart.birthdate).foregroundColor(.black)
                    }
                }.padding()
                    
            Divider()
                    
            VStack(alignment: .leading) {
                Text("Email")
                    .bold()
                    .font(.system(size: 12))
                
                        
                TextField("", text: $email)
                    .placeholder(when: email.isEmpty) {
                        Text(userRepositoryViewModel.userSwart.email).foregroundColor(.black)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                    }
                }.padding()
                    
            Divider()
                    
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        }.toolbar {
            Button(action: {
                
                let user = UserSwart(id: authentificationViewModel.userInAuthentification.id, firstName: getRightPersoInfo(firstName, userRepositoryViewModel.userSwart.firstName), lastName: getRightPersoInfo(lastName, userRepositoryViewModel.userSwart.lastName), birthdate: getRightPersoInfo(birthdate, userRepositoryViewModel.userSwart.birthdate), email: getRightPersoInfo(email, userRepositoryViewModel.userSwart.email))
                
                userRepositoryViewModel.saveUserInfoToDatabase(id: authentificationViewModel.userInAuthentification.id ?? "", user: user)
            }, label: {
                Text("Save")
            })
        }.onAppear(perform: {
            userRepositoryViewModel.get(documentPath: authentificationViewModel.userInAuthentification.id ?? "")
        })
    }
    
    private func getRightPersoInfo(_ info: String, _ placeholder: String) -> String {
        if info == "" {
            return placeholder
        } else {
            return info
        }
    }
}

struct PersonalInformationView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInformationView()
    }
}
