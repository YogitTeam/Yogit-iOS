
//
//  SearchViewController.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/02.
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
class MKMapLocalSearchViewController: UIViewController, MKMapViewDelegate {
    
    // 좌표 초기값
    // defualt 현재 국가로 표시
    // 권한 받기
    // 권한 잇으면 현재 위치로 이동
    // 권한 없으면 유저가 수동적으로 이동
    // 카메라 줌인 높이 설정
    
    // 마커 중앙값 고정
    
    // 주소 검색 창
    // 해당 주소로 맵 이동
    
    // 맵에서 중앙좌표 읽어 오는 함수
    // 좌표 주소로 변환 함수 (Full address, adminstieview 저장)
    
    // 주소 결과값
    // 기본 주소
    // 상세주소 텍스트 필드 (강남역 2번 출구)
    
    // 1.0초지 났는지 확인 (지도 범위 이동후)
    // 1.0초지 났는지 확인 (텍스트 입력했는지 확인)
    // 지났으면 확인후 updateSearch 요청

    // 마지막 글자 입력후 요청해야함
    // 글자 업데이트마다 현재시간으로 시간으로 리셋
    // 글자 업데이트시 특정 인터벌 시간 지났는지 확인
    
    
    // 초기값
    // 메인: 지도에서 장소 및 주소 검색창
    // 서브: 지도를 움직이면서 위치 지정 (Switch button)
    // 화면 초기값: 검색 유도 후, 검색창 dimiss후 서브 버튼 보여지게 (inactive)
    // 검색 리스트 선택시: 서브 버튼 inactive
    // 서브 버튼 active시 검색 output anotation 제거후, 핀 view 중앙값 고정
    
    
    // 검색시: 검색 리스트 탭 >> 기존 anotioon 제거 및 서브 버튼 inactive
    // 검색 리스트 탭시 >> anotation 생성 및 title, subtitle 제공
    // 서브 버튼: 초기값 inactive & hide=true / 검색창 한번 들리면 hide=false, active시 기존 anotation 제거
    // 서브 버튼 Inactive하면 화면 중앙 핀 hide=true, active 하면 핀 hide false
    
    
    // new logic
    //. button hide=true
    // search location >> tap >> button hide = false
    // success search location >> add 상세주소
    // if don't represent location >> 상세주소 직접입력으로 변경
    
//    private var searchCompleter = MKLocalSearchCompleter()
    
    
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
//   private var searchResults = [MKLocalSearchCompletion]()
    weak var timer: Timer?

    private let searchVC = UISearchController(searchResultsController: MKResultsLocalSearchTableViewController())

//    private var geoRunTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
    private var searchRunTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
//    private let geoTimer: Selector = #selector(Geo_Tick_TimeConsole) // 위치 확인 타이머
    private let searchTimer: Selector = #selector(Search_Tick_TimeConsole) // search 확인 타이머
    
    private let mapView = MKMapView()
    
    private let locationManager = CLLocationManager()   // 위치 객체
    
    private var meetUpPlace = MeetUpPlace() {
        didSet {
            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                if meetUpPlace.latitude == nil {
                    saveButton.isEnabled = false
                    saveButton.backgroundColor = .placeholderText
                } else {
                    saveButton.isEnabled = true
                    saveButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
                }
            })
        }
    }
    
    weak var delegate: MeetUpPlaceProtocol?

//    private var latitude: Double?   // 위도
//    private var longitude: Double? // 경도
//    private var address: String?
//    private var locality: String? {
//        didSet {
//            print("locality \(locality ?? "")")
//            self.saveButton.isHidden = false
//        }
//    }
    
//    private var address: String? {
//        didSet {
//            addressLabel.text = address
//        }
//    }
    
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
    
//    private let searchGuideLabel: UILabel = {
//        let label = UILabel()
//        // localized 필요
//        // Place: device lanuage
//        // Postcode: number
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
//        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
//        label.numberOfLines = 0
//        label.sizeToFit()
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
//
//    private lazy var searchGuideView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        view.isHidden = true
//        view.addSubview(searchGuideLabel)
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureView()
        configureSearchController()
        configureMapComponent()
        configureLocationManager()
//        configureGuideLabel()
        timerRun()
        searhBarNoticeView(noticeView: noticeView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mapView.frame = view.bounds
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(30)
            make.height.equalTo(44)
        }
