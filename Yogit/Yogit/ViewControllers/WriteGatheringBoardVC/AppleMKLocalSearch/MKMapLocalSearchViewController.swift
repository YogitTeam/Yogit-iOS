//
//  MKMapLocalSearchViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/14.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit

struct MeetUpPlace {
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var locality: String?
}

struct ReverGedoData {
    let centerAddress: String?
    let locality: String?
}

protocol MeetUpPlaceProtocol: AnyObject {
    func locationSend(meetUpPlace: MeetUpPlace?)
}

// google map version
class MKMapLocalSearchViewController: UIViewController {
    
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)

    weak var timer: Timer?

    private let searchVC = UISearchController(searchResultsController: MKResultsLocalSearchTableViewController())

//    private var geoRunTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
    private var searchRunTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
//    private let geoTimer: Selector = #selector(Geo_Tick_TimeConsole) // 위치 확인 타이머
    private let searchTimer: Selector = #selector(Search_Tick_TimeConsole) // search 확인 타이머
    
    
    private let setCountryCode = LocationManager.shared.getSavedCountryCode()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    private var meetUpPlace = MeetUpPlace() {
        didSet {
            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                if meetUpPlace.latitude == nil {
                    saveButton.isEnabled = false
                    saveButton.backgroundColor = .placeholderText
                } else {
                    saveButton.isEnabled = true
                    saveButton.backgroundColor = ServiceColor.primaryColor
                }
            })
        }
    }
    
    weak var delegate: MeetUpPlaceProtocol?
    
    private var searchText: String?
    private var searchRequest = MKLocalSearch.Request()
    
    private lazy var noticeView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray // my: systemGray, you: blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.addSubview(noticeLabel)
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.text = "↑ " + "SEARCHBAR_NOTICE_DESCRIPTION".localized()
        label.textColor = .white
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        // 해당 클로저에서 나중에 indicator 를 반환해주기 위해 상수형태로 선언
        let activityIndicator = UIActivityIndicatorView()
        
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        activityIndicator.center = self.view.center
        
        // 기타 옵션
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        
        // stopAnimating을 걸어주는 이유는, 최초에 해당 indicator가 선언되었을 때, 멈춘 상태로 있기 위해서
        activityIndicator.stopAnimating()
        
        return activityIndicator
            
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("DONE".localized(), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.backgroundColor = .placeholderText
        button.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let searchGuideLabel: UILabel = {
        let label = UILabel()
        // localized 필요
        // Place: device lanuage
        // Postcode: number
//        label.text = """
//        It's better to find it in the language of the country for that location
//
//        Search like this.
//
//        - Road name + building number
//        ex) 테헤란로10길 23
//
//        - Area name + street number
//        ex) 성수동 10-23
//
//        - Building name + Apartment name
//        ex) 한양아파트 204동
//        """
        
        label.text = "SEARCH_GUIDE_TITLE".localized()
        
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var searchGuideView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        view.addSubview(searchGuideLabel)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav()
        configureSearchController()
        configureLocationManager()
        configureLayout()
//        configureGuideLabel()
        timerRun()
        searhBarNoticeView(noticeView: noticeView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerQuit()
    }
    
    private func configureView() {
        view.addSubview(mapView)
        view.addSubview(saveButton)
        view.addSubview(searchGuideView)
        view.addSubview(noticeView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        mapView.frame = view.bounds
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(30)
            make.height.equalTo(44)
        }
        searchGuideView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        searchGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(searchGuideView.safeAreaLayoutGuide).offset(6)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        activityIndicator.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        noticeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(6)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        noticeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureNav() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchVC
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.delegate = self
        searchVC.searchBar.placeholder = "SEARCHBAR_PLACEHOLDER".localized()
        searchVC.searchBar.addSubview(activityIndicator)
    }
    
    
    private func searhBarNoticeView(noticeView: UIView) {
        var repeatCount = 0
        var m = -12
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            UIView.animate(withDuration: 0.3, animations: {
                noticeView.frame.origin.y += CGFloat(m)
            }, completion: { (finished) in
                if repeatCount > 4 {
                    timer.invalidate()
                }
                m *= -1
                repeatCount += 1
            })
        }
    }
    
    private func timerRun() {
        timer = Timer.scheduledTimer(timeInterval: 0.30, target: self, selector: searchTimer, userInfo: nil, repeats: true)
    }
    
    private func timerQuit() {
        if let timer = timer {
            if(timer.isValid){
                timer.invalidate()
                self.timer = nil
            }
        }
    }
    
//    private func configureGuideLabel() {
//
//        //label에 있는 Text를 NSMutableAttributedString으로 만들어준다.
//        let attributedStr = NSMutableAttributedString(string: searchGuideLabel.text!)
//
//        //위에서 만든 attributedStr에 addAttribute메소드를 통해 Attribute를 적용. kCTFontAttributeName은 value로 폰트크기와 폰트를 받을 수 있음.
//        attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold), range: (searchGuideLabel.text! as NSString).range(of: "It's better to find it in the language of the country for that location"))
//        attributedStr.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium), range: (searchGuideLabel.text! as NSString).range(of: "Search like this."))
//        attributedStr.addAttribute(.foregroundColor, value: UIColor.systemGray, range: (searchGuideLabel.text! as NSString).range(of: "ex) 테헤란로10길 23"))
//        attributedStr.addAttribute(.foregroundColor, value: UIColor.systemGray, range: (searchGuideLabel.text! as NSString).range(of: "ex) 성수동 10-23"))
//        attributedStr.addAttribute(.foregroundColor, value: UIColor.systemGray, range: (searchGuideLabel.text! as NSString).range(of: "ex) 한양아파트 204동"))
//
//        //최종적으로 내 label에 속성을 적용
//        searchGuideLabel.attributedText = attributedStr
////        searchGuideLabel.sizeToFit()
//
//    }
    
//    //Text색상 바꾸기
//   func myLabelChangeColor(_ text:String, range :NSRange){
//
//       let attributedString = NSMutableAttributedString(string: text)
//       attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: range)
//       searchGuideLabel.attributedText = attributedString
//   }
//
    
//    @objc func onClickSwitch(sender: UISwitch) {
//        // Inactive하면 화면 중앙 핀 hide=true, active 하면 핀 hide false
//        if sender.isOn {
//            sender.isHidden = false
//            pinImageView.isHidden = false
//        } else {
//            sender.isHidden = true
//            pinImageView.isHidden = true
//        }
//    }

    
//    // reset runtimeinerval
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        geoRunTimeInterval = Date().timeIntervalSinceReferenceDate
//    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        self.delegate?.locationSend(meetUpPlace: self.meetUpPlace)
        self.navigationController?.popViewController(animated: true)
    }

}
extension MKMapLocalSearchViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    // 위치 권한 변경시 실행
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Check Location Authorization")
        configureMap()
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            configureMapOption()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        case .restricted, .denied: break
        @unknown default: break
        }
        // 권한 유저 디폴트에 저장
        //        UserDefaults.standard.set(isAuthorized, forKey: "LocationAuthorization");
    }
    
    // locationManager 에러
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last // 최근 위치
        guard let lat = pLocation?.coordinate.latitude else { return }
        guard let lng = pLocation?.coordinate.longitude else { return }
        moveLocation(latitudeValue: lat, longtudeValue: lng, delta: 0.01)
        locationManager.stopUpdatingLocation()
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
    }
    
    private func configureMap() {
        mapView.delegate = self
    }
    
    private func configureMapOption() {
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        
        let pinImage = UIImage(named: "Pin")
        
        annotationView?.image = pinImage?.coustomPinSize(width: 40, height: 40)
        
       return annotationView
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
//        view.isSelected = true
//    }
    

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if views.count > 0 && views[0].annotation is MKPointAnnotation && !views[0].isSelected {
            views[0].isSelected = true
        }
    }
    
    // move camera
    func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue)
        self.mapView.setRegion(pRegion, animated: true)
    }
    
    // set pin
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubTitle:String) {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        mapView.addAnnotation(annotation)
    }

    @objc func Search_Tick_TimeConsole() {
//        searchVC.searchBar.tag = 0
        
        guard let timeInterval = searchRunTimeInterval else { return }

        let interval = Date().timeIntervalSinceReferenceDate - timeInterval

        if interval <  0.30 { return }
        
        guard let text = searchVC.searchBar.text?.lowercased(), let resultsVC = searchVC.searchResultsController as? MKResultsLocalSearchTableViewController else {
            return
        }
        
        guard let serviceCountryCode = setCountryCode else { return }
        
        // 37.5495209, 127.075086 (위경도로 검색 가능)
        // 좌표 검색 시켜 >> 사용자마다 주소를 로컬라이즈화(자동) 불러와서
        
        searchRequest.naturalLanguageQuery = text
        searchRequest.resultTypes = [.address, .pointOfInterest]
        searchRequest.region = searchRegion
//        searchRequest.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.509272, longitude: 127.262724), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let search = MKLocalSearch(request: searchRequest)
        
        resultsVC.delegate = self
       
        search.start { [weak self] (response, error) in
            guard let response = response, error == nil else {
                if self?.searchVC.searchBar.text != nil && self?.searchVC.searchBar.text != "" {
                    resultsVC.notFound()
                    DispatchQueue.main.async(qos: .userInteractive) {
                        self?.activityIndicator.stopAnimating()
                        self?.searchVC.searchBar.searchTextField.leftView?.isHidden = false
                    }
                }
            return
            }
            
            var mapItems: [MKMapItem] = []
            for item in response.mapItems {
                if let postCode = item.placemark.postalCode,
                   let countryCode = item.placemark.countryCode,
                   serviceCountryCode == countryCode { // 로컬 디비에 저장 해서 변경
                    mapItems.append(item) // 우편번호만 있는 주소 값만 저장 (도, 시 제외)
                }
            }
            if mapItems.count == 0 {
                resultsVC.notFound()
            } else {
                DispatchQueue.main.async(qos: .userInteractive) {
                    resultsVC.updateMK(with: mapItems)
                }
            }
            DispatchQueue.main.async(qos: .userInteractive) {
                self?.activityIndicator.stopAnimating()
                self?.searchVC.searchBar.searchTextField.leftView?.isHidden = false
            }
        }
        
//        updateSearchResults(for: searchVC)
    
        searchRunTimeInterval = nil
    }
    
    func forwardGeocoding(address: String, completion: @escaping (String, String) -> Void) {
        let geocoder = CLGeocoder()
        guard let identifier = Locale.preferredLanguages.first else { return }// en-KR
//        let region = Locale.current.region?.identifier // KR
        let locale = Locale(identifier: identifier)

        // 주소 다됨 (country, locality, "KR" >> South Korea)
        geocoder.geocodeAddressString(address, in: nil, preferredLocale: locale, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Failed to geocodeAddressString location")
                return
            }

            guard let pm = placemarks?.last else { return }
            guard let locality = pm.locality else { return }
            guard let countryCodeName = pm.country else { return }
        
            completion(locality, countryCodeName)
        })
    }
    
    // 좌표 주소 반환
    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees, completion: @escaping (ReverGedoData?) -> Void) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        
        // locale 설정 가능
