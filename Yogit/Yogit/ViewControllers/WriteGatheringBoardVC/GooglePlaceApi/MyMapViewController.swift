////
////  MyMapViewController.swift
////  Yogit
////
////  Created by Junseo Park on 2022/11/13.
////
//
////AIzaSyDf90QEzoh79P2IntFDs7gcWz7QwtjvJcE
//
//import UIKit
//import CoreLocation
//import MapKit
//import SnapKit
//
//// google map version
//class MyMapViewController: UIViewController, MKMapViewDelegate {
//    
//    // 좌표 초기값
//    // defualt 현재 국가로 표시
//    // 권한 받기
//    // 권한 잇으면 현재 위치로 이동
//    // 권한 없으면 유저가 수동적으로 이동
//    // 카메라 줌인 높이 설정
//    
//    // 마커 중앙값 고정
//    
//    // 주소 검색 창
//    // 해당 주소로 맵 이동
//    
//    // 맵에서 중앙좌표 읽어 오는 함수
//    // 좌표 주소로 변환 함수 (Full address, adminstieview 저장)
//    
//    // 주소 결과값
//    // 기본 주소
//    // 상세주소 텍스트 필드 (강남역 2번 출구)
//    
//    
//    let searchVC = UISearchController(searchResultsController: ResultsViewController())
//    
//    var runTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
//    let mTimer: Selector = #selector(Tick_TimeConsole) // 위치 확인 타이머
//    
//    let mapView = MKMapView()
//    let locationManager = CLLocationManager()   // 위치 객체
//    var latitudeValue: Double = 0.0
//    var longtudeValue: Double = 0.0
//    
//    private let pinImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: "Pin")
//        return imageView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        mapView.delegate = self
//        setLocationManager()
//        view.addSubview(mapView)
//        view.addSubview(pinImageView)
//        searchVC.searchResultsUpdater = self
//        self.navigationItem.searchController = searchVC
//        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: mTimer, userInfo: nil, repeats: true)
//        configureViewComponent()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.mapView.frame = view.bounds
//        pinImageView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview().offset(47/2 )
//            make.width.equalTo(35)
//            make.height.equalTo(47)
//        }
////        self.mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
//    }
//    
//    private func configureViewComponent() {
//        view.backgroundColor = .systemBackground
//    }
//    
//    func setLocationManager() {
//        locationManager.delegate = self
//        // 정확도 설정 - 최고로 높은 정확도
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        // 위치 데이터 승인 요구
//        locationManager.requestWhenInUseAuthorization()
//        // 위치 업데이트 시작
//        locationManager.startUpdatingLocation()
//    }
//    
//    // move camera
//    func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
//        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
//        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
//        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue)
//        self.mapView.setRegion(pRegion, animated: true)
//    }
//    
////    // set pin
////    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubTitle:String) {
////        mapView.removeAnnotations(mapView.annotations)
////        let annotation = MKPointAnnotation()
////        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
////        annotation.title = strTitle
////        annotation.subtitle = strSubTitle
////        mapView.addAnnotation(annotation)
////    }
//    
//    // reset runtimeinerval
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        runTimeInterval = Date().timeIntervalSinceReferenceDate
//    }
//}
//
//extension MyMapViewController: CLLocationManagerDelegate {
//    // 위치 권한 변경시 실행
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
//    // locationManager 에러
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let pLocation = locations.last // 최근 위치
//        moveLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longtudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
//        
//        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: { (placemarks, error) -> Void in
//            if let pm: CLPlacemark = placemarks?.first {
//                let address: String = "\(pm.locality ?? "") \(pm.name ?? "")"
//                print("Current location = \(address)")
////                self.mainTitle.text = "내 위치"
////                self.subTitle.text = address
//            }
//        })
//        
//        locationManager.stopUpdatingLocation()
//    }
//    
//    @objc func Tick_TimeConsole() {
//            
//        guard let timeInterval = runTimeInterval else { return }
//            
//        let interval = Date().timeIntervalSinceReferenceDate - timeInterval
//            
//        if interval < 0.20 { return }
//            
//        let coordinate = mapView.centerCoordinate
//            
//        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//
//        // 지정된 위치의 지오 코드 요청
//        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
//            if let pm: CLPlacemark = placemarks?.first {
//                let address: String = "\(pm.country ?? "") \(pm.administrativeArea ?? "") \(pm.locality ?? "") \(pm.subLocality ?? "") \(pm.name ?? "")"
//                print("화면 중앙 위치 \(address)")
////                self.centerMainTitle.text = "화면 중앙 위치"
////                self.centerSubTitle.text = address
//            } else {
////                self.centerMainTitle.text = ""
////                self.centerSubTitle.text = ""
//            }
//        }
//        runTimeInterval = nil
//    }
//    
////    // 좌표 주소 반환
////    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees, completion: @escaping (String?) -> Void) {
////        let findLocation = CLLocation(latitude: lat, longitude: long)
////        let geocoder = CLGeocoder()
////        let locale = Locale(identifier: "Ko-kr")
////
////        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: { (placemarks, error) in
////
////            let resultAddress: String?
////
////            guard error == nil else { return print("ReverseGeocode error") }
////            guard let address: [CLPlacemark] = placemarks else { return print("ReverseGeocode address error") }
////            guard let locality: String = address.last?.locality else { return print("ReverseGeocode locality error") }
////            guard let name: String = address.last?.name else { return print("ReverseGeocode name error") }
////
////            resultAddress = locality + " " + name
////
////            completion(resultAddress)
////
////        })
////    }
//}
//
//
//extension MyMapViewController: UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty,
//        let resultsVC = searchController.searchResultsController as? ResultsViewController else {
//            return
//        }
//        
//        resultsVC.delegate = self
//        
//        GooglePlacesManager.shaerd.findPlaces(query: query) { result in
//            switch result {
//            case .success(let places):
//                DispatchQueue.main.async {
//                    resultsVC.update(with: places)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//}
//
//extension MyMapViewController: ResultViewControllerDelegate {
//    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
//        searchVC.searchBar.resignFirstResponder()
//        searchVC.dismiss(animated: true, completion: nil)
//        // 그전 핀 삭제
////        let annotations = mapView.annotations
////        mapView.removeAnnotation(annotations as? MKAnnotation!)
//        // add a map min
//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinates
//        mapView.addAnnotation(pin)
//        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
//        moveLocation(latitudeValue: coordinates.latitude, longtudeValue: coordinates.longitude, delta: 0.01)
//    }
//}
