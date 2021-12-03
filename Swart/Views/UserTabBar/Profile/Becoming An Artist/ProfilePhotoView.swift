//
//  ProfilePhotoView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 22/10/2021.
//

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct ProfilePhotoView: View {
        
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    @EnvironmentObject var storeArtistContentViewModel: StoreArtistContentViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var userCollectionViewModel = UserCollectionViewModel()
    
    @Binding var resetToRootView: Bool
    @State private var isLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var isAlertDeletePhotoPresented = false
    @State private var isPhotoPresenting = false
    @State private var showImagePicker = false
    @State private var showActionSheet = false
    @State private var imageSelected = UIImage()
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State private var url = ""
    
    var body: some View {
        
        ZStack {
            
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
                Spacer(minLength: 150)
                
                VStack(alignment: .leading, spacing: -20) {
                    
                    TitleForArtistForm(text: "Make your best smile")
                    
                    CaptionForArtistForm(text: "Adding a profile photo is not mandatory and can be done later. Nevertheless, it is highly recommended and will be appreciated by your future audience.")
                }
                
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                
                    VStack {
                    
                        ZStack {
                            
                            Color.lightGrayForBackground
                            
                            Button {
                                showActionSheet = true
                            } label: {
                                if isPhotoPresenting {
                                    Image(uiImage: imageSelected)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .padding(EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40))
                                } else {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .padding(EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40))
                                            
                                        Image(systemName: "person.crop.circle.badge.plus")
                                            .resizable()
                                            .frame(width: 100, height: 85)
                                            .foregroundColor(.mainRed)
                                        }
                                    }
                                }.padding()
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
                            }.sheet(isPresented: $showImagePicker, onDismiss: didDismiss) {
                                ImagePicker(selectedImage: $imageSelected, sourceType: $sourceType)
                            }
                        
                        HStack {

                            Spacer()
                            
                            NavigationLink(destination: HeadlineView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button(action: {
                                    if isPhotoPresenting {
                                        userCollectionViewModel.uploadProfilePhoto(photo: imageSelected, fileName: Artist.profilePhotoFileName, pathName: authentificationViewModel.userInAuthentification.id ?? "")
                                        storeArtistContentViewModel.hasUploadedProfilePhoto = true
                                    }
                                    self.isLinkActive = true
                                }, label: {
                                   textLabel()
                                })
                            }.isDetailLink(false)
                        }.padding(EdgeInsets(top: 3, leading: 19, bottom: 0, trailing: 19))
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func didDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if imageSelected.size.width != 0 {
                isPhotoPresenting = true
            } else {
                isPhotoPresenting = false
            }
        }
    }
    
    private func textLabel() -> some View {
        return Group {
            if isPhotoPresenting {
                TextLabelNextForArtistForm()
            } else {
                TextLabelIgnoreForArtistForm()
            }
        }
    }
}

struct ArtistProfilePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoView(resetToRootView: .constant(false))
    }
}
