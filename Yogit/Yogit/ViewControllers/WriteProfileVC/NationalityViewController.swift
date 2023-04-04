//
//  nationalityViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/03.
//

import UIKit

struct Country {
    let countryCode: String
    let countryName: String
    let countryEmoji: String
    
    init(countryCode: String, countryName: String, countryEmoji: String) {
        self.countryCode = countryCode
        self.countryName = countryName
        self.countryEmoji = countryEmoji
    }
}

protocol NationalityProtocol: AnyObject {
    func nationalitySend(nationality: Country)
}

class NationalityViewController: UIViewController {
    // MARK: - TableView
    // 이미지도 같이
//    let nationalityData: [String] = ["Korea", "USA"]
    
    private var countries = [Country]()
    private var filteredCountries = [Country]()
    
    weak var delegate: NationalityProtocol?
    
   
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    private let nationalityTableView: UITableView = {
        let tableView = UITableView()
        // register new cell
        // self: reference the type object
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav()
        configureSearchController()
        configureNationalityTableView()
        configureCountries()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // frame: the view’s location and size in its superview’s coordinate system.
        // bound: the view’s location and size in its own coordinate system.
        nationalityTableView.frame = view.bounds
    }
    
    private func configureCountries() {
        let allCountryCodes = NSLocale.isoCountryCodes
        let countries = allCountryCodes.map { (code:String) -> Country  in
            let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let localeIdentifier = Locale.preferredLanguages.first ?? "" // en-KR
            let countryName = NSLocale(localeIdentifier: localeIdentifier).displayName(forKey: NSLocale.Key.identifier, value: identifier) ?? "" // localize
            print(code)
            return Country(countryCode: code, countryName: countryName, countryEmoji: code.emojiFlag)
        }
        
        let region = Locale.current.region?.identifier
//        let firstUserCountries = countries.sorted { (a, b) -> Bool in
//            return a.countryName < b.countryName
//        }
        let firstUserCountries = countries.sorted { (a, b) -> Bool in
            if a.countryCode == region {
                return true
            } else if b.countryCode == region {
                return false
            } else {
                return a.countryName < b.countryName
            }
        }
        self.countries = firstUserCountries //countries.sorted { $0.countryName < $1.countryName }
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            self.nationalityTableView.reloadData()
        })
    }
    
    private func configureView() {
        view.addSubview(nationalityTableView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureNav() {
        navigationItem.title = "NATIONALITY_NAVIGATIONITEM_TITLE".localized()
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "NATIONALITY_SEARCHBAR_PLACEHOLDER".localized()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureNationalityTableView() {
        nationalityTableView.dataSource = self
        nationalityTableView.delegate = self
    }
    
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure content
        // Similar View - ViewModel arhitecture
        var content = cell.defaultContentConfiguration()
        if isFiltering {
            content.text = filteredCountries[indexPath.row].countryEmoji + " " + filteredCountries[indexPath.row].countryName
        } else {
            content.text = countries[indexPath.row].countryEmoji + " " + countries[indexPath.row].countryName
        }
        // Customize appearence
        cell.contentConfiguration = content
        return cell
    }
}

extension NationalityViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCountries.count : countries.count
    }
}

extension NationalityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFiltering {
            delegate?.nationalitySend(nationality: filteredCountries[indexPath.row])
        } else {
            delegate?.nationalitySend(nationality: countries[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension NationalityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // 검색시 그전에 열린 섹션은 인덱스에 벗어남 따라서 검색시에는 그전에 열렸던 섹션 닫아줘야한다.
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        filteredCountries = countries.filter {
            $0.countryName.lowercased().contains(text)
        }
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            self.nationalityTableView.reloadData()
        })
    }
}

extension String {
    var emojiFlag: String {
        let flag = unicodeScalars.reduce("") {
            if #available(iOS 13.0, *) {
                return $0 + String(UnicodeScalar(127397 + $1.value)!)
            } else {
                // Fallback on earlier versions
                return $0 + String(UnicodeScalar(127397 + $1.value)!)
            }
        }
        return flag
    }
}

extension NationalityViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.searchController?.searchBar.searchTextField.resignFirstResponder()
    }
}

