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
class LocationManager {
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


    // 좌표 주소 반환
    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")

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
}
