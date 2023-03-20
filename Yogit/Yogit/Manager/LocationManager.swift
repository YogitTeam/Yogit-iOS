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
//import UIKit
//import CoreLocation
//
//// Location Model Controller
//class LocationController: UIViewController, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    
//    private func configureLocationManager() {
//        locationManager.delegate = self
//        // 정확도 설정 - 최고로 높은 정확도
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        // 위치 데이터 승인 요구
//        locationManager.requestWhenInUseAuthorization()
//        // 위치 업데이트 시작
//        locationManager.startUpdatingLocation()
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print("Check Location Authorization")
//        switch manager.authorizationStatus {
//        case .authorizedWhenInUse, .authorizedAlways:
//            manager.requestWhenInUseAuthorization()
//            print("Location is Authorized")
//        case .notDetermined: break
//        case .restricted: break
//        case .denied: break
//        @unknown default: break
//        }
//        // 권한 유저 디폴트에 저장
////        UserDefaults.standard.set(isAuthorized, forKey: "LocationAuthorization");
//    }
//
//    let locationManager = CLLocationManager()   // 위치 객체
//
//    var isAuthorized: Bool?
//
//    func setLocationManager() {
//
//        // 델리게이트 설정
//        locationManager.delegate = self
//
//        // 거리 정확도 설정
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//
//        // 위치 권한 요청
//        locationManager.requestWhenInUseAuthorization()
//
//        // 권환 저장
//        isAuthorized = UserDefaults.standard.object(forKey: "LocationAuthorization") as? Bool
//
//        // GPS 위치 정보 받아오기
//        locationManager.startUpdatingLocation()
//    }
//
//    // 권한 없으면 권한 설정 화면으로
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
//
//    // 위치 권한 변경시 실행
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print("Check Location Authorization")
//        // tracking mode = false면 uiView update
//        switch manager.authorizationStatus {
//        case .authorizedWhenInUse, .authorizedAlways:
//            print("Location is Authorized")
//            isAuthorized = true
//        case .notDetermined, .restricted:
//            print("Location is not Authorized")
//            isAuthorized = false
//            manager.requestWhenInUseAuthorization() // 권한 받아오기
//        case .denied:
//            print("Location Authorization is denied")
//            isAuthorized = false
//            setAuthAlertAction() // 위치 권한 거부: 설정 창으로 가서 권한을 변경하도록 유도해야 함
//        @unknown default:
//            break
//        }
//        // 권한 유저 디폴트에 저장
//        UserDefaults.standard.set(isAuthorized, forKey: "LocationAuthorization");
//    }
//
//    // 좌표 주소 반환
//    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees, completion: @escaping (String?) -> Void) {
//        let findLocation = CLLocation(latitude: lat, longitude: long)
//        let geocoder = CLGeocoder()
//        let locale = Locale(identifier: "Ko-kr")
//
//        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: { (placemarks, error) in
//
//            let resultAddress: String?
//
//            guard error == nil else { return print("ReverseGeocode error") }
//            guard let address: [CLPlacemark] = placemarks else { return print("ReverseGeocode address error") }
//            guard let locality: String = address.last?.locality else { return print("ReverseGeocode locality error") }
//            guard let name: String = address.last?.name else { return print("ReverseGeocode name error") }
//
//            resultAddress = locality + " " + name
//
//            completion(resultAddress)
//
//        })
//    }
//}
