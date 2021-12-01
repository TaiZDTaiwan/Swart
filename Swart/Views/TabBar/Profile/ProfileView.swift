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
    
    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    @StateObject var userCollectionViewModel = UserCollectionViewModel()
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var imageSelected = UIImage()
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State private var url = ""
    @State private var isShownPersonalInformationView = false
    @State private var isShownBecomeAnArtistHomePageView = false
    @State private var firstName = ""
    @State private var updatedFirstName = ""
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: -5) {
                HStack {
                    ZStack {
                        Button(action: {
                            showActionSheet = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                                if imageSelected.size.width != 0 {
                                    userCollectionViewModel.uploadProfilePhoto(photo: imageSelected, fileName: User.profilePhotoFileName, pathName: authentificationViewModel.userInAuthentification.id ?? "")
                                }
                            }
                        }, label: {
                            if imageSelected.size.width != 0 {
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
                    }.actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("Add a photo to your profile."), message: nil, buttons: [
                            .default(Text("Camera"), action: {
                                self.showImagePicker = true
                                self.sourceType = .camera
                            }),
                            .default(Text("Photo Library"), action: {
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                            }),
                            .cancel()
                        ])
                    }.sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $imageSelected, sourceType: $sourceType)
                    }
                    
                    Text(displayFirstName())
                        .bold()
                        .font(.system(size: 18))
                        
                    Spacer()
                }
                
                Form {
                    Section(header: Text("Account parameters")) {
                        Button(action: {
                            isShownPersonalInformationView.toggle()
                        }, label: {
                            HStack {
                                Text("Personal information")
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "person.circle")
                                    .foregroundColor(.black)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }).fullScreenCover(isPresented: $isShownPersonalInformationView, content: {
                            PersonalInformationView.init(updatedFirstName: $updatedFirstName)
                        })
                        
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
                        Button(action: {
                            isShownBecomeAnArtistHomePageView.toggle()
                        }, label: {
                            HStack {
                                Text("Switch to artist mode")
                                    .foregroundColor(.black)
                                Spacer()
                                
                                Image(systemName: "arrow.triangle.swap")
                                    .foregroundColor(.black)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }).fullScreenCover(isPresented: $isShownBecomeAnArtistHomePageView, content: {
                            BecomeAnArtistHomePageView.init()
                        })
                        
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
                        NavigationLink(destination: PersonalInformationView(updatedFirstName: $updatedFirstName)) {
                            HStack {
                                Text("Refer an artist")
                                Spacer()
                                Image(systemName: "gift")
                            }
                        }
                    }
                    Section(header: Text("Support")) {
                        NavigationLink(destination: PersonalInformationView(updatedFirstName: $updatedFirstName)) {
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
                        NavigationLink(destination: PersonalInformationView(updatedFirstName: $updatedFirstName)) {
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
            }.navigationBarHidden(true)
        }.onAppear(perform: {
            userCollectionViewModel.get(documentPath: authentificationViewModel.userInAuthentification.id ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                firstName = userCollectionViewModel.userSwart.firstName
                
                userCollectionViewModel.downloadProfilePhoto { result in
                    switch result {
                    case .success(let url):
                        self.url = url
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
        })
    }
    
    private func displayFirstName() -> String {
        if updatedFirstName == "" {
            return firstName
        } else {
            return updatedFirstName
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthentificationViewModel())
    }
}