//        searchGuideView.snp.makeConstraints { make in
//            make.top.leading.trailing.bottom.equalToSuperview()
//        }
//        searchGuideLabel.snp.makeConstraints { make in
//            make.top.equalTo(searchGuideView.safeAreaLayoutGuide)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
        activityIndicator.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.width.height.equalTo(20)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        timerQuit()
    }
    
    private func configureView() {
        view.addSubview(mapView)
        view.addSubview(saveButton)
//        view.addSubview(searchGuideView)
        view.addSubview(noticeView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureNav() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
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
    
    private func configureMapComponent() {
        self.mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    private func configureSearchController() {
        self.navigationItem.searchController = searchVC
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.delegate = self
        searchVC.searchBar.placeholder = "SEARCHBAR_PLACEHOLDER".localized()
        searchVC.searchBar.addSubview(activityIndicator)
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

    
//    func setupSearchController() {
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.placeholder = "Search Language"
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchResultsUpdater = self
//        self.navigationItem.searchController = searchController
//        self.navigationItem.hidesSearchBarWhenScrolling = false
//    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        // 정확도 설정 - 최고로 높은 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터 승인 요구
        locationManager.requestWhenInUseAuthorization()
        // 위치 업데이트 시작
        locationManager.startUpdatingLocation()
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
    
//    // reset runtimeinerval
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        geoRunTimeInterval = Date().timeIntervalSinceReferenceDate
//    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        self.delegate?.locationSend(meetUpPlace: self.meetUpPlace)
        self.navigationController?.popViewController(animated: true)
    }

}

extension MKMapLocalSearchViewController: CLLocationManagerDelegate {
    
    // 위치 권한 변경시 실행
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Check Location Authorization")
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestWhenInUseAuthorization()
            print("Location is Authorized")
        case .notDetermined: break
        case .restricted: break
        case .denied: break
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
        print("Start")
        let pLocation = locations.last // 최근 위치
        guard let lat = pLocation?.coordinate.latitude else { return }
        guard let lng = pLocation?.coordinate.longitude else { return }
        moveLocation(latitudeValue: lat, longtudeValue: lng, delta: 0.01)
        locationManager.stopUpdatingLocation()
    }

    @objc func Search_Tick_TimeConsole() {
        print("실행중")
//        searchVC.searchBar.tag = 0
        
        guard let timeInterval = searchRunTimeInterval else { return }

        let interval = Date().timeIntervalSinceReferenceDate - timeInterval

        if interval <  0.30 { return }
        
        print("timer interval 통과")
        
        guard let text = self.searchVC.searchBar.text?.lowercased(), let resultsVC = self.searchVC.searchResultsController as? MKResultsLocalSearchTableViewController else {
            return
        }
        
        
        // 37.5495209, 127.075086 (위경도로 검색 가능)
        // 좌표 검색 시켜 >> 사용자마다 주소를 로컬라이즈화(자동) 불러와서
        
        self.searchRequest.naturalLanguageQuery = text
        self.searchRequest.resultTypes = [.address, .pointOfInterest]
        self.searchRequest.region = searchRegion
        
        let search = MKLocalSearch(request: searchRequest)
        
        resultsVC.delegate = self
       
        search.start { (response, error) in
            guard let response = response, error == nil else {
                if self.searchVC.searchBar.text != nil && self.searchVC.searchBar.text != "" {
                    resultsVC.notFound()
                    DispatchQueue.main.async(qos: .userInteractive, execute: {
                        self.activityIndicator.stopAnimating()
                        self.searchVC.searchBar.searchTextField.leftView?.isHidden = false
                    })
                }
            return
            }
            
            var mapItems: [MKMapItem] = []
            for item in response.mapItems {
                if let postCode = item.placemark.postalCode {
                    print("postCode", postCode)
                    mapItems.append(item) // 우편번호만 있는 주소 값만 저장 (도, 시 제외)
                }
            }
            if mapItems.count == 0 {
                resultsVC.notFound()
                DispatchQueue.main.async(qos: .userInteractive, execute: {
                    self.activityIndicator.stopAnimating()
                    self.searchVC.searchBar.searchTextField.leftView?.isHidden = false
                })
            } else {
                DispatchQueue.main.async {
                    resultsVC.updateMK(with: mapItems)
                    self.activityIndicator.stopAnimating()
                    self.searchVC.searchBar.searchTextField.leftView?.isHidden = false
                }
            }
        }
        
        
//        searchVC.searchBar.tag = 1
//
//        updateSearchResults(for: searchVC)
    
        searchRunTimeInterval = nil
    }
    
    func forwardGeocoding(address: String, completion: @escaping (String, String) -> Void) {
        print("forwardGeocoding locality", address)
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
            let country = pm.country ?? ""
            guard let locality = pm.locality else { return }
            
            let centerAddress = "\(locality) \(pm.thoroughfare ?? "") \(pm.subThoroughfare ?? "")"
            
            let reverseGeoData = ReverGedoData(centerAddress: centerAddress, locality: locality.uppercased())
            
            self.forwardGeocoding(address: locality) { (cityName, countryCodeName) in
                print("forwardGeocoding res", cityName, countryCodeName)
            }
            completion(reverseGeoData)
        })

    }
}

