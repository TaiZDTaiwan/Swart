//
//  ProfileView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 08/09/2021.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @StateObject var userRepositoryViewModel = UserRepositoryViewModel()
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @State private var changeProfileImage = false
    @State private var pickerIsPresented = false
    @State private var imageSelected = UIImage()
    @State private var url = ""
    
    init() {
       
    }
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: -5) {
                HStack {
                    ZStack() {
                        Button(action: {
                            changeProfileImage = true
                            pickerIsPresented = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                                if imageSelected.size.width != 0 {
                                    userRepositoryViewModel.uploadProfileImage(image: imageSelected)
                                }
                            }

                        }, label: {
                            if changeProfileImage && imageSelected.size.width != 0 {
                                Image(uiImage: imageSelected)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                
                            } else {
                                if url != "" {
                                    AnimatedImage(url: URL(string: url))
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } else {
                                    Image("profileImage")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                }
                            }
                        }).padding()
                            
                            
                        if imageSelected.size.width == 0 && url == "" {
                            Image(systemName: "plus")
                                .frame(width: 15, height: 15)
                                .foregroundColor(.black)
                                .clipShape(Circle())
                        }
                        
                    }.sheet(isPresented: $pickerIsPresented) {
                        ImagePicker(selectedImage: $imageSelected, sourceType: .photoLibrary)
                        
                    }
                    
                    
                    Text("YOOOO")
                    
                    Spacer()
                }
                
                Form {
                    Section(header: Text("Account parameters")) {
                        NavigationLink(destination: PersonalInformationView()
                                        .navigationBarTitle("Edit personal info", displayMode: .large)) {
                       
                            HStack {
                                Text("Personal information")
                                Spacer()
                                Image(systemName: "person.circle")
                            }
                        }
                        
                        NavigationLink(destination: PaymentView()) {
                            HStack {
                                Text("Payments & Payouts")
                                Spacer()
                                Image(systemName: "creditcard")
                            }
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            HStack {
                                Text("Notifications")
                                Spacer()
                                Image(systemName: "bell")
                            }
                        }
                    }
                    Section(header: Text("Becoming a swart artist")) {
                        NavigationLink(destination: PersonalInformationView()) {
                            HStack {
                                Text("Switch to artist mode")
                                Spacer()
                                Image(systemName: "arrow.triangle.swap")
                            }
                        }
                        
                        NavigationLink(destination: PaymentView()) {
                            HStack {
                                Text("Post your ad")
                                Spacer()
                                Image(systemName: "paintbrush.pointed")
                            }
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            HStack {
                                Text("My guides")
                                Spacer()
                                Image(systemName: "book")
                            }
                        }
                    }
                    Section(header: Text("Referral credit & coupons")) {
                        NavigationLink(destination: PersonalInformationView()) {
                            HStack {
                                Text("Refer an artist")
                                Spacer()
                                Image(systemName: "gift")
                            }
                        }
                    }
                    Section(header: Text("Support")) {
                        NavigationLink(destination: PersonalInformationView()) {
                            HStack {
                                Text("How Swart works")
                                Spacer()
                                Image(systemName: "globe")
                            }
                        }
                        
                        NavigationLink(destination: PaymentView()) {
                            HStack {
                                Text("Trust & Safety")
                                Spacer()
                                Image(systemName: "lock.shield")
                            }
                        }
                        
                        NavigationLink(destination: NotificationsView()) {
                            HStack {
                                Text("Help Centre")
                                Spacer()
                                Image(systemName: "questionmark.circle")
                            }
                        }
                    }
                    Section(header: Text("Legal")) {
                        NavigationLink(destination: PersonalInformationView()) {
                            HStack {
                                Text("Service condition")
                                Spacer()
                                Image(systemName: "doc.text.magnifyingglass")
                            }
                        }
                        
                        NavigationLink(destination: PaymentView()) {
                            HStack {
                                Text("Privacy settings")
                                Spacer()
                                Image(systemName: "lock")
                            }
                        }
                    }
                    Section {
                        NavigationLink(destination: PaymentView()) {
                            Text("Log out")
                                .foregroundColor(Color(.brown))
                                .bold()
                                .font(.system(size: 17))
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }.onAppear(perform: {
            userRepositoryViewModel.get(documentPath: authentificationViewModel.userInAuthentification.id ?? "")

            Storage.storage().reference().child("\(String(describing: authentificationViewModel.userInAuthentification.id))_profile_photo").downloadURL { (url, err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                if let url = url {
                    self.url = "\(url)"
                }
            }
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
