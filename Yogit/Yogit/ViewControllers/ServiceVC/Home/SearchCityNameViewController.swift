//
//  SearchCityNameViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/04/29.

import UIKit
import CoreLocation

protocol SearchCityNameProtocol: AnyObject {
    func cityNameSend(cityNameLocalized: String)
}

class SearchCityNameViewController: UIViewController {
    // MARK: - TableView
    // 이미지도 같이
    
    // init
    // 검색어 빈값/nil값/취소버튼 = 전국
    // 검색어 있을시 (전국 제외) = 검색어 값
    // 도시이름 통신
    
    weak var timer: Timer?
    
    weak var delegate: SearchCityNameProtocol?
    
    private let setCountryCode = SessionManager.getSavedCountryCode()
    private let defaultCityName = "NATIONWIDE"
    private lazy var cities: [String] = [defaultCityName]
    private var searchRunTimeInterval: TimeInterval? // 마지막 작업을 설정할 시간
    private let searchTimer: Selector = #selector(Search_Tick_TimeConsole) // search 확인 타이머

    
    private let citiesTableView: UITableView = {
        let tableView = UITableView()
        // register new cell
        // self: reference the type object
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftButtonPressed(_:)))
        button.tintColor = .label
        return button
    }()
    
//    private let searchGuideLabel: UILabel = {
//        let label = UILabel()
//        label.text = "SEARCH_GUIDE_TITLE".localized()
//
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
//
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureNav()
        configureSearchController()
        configureCitiesTableView()
        timerRun()
//        configureCountries()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerQuit()
    }
    
    private func configureView() {
        view.addSubview(citiesTableView)
//        view.addSubview(searchGuideView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        citiesTableView.frame = view.bounds
//        searchGuideView.snp.makeConstraints { make in
//            make.top.leading.trailing.bottom.equalToSuperview()
//        }
//        searchGuideLabel.snp.makeConstraints { make in
//            make.top.equalTo(searchGuideView.safeAreaLayoutGuide).offset(6)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
        activityIndicator.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.width.height.equalTo(20)
            make.bottom.equalToSuperview().inset(22)
        }
    }
    
    private func configureNav() {
        navigationItem.title = "SEARCH_CITY_NAME_NAVIGATIONITEM_TITLE".localized()
        navigationItem.leftBarButtonItem = leftButton
    }
    
    private func resetCities() {
        cities.removeAll()
        cities.append(defaultCityName)
        citiesTableView.reloadData()
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
    
    @objc private func leftButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc func Search_Tick_TimeConsole() {
        guard let timeInterval = searchRunTimeInterval else { return }

        let interval = Date().timeIntervalSinceReferenceDate - timeInterval

        if interval <  0.30 { return }
        
        guard let searchController = navigationItem.searchController else { return }
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        
        forwardGeocoding(address: text) { [weak self] (cityNames) in
            if let cityNames = cityNames, cityNames.count != 0 {
                self?.cities = cityNames
                DispatchQueue.main.async(qos: .userInteractive) {
                    self?.citiesTableView.reloadData()
                }
            } else {
                self?.resetCities()
            }
            DispatchQueue.main.async(qos: .userInitiated) {
                self?.activityIndicator.stopAnimating()
                searchBar.searchTextField.leftView?.isHidden = false
                self?.citiesTableView.reloadData()
            }
        }

        searchRunTimeInterval = nil
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "SEARCH_CITY_NAME_SEARCHBAR_PLACEHOLDER".localized()
        searchController.searchBar.delegate = self
        searchController.searchBar.addSubview(activityIndicator)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func forwardGeocoding(address: String,completion: @escaping ([String]?) -> Void) {
        
        let geocoder = CLGeocoder()
       
        guard let serviceCountryCode = setCountryCode else { return }
        guard let identifier = Locale.preferredLanguages.first else { return }// en-KR
        let locale = Locale(identifier: identifier)

        // 주소 다됨 (country, locality, "KR" >> South Korea)
        geocoder.geocodeAddressString(address, in: nil, preferredLocale: locale, completionHandler: {
            (placemarks, error) in
            if error != nil {
                print("Failed to geocodeAddressString location")
                completion(nil)
            }

            guard let pms = placemarks else { return }
            
            var cityNames = [String]()
            for pm in pms {
                if let locality = pm.locality,
                   let countryCode = pm.isoCountryCode,
                   serviceCountryCode == countryCode
                {
                    cityNames.append(locality)
                }
            }
        
            completion(cityNames)
        })
    }
    
    private func configureCitiesTableView() {
        citiesTableView.dataSource = self
        citiesTableView.delegate = self
    }
    
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = cities[indexPath.row].localized()
        cell.contentConfiguration = content
        return cell
    }
}

extension SearchCityNameViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count //isFiltering ? filteredCities.count : cities.count
    }
}

extension SearchCityNameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cityNameLocalized = cities[indexPath.row]
        delegate?.cityNameSend(cityNameLocalized: cityNameLocalized)
        DispatchQueue.main.async {
            self.navigationItem.searchController?.dismiss(animated: true)
            self.dismiss(animated: true)
        }
    }
}

extension SearchCityNameViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchRunTimeInterval = Date().timeIntervalSinceReferenceDate // 마지막 변경 시간
    }
}

extension SearchCityNameViewController: UISearchBarDelegate {
    // 초기 텍스트필드 포커스
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 설명 뷰 띄우고, 검색 데이터 없데이트 완료후 view hide
  
        DispatchQueue.main.async(qos: .userInteractive) { [self] in
//            searchGuideView.isHidden = false // 가이드뷰 숨김
//            if !noticeView.isHidden { noticeView.isHidden = true }
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
                resetCities()
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
//            searchGuideView.isHidden = true
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async(qos: .userInteractive) { [self] in
//            searchGuideView.isHidden = true
            resetCities()
            if activityIndicator.isAnimating {
                searchBar.searchTextField.leftView?.isHidden = false
                activityIndicator.stopAnimating()
            }
        }
    }
    
}




