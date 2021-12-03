//
//  ConfirmAddressView.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 25/10/2021.
//

import SwiftUI
import MapKit

struct EnterAddressView: View {
    
    @StateObject private var addressViewModel = AddressViewModel()
    
    @Binding var address: Address
    @Binding var isParentViewLinkActive: Bool
    @Binding var resetToRootView: Bool
    @Binding var hasRegionChanged: Bool
    @Binding var convertedRegion: MKCoordinateRegion
    @Binding var convertedCoordinatesAddress: CLLocationCoordinate2D?
    
    @State private var isLinkActive = false
    @State private var isLinkActiveManually = false
    @State private var street = ""
    
    var body: some View {
        
        ZStack {
                
            VStack(spacing: 30) {
              
                NavigationLink(destination: UseCurrentLocation(address: $address, resetToRootView: $resetToRootView), isActive: $isLinkActive) {
                    Button {
                        isLinkActive = true
                    } label: {
                        LabelAddressView(image: "location.fill", text: "Use my current location")
                    }
                }
                    
                NavigationLink(destination: ConfirmAddressManually(isParentViewLinkActive: $isParentViewLinkActive, hasRegionChanged: $hasRegionChanged, convertedRegion: $convertedRegion, convertedCoordinatesAddress: $convertedCoordinatesAddress, resetToRootView: $resetToRootView), isActive: $isLinkActiveManually) {
                    Button {
                        self.isLinkActiveManually = true
                    } label: {
                        LabelAddressView(image: "keyboard", text: "Enter address manually")
                    }
                }.isDetailLink(false)
            }.navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text("Enter your address"), displayMode: .inline)
        .navigationBarItems(leading:
            Button(action: {
                isParentViewLinkActive = false
            }, label: {
                BackwardChevron()
            }))
        }
    }
}

struct LabelAddressView: View {
    
    var image: String
    var text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: image)
                .foregroundColor(.black)
            
            Text(text)
                .foregroundColor(.black)
                .font(.system(size: 19))
        }.padding(.vertical, 15)
            .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 0.5)
                .frame(width: UIScreen.main.bounds.width - 50))
    }
}
