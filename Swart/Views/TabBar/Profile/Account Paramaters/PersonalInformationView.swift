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
    @State private var genderIndex = ""
    
    let gender = ["Not specified", "Male", "Female", "Other"]
    
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
            
            Spacer(minLength: 25)
        
            VStack(alignment: .leading) {
                Text("First name")
                    .bold()
                    .font(.system(size: 10))
                
                TextEditor(text: $firstName)
                    .font(.system(.body))
                    .textFieldStyle(PlainTextFieldStyle())
                    .textContentType(.name)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .font(Font.headline.weight(.black))
            }.padding()
        
            Divider()
            
            VStack(alignment: .leading) {
                Text("Last name")
                    .bold()
                    .font(.system(size: 12))
                    
                TextField("", text: $lastName)
                    .placeholder(when: lastName.isEmpty) {
                        Text(userRepositoryViewModel.userSwart.firstName).foregroundColor(.black)
                    }
                }.padding()
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Gender")
                    .bold()
                
                NavigationView {
                    Form {
                        Section {
                            Picker(selection: $genderIndex, label: Text("Gender")) {
                                ForEach(0 ..< gender.count) {
                                    Text(self.gender[$0]).tag($0)
                                }
                            }
                        }
                    }
                }
            }.padding()
            Spacer()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
        }.toolbar {
            Button(action: {
                userRepositoryViewModel.fetchDataToDb(id: authentificationViewModel.userInAuthentification.id, firstName: firstName, lastName: lastName)
            }, label: {
                Text("Save")
            })
        }.onAppear(perform: {
            
            userRepositoryViewModel.get(documentPath: authentificationViewModel.userInAuthentification.id ?? "")
            print(userRepositoryViewModel.userSwart.firstName)
            firstName = userRepositoryViewModel.userSwart.firstName
            
        })
    }
}

struct PersonalInformationView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInformationView()
    }
}
