//
//  AddressView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 24/10/2021.
//

import SwiftUI
import MapKit
import CoreLocation

struct AddressView: View {
    
    @EnvironmentObject var authentificationViewModel: AuthentificationViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var userCollectionViewModel = UserCollectionViewModel()
    @StateObject private var addressViewModel = AddressViewModel()
        
    @Binding var resetToRootView: Bool
    
    @State private var convertedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                                            span: AddressViewModel.span)
    @State private var convertedCoordinatesAddress: CLLocationCoordinate2D?
    @State private var hasRegionChanged = false
    @State private var isParentViewLinkActive = false
    @State private var isAlertDismissPresented = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var address = Address(country: "", locality: "", thoroughfare: "", postalCode: "", subThoroughfare: "")
    @State private var isLinkActive = false
    
    var body: some View {
        
        ZStack {
            
            BackgroundForArtistForm()
                    
            VStack(alignment: .leading) {
                
                ButtonsForArtistForm(presentationMode: _presentationMode, isAlertDismissPresented: $isAlertDismissPresented, resetToRootView: $resetToRootView)
                
                VStack(alignment: .leading, spacing: -20) {
                    
                    TitleForArtistForm(text: "Where's your place located?")
                        .padding(.vertical)
                        .padding(.horizontal, 15)
                    
                    CaptionForArtistForm(text: "We'll only share your address with guests who are booked as outlined in our privacy policy.")
                }
                
                ZStack {
                    Color(.white)
                        .ignoresSafeArea()
                
                    VStack {
                        
                        ZStack {
                            let annotations = [MapPin(name: "Artist's house", coordinate: hasRegionChanged ? convertedCoordinatesAddress! : CLLocationCoordinate2D(latitude: 0, longitude: 0))]
                
                            Map(coordinateRegion: hasRegionChanged ? $convertedRegion : $addressViewModel.region, showsUserLocation: hasRegionChanged ? false : true, annotationItems: annotations) { pin in
                                MapAnnotation(coordinate: pin.coordinate) {
                                    Image(systemName: "house")
                                        .foregroundColor(.mainRed)
                                }
                            }
                            .ignoresSafeArea()
                            .accentColor(.mainRed)
                            .onAppear {
                                addressViewModel.checkIfLocationServicesIsEnabled()
                                    
                                    if !hasRegionChanged {
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            addressViewModel.getAddressFromLatLon()
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                self.address = addressViewModel.address

                                            }
                                        }
                                    }
                                }
                            
                            VStack(alignment: .leading) {
                                
                                NavigationLink(destination: EnterAddressView(address: $address, isParentViewLinkActive: $isParentViewLinkActive, resetToRootView: $resetToRootView, hasRegionChanged: $hasRegionChanged, convertedRegion: $convertedRegion, convertedCoordinatesAddress: $convertedCoordinatesAddress), isActive: self.$isParentViewLinkActive) {
                                                    
                                    HStack(spacing: 15) {
                                        Image(systemName: "location.fill")
                                            .foregroundColor(.black)
                                        
                                        Text("Enter your address")
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                    }.padding(.horizontal, 25)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 50)
                                            .foregroundColor(Color.white)
                                            .frame(width: UIScreen.main.bounds.width - 50))
                                }.isDetailLink(false)
                                
                                Spacer()
                                
                            }.isHidden(hasRegionChanged ? true : false)
                            .padding()
                        }
                        
                        HStack {

                            Spacer()
                            
                            NavigationLink(destination: ProfilePhotoView(resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                                Button(action: {
                                   isLinkActive = true
                                }, label: {
                                    NextButtonForArtistForm()
                                }).alert(isPresented: $isAlertPresented) {
                                    Alert(title: Text(alertMessage))
                                }
                            }.isDetailLink(false)
                            .isHidden(hasRegionChanged ? false : true)
                        }.padding(EdgeInsets(top: 3, leading: 19, bottom: 0, trailing: 19))
                    }.alert(isPresented: $addressViewModel.permissionDenied, content: {
                        Alert(title: Text("Permission Denied"), message: Text("Please enable permission in App Settings"), dismissButton: .default(Text("Go to Settings"), action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }))
                    })
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(resetToRootView: .constant(false))
    }
}