//        let locale = Locale(identifier: "ko-KR")
        let locale = Locale(identifier: "en_US") // 서버로 넘길 데이터
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Failed to reverseGeocodeLocation")
                return
            }
            
            // 서버에 전송할때, country 키로, locality를 값 (영어로 전송) >> 받을때 유저 preference language로 geocoding해서 변환
            guard let pm = placemarks?.last else { return }
//            let country = pm.country ?? ""
            guard let locality = pm.locality else { return }
            
            let centerAddress = "\(locality) \(pm.thoroughfare ?? "") \(pm.subThoroughfare ?? "")"
            
            // apple api 가끔 서울만 영어로 되는 경우가 있음
            let cityName: String
            if locality == "서울특별시" { // english로 locale해도 서울만 영어로 안될때가 생겼음 (애플 API 문제)
                cityName = "Seoul"
            } else {
                cityName = locality
            }
            
            let reverseGeoData = ReverGedoData(centerAddress: centerAddress, locality: cityName.uppercased())
            
//            self.forwardGeocoding(address: locality) { (cityName, countryCodeName) in
//                print("forwardGeocoding res", cityName, countryCodeName)
//            }
            completion(reverseGeoData)
        })

    }
}

extension MKMapLocalSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        searchRunTimeInterval = Date().timeIntervalSinceReferenceDate // 마지막 변경 시간
    
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
    }
}

