//
//  AddressViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 24/10/2021.
//

import SwiftUI
import MapKit

// Various methods related to address properties and to ask and check for user localization.
class AddressViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.858370, longitude: 2.294481),
                                               span: AddressViewModel.span)
    @Published var convertedCoordinatesAddress: CLLocationCoordinate2D?
    @Published var permissionDenied = false
    @Published var address = Address(country: "", locality: "", thoroughfare: "", postalCode: "", subThoroughfare: "")
    
    static let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    var locationManager: CLLocationManager?
    
    // MARK: - Methods
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
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
            getAddressFromLatLon()
        @unknown default:
            break
        }
    }
    
    // Get all address elements for a given region store in the class property "region".
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
    
    func convertAddressIntoMapLocation(address: String, completion: @escaping (() -> Void)) {
        getCoordinate(addressString: address) { (location, error) in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                completion()
                return
            }
            DispatchQueue.main.async {
                self.convertedCoordinatesAddress = location
                completion()
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
    
    func selectAddressElement(modifyElement: String, currentElement: String) -> String {
        if modifyElement == "" {
            return currentElement
        }
        return modifyElement
    }
    
    func determineDepartmentToSaveInDatabase(postalCode: String) -> String {
        let artistDepartment = postalCode.prefix(2)
        if let index = Department.names.firstIndex(where: { $0.hasPrefix(artistDepartment) }) {
            let department = Department.names[index]
            return String(department)
        }
        return ""
    }
    
    func determineCity(address: String) -> String {
        let first = address.components(separatedBy: (","))
        let second = first[1].components(separatedBy: CharacterSet.decimalDigits).joined()
        let third = second.dropFirst(2)
        return String(third)
    }
    
    func rewriteDepartment(department: String) -> String {
        let first = department.dropFirst(5)
        return String(first)
    }
    
    func determineLocation(selectedPlaceName: String, artistPlace: String) -> String {
        var location = ""
        if selectedPlaceName == "Anywhere suits you" {
            if artistPlace == "Your place" || artistPlace == "Anywhere suits you" {
                location = "Artist's place"
            } else if artistPlace == "Audience's place" {
                location = "Your place"
            }
        } else {
            location = selectedPlaceName
        }
        return location
    }
    
    func retrieveAllAddressElements(address: String, subThoroughfare: @escaping ((String) -> Void), thoroughfare: @escaping ((String) -> Void), locality: @escaping ((String) -> Void), postalCode: @escaping ((String) -> Void), country: @escaping ((String) -> Void)) {
        if address != "" {
            if let subThoroughfareFromDb = address.components(separatedBy: " ").first {
                subThoroughfare(subThoroughfareFromDb)
            }
            if let thoroughFirst = address.components(separatedBy: ",").first {
                let thoroughSecond = thoroughFirst.components(separatedBy: CharacterSet.decimalDigits).joined(separator: "")
                let thoroughfareFromDb = String(thoroughSecond.dropFirst())
                thoroughfare(thoroughfareFromDb)
            }
            if let localityFirst = (address.range(of: ",")?.upperBound) {
                let localitySecond = String(address.suffix(from: localityFirst))
                let localityThird = String(localitySecond.dropFirst())
                if let localityFourth = localityThird.components(separatedBy: ",").first {
                    let localityFifth = localityFourth.components(separatedBy: CharacterSet.decimalDigits).joined(separator: "")
                    let localityFromDb = String(localityFifth.dropFirst())
                    locality(localityFromDb)
                    if let postalCodeFromDb = localityFourth.components(separatedBy: " ").first {
                        postalCode(postalCodeFromDb)
                    }
                }
            }
            if let countryFirst = address.components(separatedBy: ",").last {
                let countryFromDb = String(countryFirst.dropFirst())
                country(countryFromDb)
            }
        }
    }
}
