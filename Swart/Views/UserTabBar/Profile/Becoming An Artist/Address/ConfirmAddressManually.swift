//
//  SwiftUIView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 27/10/2021.
//

import SwiftUI
import MapKit
import ActivityIndicatorView

struct ConfirmAddressManually: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var artistCollectionViewModel = ArtistCollectionViewModel()
    
    @ObservedObject var addressViewModel: AddressViewModel

    @Binding var resetToRootView: Bool
    
    @State private var country = ""
    @State private var locality = ""
    @State private var thoroughfare = ""
    @State private var postalCode = ""
    @State private var subThoroughfare = ""
    @State private var isAlertPresented = false
    @State private var isAlertConfirmAddressPresented = false
    @State private var isLoading = false
    @State private var isLinkActive = false
    @State private var fullAddress = ""
    @State private var isShowLinkAlert = false
    
    var body: some View {
        
        ZStack {
            
            ActivityIndicator(isLoadingBinding: $isLoading, isLoading: isLoading)
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    Group {
                        VStack {
                            
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Street Number")
                                                
                                TextField("", text: $subThoroughfare)
                                    .keyboardType(.numberPad)
                                
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Street")
                                
                                TextField("", text: $thoroughfare)
                                    .autocapitalization(.words)
                                    .disableAutocorrection(true)
                                                
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "City")
                                
                                TextField("", text: $locality)
                                    .autocapitalization(.words)
                                    .disableAutocorrection(true)
                                            
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Postal Code")
                                
                                TextField("", text: $postalCode)
                                    .keyboardType(.numberPad)
                                    .textContentType(.postalCode)
                                                
                            }.padding()
                                        
                            Divider()
                                    
                            VStack(alignment: .leading) {
                                CustomTextForProfile(text: "Country")
                                                
                                TextField("", text: $country)
                                    .textContentType(.countryName)
                                    .autocapitalization(.words)
                        
                            }.padding()
                            
                            Divider()
                        }
                                    
                        TextForAddressPolicy()
                    }
                }.alert(isPresented: $isAlertPresented) {
                    Alert(title: Text("Please fill all required information."))
                }
                    
                VStack {
                        
                    Spacer()
                
                    NavigationLink(destination: ProfilePhotoView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                
                        Button {
                        
                            fullAddress = "\(subThoroughfare)" + " \(thoroughfare)" + ", \(postalCode)" + " \(locality)" + ", \(country)"
                        
                            if !isAddressIncomplete() {
                                addressViewModel.convertAddress(address: fullAddress) {
                                isLoading = true
                                    if addressViewModel.convertedCoordinatesAddress != nil {
                                        artistCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", documentAddress: fullAddress, documentDepartment: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: postalCode)) {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                isShowLinkAlert = true
                                                isLoading = false
                                            }
                                        }
                                    } else {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            isAlertConfirmAddressPresented = true
                                            isLoading = false
                                        }
                                    }
                                }
                            }
                        } label: {
                            CustomTextForButton(text: "Looks good")
                                .padding()
                        }.alert("Address successfully added!", isPresented: $isShowLinkAlert) {
                            Button("OK", role: .cancel) {
                                isLinkActive = true
                            }
                        }
                    }
                    .alert(isPresented: $isAlertConfirmAddressPresented) {
                        Alert(title: Text("Those information don't seem to match a proper location, are you sure to confirm?"),
                        message: .none,
                        primaryButton: .destructive(Text("Confirm")) {
                            artistCollectionViewModel.addAddressInformationToDatabase(documentId: authentificationViewModel.userId.id ?? "", documentAddress: fullAddress, documentDepartment: addressViewModel.determineDepartmentToSaveInDatabase(postalCode: postalCode)) {
                                isShowLinkAlert = true
                            }
                        },
                        secondaryButton: .cancel())
                    }
                }.padding(.vertical, 3)
            }.isHidden(isLoading ? true : false)
        }.padding(.horizontal, 5)
        .navigationBarTitle(Text("Enter your address"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                BackwardChevron()
            }))
        }
    
    private func isAddressIncomplete() -> Bool {
        let addressArray = [subThoroughfare, thoroughfare, postalCode, locality, country]
        
        for element in addressArray where element == "" {
            isAlertPresented = true
            return true
        }
        return false
    }
}

struct ConfirmAddressManually_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmAddressManually(addressViewModel: AddressViewModel(), resetToRootView: .constant(false))
    }
}
