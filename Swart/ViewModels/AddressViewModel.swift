//
//  AddressViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 24/10/2021.
//

import SwiftUI
import MapKit

final class AddressViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.858370, longitude: 2.294481),
                                               span: AddressViewModel.span)
    
    @Published var convertedCoordinatesAddress: CLLocationCoordinate2D?
    @Published var permissionDenied = false
    
    var address = Address(country: "", locality: "", thoroughfare: "", postalCode: "", subThoroughfare: "")
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            print("Show alert")
        }
    }
    
    func getAddressFromLatLon() {
       
        let geocoder: CLGeocoder = CLGeocoder()
        let location: CLLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
            
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
        
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count > 0 {
                let placemark = placemarks![0]
                self.address.country = placemark.country ?? ""
                self.address.locality = placemark.locality ?? ""
                self.address.thoroughfare = placemark.thoroughfare ?? ""
                self.address.postalCode = placemark.postalCode ?? ""
                self.address.subThoroughfare = placemark.subThoroughfare ?? ""
            }
        })
    }
    
    func convertAddress(address: String) {
        getCoordinate(addressString: address) { (location, error) in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.convertedCoordinatesAddress = location
            }
        }
    }
    
    private func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted likely due to parental controls.")
        case .denied:
            permissionDenied = true
            print("You have denied this app location permission. Go into settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                        span: AddressViewModel.span)
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
