//
//  PersonalInformationView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 08/09/2021.
//

import SwiftUI
import ActivityIndicatorView

struct PersonalInformationView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var userCollectionViewModel: UserCollectionViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isLoading = false
    @State private var isShowEditView = false
    @State private var hasEdited = false
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var btnBack : some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackwardChevron()
        }.isHidden(isLoading ? true : false)
    }
    
    var body: some View {
        
        ZStack {
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
        
            ScrollView {
                    
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "First name")
                                
                    CustomTextfieldForProfile(bindingText: $firstName, text: firstName, textFromDb: userCollectionViewModel.user.firstName)
                        .textContentType(.givenName)
                        .autocapitalization(.words)
                }.padding()
                        
                Divider()
                            
                VStack(alignment: .leading) {
                    CustomTextForProfile(text: "Last name")
                                    
                    CustomTextfieldForProfile(bindingText: $lastName, text: lastName, textFromDb: userCollectionViewModel.user.lastName)
                        .textContentType(.givenName)
                        .autocapitalization(.words)
                    }.padding()
                                    
                Divider()
                            
                HStack {
                        
                    Button {
                        isShowEditView = true
                    } label: {
                        
                        VStack(alignment: .leading, spacing: 9) {
                                
                            CustomTextForProfile(text: "Address")
                                    .foregroundColor(.black)
                            
                            Text(userCollectionViewModel.user.address == "" ? "Address not filled yet" : userCollectionViewModel.user.address)
                                .foregroundColor(userCollectionViewModel.user.address == "" ? .gray : .black)
                                .multilineTextAlignment(.leading)
                        }
                    }.fullScreenCover(isPresented: $isShowEditView) {
                        EditAddressView(userCollectionViewModel: userCollectionViewModel)
                    }
                    
                    Spacer()
                }.padding()
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 9) {
                        CustomTextForProfile(text: "Birth date (MM/DD/YYYY)")
                        
                        Text(userCollectionViewModel.user.birthdate)
                    }
                    Spacer()
                }.padding()
                            
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 9) {
                        CustomTextForProfile(text: "Email")
                        
                        Text(userCollectionViewModel.user.email)
                    }
                    Spacer()
                }.padding()
                            
                Divider()

            }.onReceive(timer) { _ in
                if firstName == "" && lastName == "" {
                    hasEdited = false
                } else {
                    hasEdited = true
                }
            }
            .navigationBarTitle("Edit personal info")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .isHidden(isLoading ? true : false)
            .toolbar {
                Button {
                    isLoading = true
                        
                    let user = User(firstName: getRightPersoInfo(firstName, userCollectionViewModel.user.firstName), lastName: getRightPersoInfo(lastName, userCollectionViewModel.user.lastName), birthdate: userCollectionViewModel.user.birthdate, address: userCollectionViewModel.user.address, department: userCollectionViewModel.user.department, email: userCollectionViewModel.user.email, profilePhoto: userCollectionViewModel.user.profilePhoto, wishlist: userCollectionViewModel.user.wishlist, pendingRequest: userCollectionViewModel.user.pendingRequest, comingRequest: userCollectionViewModel.user.comingRequest, previousRequest: userCollectionViewModel.user.previousRequest)
                        
                    userCollectionViewModel.addToUserCollection(documentId: authentificationViewModel.userId.id ?? "", user: user) {
                        userCollectionViewModel.get(documentId: authentificationViewModel.userId.id ?? "") {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                presentationMode.wrappedValue.dismiss()
                                isLoading = false
                            }
                        }
                    }
                } label: {
                    Text("Save").bold()
                        .foregroundColor(.mainRed)
                }.isHidden(hasEdited ? false : true)
            }
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
        PersonalInformationView(userCollectionViewModel: UserCollectionViewModel())
    }
}