extension MKMapLocalSearchViewController: UISearchBarDelegate {
    // 초기 텍스트필드 포커스
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 설명 뷰 띄우고, 검색 데이터 없데이트 완료후 view hide
        DispatchQueue.main.async(qos: .userInteractive) { [self] in
            searchGuideView.isHidden = false // 가이드뷰 숨김
            if !noticeView.isHidden { noticeView.isHidden = true }
            if activityIndicator.isAnimating {
                activityIndicator.stopAnimating()
                searchBar.searchTextField.leftView?.isHidden = false
            }
        }
    }

    // 입력하다 지웠을때나, 값 변경
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async(qos: .userInteractive) { [self] in
            if searchText == "" { // 값 없을때
                if activityIndicator.isAnimating {
                    activityIndicator.stopAnimating()
                    searchBar.searchTextField.leftView?.isHidden = false
                }
            }
            else { // 값있을때
                if !activityIndicator.isAnimating {
                    searchBar.searchTextField.leftView?.isHidden = true
                    activityIndicator.startAnimating()
                }
            }
            searchGuideView.isHidden = true
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async(qos: .userInteractive) { [self] in
            searchGuideView.isHidden = true
            if activityIndicator.isAnimating {
                searchBar.searchTextField.leftView?.isHidden = false
                activityIndicator.stopAnimating()
            }
            searchVC.dismiss(animated: true)
        }
    }
    
}

extension MKMapLocalSearchViewController: MKResultsLocalSearchTableViewControllerDelegate {
    func didTapPlace(coordinate: CLLocationCoordinate2D, placeName: String, placeTitle: String) {
        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
            searchVC.searchBar.resignFirstResponder()
            searchVC.dismiss(animated: true, completion: nil)
            searchVC.searchBar.text = placeName
        })
        moveLocation(latitudeValue: coordinate.latitude, longtudeValue: coordinate
            .longitude, delta: 0.01)
        setAnnotation(latitudeValue: coordinate.latitude, longitudeValue: coordinate.longitude, delta: 0.01, title: placeName, subtitle: placeTitle)
        self.meetUpPlace.latitude = coordinate.latitude
        self.meetUpPlace.longitude = coordinate.longitude
        self.meetUpPlace.address = placeTitle
        findAddress(lat: coordinate.latitude, long: coordinate.longitude) { (centerAddress) in
            self.meetUpPlace.locality = centerAddress?.locality
            self.saveButton.isEnabled = true
        }
    }
}