extension MKMapLocalSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        print("updateSearchResults")
        // text 값 없을때
//
//        if searchController.searchBar.text == nil {
//            print("searchBar nill")
//        } else if searchController.searchBar.text == "" {
//            print("searchBar ")
//        }
//        else { // text 값있을때
//            self.searchGuideView.isHidden = true
//            if !self.activityIndicator.isAnimating { self.activityIndicator.startAnimating() }
//        }
//        if searchController.searchBar.text == nil || searchController.searchBar.text == "" {
//            self.searchGuideView.isHidden = false
//        } else { // text 값있을때
//            self.searchGuideView.isHidden = true
//            if !self.activityIndicator.isAnimating { self.activityIndicator.startAnimating() }
//        }
        
//        if !self.activityIndicator.isAnimating { self.activityIndicator.startAnimating() }
       
        searchRunTimeInterval = Date().timeIntervalSinceReferenceDate // 마지막 변경 시간
        
        
        // 인터벌 지날시
//        if searchController.searchBar.tag == 0 { return }
        
        
        
//        if searchController.searchBar.text != "" { searchGuideView.isHidden = true }
//        Search_Tick_TimeConsole()
//        if isCanRequest == false { return }
        
        // 마지막 변경후 1.00 이후 검색 요청 들어가야함
        // 검색바에 텍스트 업데이트 후 체크 하면 마지막 텍스트 입력후 업데이트 함수 요청 안된다.
        // 따라서 이 함수 밖에서 요청 들어가댜함
        // text, searchrequest 전역 변수로 저장
        
        
//
//        guard let text = searchController.searchBar.text?.lowercased(), let resultsVC = searchController.searchResultsController as? MKResultsLocalSearchTableViewController else {
//            return
//        }
        
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = text
//        searchRequest.resultTypes = [.address, .pointOfInterest]
//        searchRequest.region = searchRegion
//
//
//        let search = MKLocalSearch(request: searchRequest)
//        resultsVC.delegate = self
//        search.start { (response, error) in
//            guard let response = response else {
//                if searchController.searchBar.text != nil && searchController.searchBar.text != "" {
//                    resultsVC.notFound()
//                    self.activityIndicator.stopAnimating()
//                    self.searchVC.searchBar.searchTextField.leftView?.isHidden = false
//                    print("\(searchController.searchBar.text) 죄송합니다 값을 찾을수 없습니다.")
//                }
//            return }
//            // let placeMarkSubtitle = item.placemark.subtitle
//            for item in response.mapItems {
//                if let name = item.name,
//                   let location = item.placemark.location,
//                   let placeMarkName = item.placemark.name,
//                   let placeMarkTitle = item.placemark.title,
//                   let placeMarkPhoneNumber = item.phoneNumber
//                {
//                    print("\(name)")
//                    print("\(location.coordinate.latitude),\(location.coordinate.longitude)")
//                    print("\(placeMarkName)")
//                    print("\(placeMarkTitle)")
////                    print("\(placeMarkSubtitle)")
//                    print("\(placeMarkPhoneNumber)")
//                }
//            }
//            DispatchQueue.main.async {
//                resultsVC.updateMK(with: response.mapItems)
//                self.activityIndicator.stopAnimating()
//                self.searchVC.searchBar.searchTextField.leftView?.isHidden = false
//            }
//        }
        
        

        
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
        print("시작 searchBar")
        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
//            self.searchGuideView.isHidden = false // 가이드뷰 숨김
            if !noticeView.isHidden { noticeView.isHidden = true }
            if self.activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
                searchBar.searchTextField.leftView?.isHidden = false
            }
        })
    }

    // 입력하다 지웠을때나, 값 변경
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("변경 searchBar")
        
        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
            if searchText == "" { // 값 없을때
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                    searchBar.searchTextField.leftView?.isHidden = false
                }
            }
            else { // 값있을때
                if !self.activityIndicator.isAnimating {
                    searchBar.searchTextField.leftView?.isHidden = true
                    self.activityIndicator.startAnimating()
                }
            }
//            self.searchGuideView.isHidden = true
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search bar 취소 버튼 클릭")
        
        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
//            self.searchGuideView.isHidden = true
            if activityIndicator.isAnimating {
                searchBar.searchTextField.leftView?.isHidden = false
                activityIndicator.stopAnimating()
            }
            searchVC.dismiss(animated: true)
        })
    }
    
//    func searchBarTextDidEndEditing(_ searchBar:UISearchBar) {
//        print("검색완료")
//    }
//
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        print("searchBarShouldDidBeginEditing")
//        return true
//    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("change text")
//    }
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
            print("meetUpPlace = \(self.meetUpPlace)")
        }
    }
}


