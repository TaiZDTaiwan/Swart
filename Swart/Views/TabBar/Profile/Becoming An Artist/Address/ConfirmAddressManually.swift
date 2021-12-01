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
    @StateObject var addressViewModel = AddressViewModel()
    
    @Binding var isParentViewLinkActive: Bool
    @Binding var hasRegionChanged: Bool
    @Binding var convertedRegion: MKCoordinateRegion
    @Binding var convertedCoordinatesAddress: CLLocationCoordinate2D?
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
                                    
                        Text("We'll only share your address with guests who are booked as outlined in our privacy policy.")
                            .fontWeight(.semibold)
                            .font(.caption)
                            .foregroundColor(.gray)
                                    
                        Spacer()
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
                                addressViewModel.convertAddress(address: fullAddress)
                                isLoading = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    if addressViewModel.convertedCoordinatesAddress != nil {
                                        artistCollectionViewModel.addSingleDocumentToArtistCollection(id: authentificationViewModel.userInAuthentification.id ?? "", nameDocument: "address", document: fullAddress)
                                        hasRegionChanged = true
                                        self.convertedCoordinatesAddress = addressViewModel.convertedCoordinatesAddress
                                        self.convertedRegion = MKCoordinateRegion(center: self.convertedCoordinatesAddress!, span: AddressViewModel.span)
                                        self.isParentViewLinkActive = false
                                    } else {
                                        isLoading = false
                                        isAlertConfirmAddressPresented = true
                                    }
                                }
                            }
                        } label: {
                            CustomTextForButton(text: "Looks good")
                        }
                    }
                    .alert(isPresented: $isAlertConfirmAddressPresented) {
                        Alert(title: Text("Those information don't seem to match a proper location, are you sure to confirm?"),
                        message: .none,
                        primaryButton: .destructive(Text("Confirm")) {
                            artistCollectionViewModel.addSingleDocumentToArtistCollection(id: authentificationViewModel.userInAuthentification.id ?? "", nameDocument: "address", document: fullAddress)
                            isLinkActive = true
                        },
                        secondaryButton: .cancel())
                    }
                }
            }.isHidden(isLoading ? true : false)
            .padding(.vertical, 30)
        }.frame(width: UIScreen.main.bounds.width - 10)
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
