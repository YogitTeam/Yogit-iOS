////
////  File.swift
////  Yogit
////
////  Created by Junseo Park on 2022/11/13.
////
//
//import Foundation
//
////
////  LocationController.swift
////  PetDetective
////
////  Created by Junseo Park on 2022/04/08.
////
//
import UIKit
import CoreLocation

// Location Model Controller
final class LocationManager {
    static let shared = LocationManager()
    
    // 권한 없으면 권한 설정 화면으로
//    func setAuthAlertAction() {
//
//        let authAlertController = UIAlertController(title: "위치 사용 권한이 필요합니다.", message: "위치 권한을 허용해야만 앱을 사용하실 수 있습니다.", preferredStyle: .alert)
//
//        let getAuthAction = UIAlertAction(title: "설정", style: .default, handler: { (UIAlertAction) in
//            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(appSettings,options: [:],completionHandler: nil)
//            }
//        })
//
//        authAlertController.addAction(getAuthAction)
//
//        self.present(authAlertController, animated: true, completion: nil)
//    }
    
    func saveCountryCode(code: ServiceCountry) { // country save (server country)
        UserDefaults.standard.set(code.rawValue, forKey: ServiceCountry.identifier)
    }
    
    func getSavedCountryCode() -> String? {
        guard let code = UserDefaults.standard.object(forKey: ServiceCountry.identifier) as? ServiceCountry.RawValue else { return nil }
        return code
    }


    // 좌표 주소 반환
    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        guard let identifier = Locale.preferredLanguages.first else { return }// en-KR
        let locale = Locale(identifier: identifier)

        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: { (placemarks, error) in

            let resultAddress: String?

            guard error == nil else { return print("ReverseGeocode error") }
            guard let address: [CLPlacemark] = placemarks else { return print("ReverseGeocode address error") }
            guard let locality: String = address.last?.locality else { return print("ReverseGeocode locality error") }
            guard let name: String = address.last?.name else { return print("ReverseGeocode name error") }

            resultAddress = locality + " " + name

            completion(resultAddress)

        })
    }
    
    
    func cityNameGeocodingToServer(address: String, completion: @escaping (String, String) -> Void) {
        
        let geocoder = CLGeocoder()
       
        guard let serviceCountryCode = getSavedCountryCode() else { return }
        
        let locale = Locale(identifier: "en_US") // 서버로 넘길 데이터

        // 주소 다됨 (country, locality, "KR" >> South Korea)
        geocoder.geocodeAddressString(address, in: nil, preferredLocale: locale, completionHandler: {
            (placemarks, error) in
            if error != nil {
                return
            }

            guard let pm = placemarks?.last,
                  let locality = pm.locality,
                  let countryCode = pm.isoCountryCode,
                  serviceCountryCode == countryCode
            else {
                return
            }
            
            // apple api 가끔 서울만 영어로 되는 경우가 있음
            let cityName: String
            if locality == "서울특별시" { // english로 locale해도 서울만 영어로 안될때가 생겼음 (애플 API 문제)
                cityName = "Seoul"
            } else {
                cityName = locality
            }
            
            completion(cityName.uppercased(), countryCode)
        })
    }
}
