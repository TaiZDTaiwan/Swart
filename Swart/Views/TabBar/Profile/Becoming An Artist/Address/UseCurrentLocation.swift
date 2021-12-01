//
//  ConfirmAddressView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 26/10/2021.
//

import SwiftUI
import ActivityIndicatorView

struct UseCurrentLocation: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var addressViewModel = AddressViewModel()
    @StateObject private var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @Binding var address: Address
    @Binding var resetToRootView: Bool
    
    @State private var country = ""
    @State private var locality = ""
    @State private var thoroughfare = ""
    @State private var postalCode = ""
    @State private var subThoroughfare = ""
    @State private var fullAddress = ""
    @State private var isLinkActive = false
    @State private var isLoading = true
    
    var body: some View {
        
        ZStack {
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
            
            ScrollView {
            
                VStack(spacing: 20) {
                    
                    Group {
                        VStack {
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Street Number")
                                                
                                CustomTextfieldForProfile(bindingText: $subThoroughfare, text: subThoroughfare, textFromDb: address.subThoroughfare)
                                    .keyboardType(.numberPad)
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Street")
                                                
                                CustomTextfieldForProfile(bindingText: $thoroughfare, text: thoroughfare, textFromDb: address.thoroughfare)
                                    .textContentType(.addressCity)
                                    .autocapitalization(.words)
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "City")
                                                
                                CustomTextfieldForProfile(bindingText: $locality, text: locality, textFromDb: address.locality)
                                    .textContentType(.addressCity)
                                    .autocapitalization(.words)
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Postal Code")
                                                
                                CustomTextfieldForProfile(bindingText: $postalCode, text: postalCode, textFromDb: address.postalCode)
                                    .keyboardType(.numberPad)
                                    .textContentType(.postalCode)
                                    .autocapitalization(.words)
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Country")
                                                
                                CustomTextfieldForProfile(bindingText: $country, text: country, textFromDb: address.country)
                                    .textContentType(.countryName)
                                    .autocapitalization(.words)
                            }.padding()
                            
                            Divider()
                        }
                                    
                        Text("We'll only share your address with guests who are booked as outlined in our privacy policy.")
                            .fontWeight(.semibold)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            
                VStack {
                    NavigationLink(destination: ProfilePhotoView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                        Button {
                            fullAddress = "\(selectAddressElement(modifyElement: subThoroughfare, currentElement: address.subThoroughfare))" + " \(selectAddressElement(modifyElement: thoroughfare, currentElement: address.thoroughfare))" + ", \(selectAddressElement(modifyElement: postalCode, currentElement: address.postalCode))" + " \(selectAddressElement(modifyElement: locality, currentElement: address.locality))" + ", \(selectAddressElement(modifyElement: country, currentElement: address.country))"
                            
                            artistCollectionViewModel.addSingleDocumentToArtistCollection(id: authentificationViewModel.userInAuthentification.id ?? "", nameDocument: "address", document: fullAddress)
                            
                            isLinkActive = true
                            
                        } label: {
                            CustomTextForButton(text: "Looks good")
                        }
                    }
                }.padding(.vertical, 30)
            }.isHidden(isLoading ? true : false)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isLoading = false
                }
            }
        }.frame(width: UIScreen.main.bounds.width - 10)
        .navigationBarTitle(Text("Confirm your address"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                BackwardChevron()
            }))
        }
    
    private func selectAddressElement(modifyElement: String, currentElement: String) -> String {
        if modifyElement == "" {
            return currentElement
        }
        return modifyElement
    }
}

struct ConfirmAddressView_Previews: PreviewProvider {
    static var previews: some View {
        UseCurrentLocation(address: .constant(Address(country: "", locality: "", thoroughfare: "", postalCode: "", subThoroughfare: "")), resetToRootView: .constant(false))
    }
}
