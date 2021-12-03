//
//  PersonalInformationView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 08/09/2021.
//

import SwiftUI

struct PersonalInformationView: View {
    
    @StateObject var userCollectionViewModel = UserCollectionViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthdate = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var genderIsShown = false
    @Binding var updatedFirstName: String
    
    @State private var lastSelectedIndex: Int?
    
    let genderArray = ["Not specified", "Male", "Female", "Other"]
    
    var btnBack : some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            BackwardChevron()
        }
    }
    
    var body: some View {
        
        NavigationView {
        
            ScrollView {
                
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "First name")
                            
                    CustomTextfieldForProfile(bindingText: $firstName, text: firstName, textFromDb: userCollectionViewModel.userSwart.firstName)
                        .textContentType(.givenName)
                        .autocapitalization(.words)
                }.padding()
                    
                Divider()
                        
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "Last name")
                                
                    CustomTextfieldForProfile(bindingText: $lastName, text: lastName, textFromDb: userCollectionViewModel.userSwart.lastName)
                        .textContentType(.givenName)
                        .autocapitalization(.words)
                    }.padding()
                                
                Divider()
                        
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "Birth date (MM/DD/YYYY)")
                                
                    CustomTextfieldForProfile(bindingText: $birthdate, text: birthdate, textFromDb: userCollectionViewModel.userSwart.birthdate)
                    }.padding()
                        
                Divider()
                        
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "Email")
                    
                    CustomTextfieldForProfile(bindingText: $email, text: email, textFromDb: userCollectionViewModel.userSwart.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }.padding()
                        
                Divider()
                
            .navigationBarTitle("Edit personal info")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            }.toolbar {
                Button(action: {
                    
                    let user = User(id: authentificationViewModel.userInAuthentification.id, firstName: getRightPersoInfo(firstName, userCollectionViewModel.userSwart.firstName), lastName: getRightPersoInfo(lastName, userCollectionViewModel.userSwart.lastName), birthdate: getRightPersoInfo(birthdate, userCollectionViewModel.userSwart.birthdate), email: getRightPersoInfo(email, userCollectionViewModel.userSwart.email))
                    
                    userCollectionViewModel.addToUserCollection(id: authentificationViewModel.userInAuthentification.id ?? "", user: user)
                    updatedFirstName = firstName
                }, label: {
                    Text("Save")
                })
            }.onAppear(perform: {
                userCollectionViewModel.get(documentPath: authentificationViewModel.userInAuthentification.id ?? "")
            })
        }
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
        PersonalInformationView(updatedFirstName: .constant(""))
    }
}
