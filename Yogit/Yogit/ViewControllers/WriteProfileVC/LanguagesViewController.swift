

import UIKit
import SnapKit

struct SectionLanguage: Hashable {
    let code: String
    let title: String
    let options: [Int]
    var opened: Bool
    
    init(code: String, title: String, options: [Int], opened: Bool = false) {
        self.code = code
        self.title = title
        self.options = options
        self.opened = opened
    }
}

protocol LanguageProtocol {
    func languageSend(languageCode: String, language: String, level: Int)
}

class LanguagesViewController: UIViewController {
    
    // MARK: - Data
    
//    var lang = ["English", "Korean", "Japanese", "Chinese", "fdfdf", "wqwq"]

    private var sections = [SectionLanguage]()
    
    var userLangs: [String]?
    
    var delegate: LanguageProtocol?
    
    private var oldSection: Int? = nil
    private var oldFilterSection: Int? = nil
    
    private var filteredSections = [SectionLanguage]()
    
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    // MARK: - Property
    
    private let languagesTableView: UITableView = {
        let tableView = UITableView()
//        tableView.separatorStyle = .none
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .systemGray
        tableView.backgroundColor = .systemBackground
        tableView.register(LanguagesTableViewCell.self, forCellReuseIdentifier: "LanguagesTableViewCell")
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let global friends know what I can speak 🗣"
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60)
        view.addSubview(titleLabel)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("처음 oldfilter section \(oldFilterSection)")
//        sections = [
//            Section(title: "English", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
//            Section(title: "Chinese", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
//            Section(title: "Korean", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
//            Section(title: "Spanish", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
//            Section(title: "French", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
//            Section(title: "Italian", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
//            Section(title: "Japanese", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"])
//        ]
        configureViewComponent()
        setLanguages()
        duplicateRemove(userLanuages: userLangs)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        languagesTableView.frame = view.bounds
        languagesTableView.tableHeaderView = titleView
        languagesTableView.tableHeaderView?.layer.addBorderWithMargin(arr_edge: [.bottom], marginLeft: 16, marginRight: 0, color: .systemGray3, width: 0.7, marginTop: 0)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(0)
        }
    }
    
    private func configureViewComponent() {
        self.view.addSubview(languagesTableView)
        self.navigationItem.title = "Language"
        self.setupSearchController()
        self.view.backgroundColor = .systemBackground
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
    }
    
    private func setLanguages() {
        let languageCodes = NSLocale.isoLanguageCodes
        
        // 원어
//        for code in languageCodes {
//            let locale = Locale(identifier: code)
//            guard let language = locale.localizedString(forIdentifier: code) else { return } // 원문
////            let localeEng = Locale(identifier: "ko_KR")
////            guard let engName = localeEng.localizedString(forLanguageCode: code) else { return } // engName
//            sections.append(Section(code: code, title: language, options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]))
//        }
        
        // 로컬라이즈
        var languages = [SectionLanguage]()
        guard let identifier = Locale.preferredLanguages.first else {return }// en-KR
        let locale = Locale(identifier: identifier) // 현지화
        let localLangCode = identifier.prefix(2)
        for code in languageCodes {
            print("code", code)
            let originLocale = Locale(identifier: code)
            // 로컬라이즈 언어, 원문
            if let language = locale.localizedString(forIdentifier: code), let originLanguage = originLocale.localizedString(forIdentifier: code) {
                if language != originLanguage || code == localLangCode { // 해당 원어로 변환 안되는 언어는 제외 (고대 언어나 극히 적게 쓰이는 언어임)
                    languages.append(SectionLanguage(code: code, title: "\(language) (\(originLanguage))", options: [0, 1, 2, 3]))
                }
            }
        }
        let sortedLanguages = languages.sorted { (a, b) -> Bool in
            if a.code == localLangCode {
                return true
            } else if b.code == localLangCode {
                return false
            } else {
                return a.title < b.title
            }
        }
        sections = sortedLanguages
        
//        guard let identifier = Locale.preferredLanguages.first else {return }// en-KR
//        let locale = Locale(identifier: identifier)
//        sections = sortedLanguages.sorted { $0.title < $1.title }
//        sections = sortedLanguages.sorted { $0.title.components(separatedBy: " (")[0].lowercased() < $1.title.components(separatedBy: " (")[0].lowercased() }
        
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            self.languagesTableView.reloadData()
        })
    }
    
    private func duplicateRemove(userLanuages: [String]?) {
        if userLanuages != nil {
            for i in 0..<userLanuages!.count {
                self.sections = self.sections.filter { $0.code != userLanuages![i] } // title.hasPrefix(userLanuages![i])
            }
        }
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Language"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}


// MARK: - UITableViewDelegate

extension LanguagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 셀 선택 시 회색에서 다시 변하게 해주는 것
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            if isFiltering { // 열린와중에 검색여 선택시 에러
                // 검색시 그전에 열린 섹션은 인덱스에 벗어남 따라서 검색시에는 그전에 열렸던 섹션 닫아줘야한다.
                print("섹션 벗어남 \(oldFilterSection)") // 0
                print("필터 배열 개수 \(filteredSections.count)") // 1
                if oldFilterSection != nil && oldFilterSection != indexPath.section && filteredSections[oldFilterSection!].opened == true  { // 처음 아니고, 그전 섹션이랑 다르고, 열려있으면
                    // 섹션 벗어남 filter 0 까지 인데 1 연거임
//                    print("섹션 벗어남 \(oldFilterSection)"
//                    print("필터 배열 개수 \(filteredSections.count)")
                    filteredSections[oldFilterSection!].opened = false // 닫아줌
                    tableView.reloadSections([oldFilterSection!], with: .automatic) // 업데이트
                    print("old fitler sections reload")
                }
                filteredSections[indexPath.section].opened = !filteredSections[indexPath.section].opened // 현재 오픈 토글
                tableView.reloadSections([indexPath.section], with: .automatic) // 업데이트
                oldFilterSection = indexPath.section // 현재 필터 인덱스로 업데이트 1
                print("now fitler sections reload")
            } else {
                if oldSection != nil && oldSection != indexPath.section && sections[oldSection!].opened == true { // 그전 섹션이랑 다르면
                    sections[oldSection!].opened = false
                    tableView.reloadSections([oldSection!], with: .automatic)
                    print("now sections reload  old")
                }
                sections[indexPath.section].opened = !sections[indexPath.section].opened
                tableView.reloadSections([indexPath.section], with: .automatic)
                oldSection = indexPath.section
                print("now sections reload  old")
            }
        }
        else {
            print([indexPath.section], [indexPath.row])
            if isFiltering {
                print(filteredSections[indexPath.section].title, filteredSections[indexPath.section].options[indexPath.row - 1])
                delegate?.languageSend(languageCode: filteredSections[indexPath.section].code, language: filteredSections[indexPath.section].title, level: filteredSections[indexPath.section].options[indexPath.row - 1])
            } else {
                print(sections[indexPath.section].title, sections[indexPath.section].options[indexPath.row - 1])
                delegate?.languageSend(languageCode: sections[indexPath.section].code, language: sections[indexPath.section].title, level: sections[indexPath.section].options[indexPath.row - 1])
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 52
        default: return 48
        }
    }
    

}


// MARK: - UITableViewDataSource

extension LanguagesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering ? filteredSections.count : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredSections[section].opened ? filteredSections[section].options.count + 1 : 1
        } else {
            return sections[section].opened ? sections[section].options.count + 1 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LanguagesTableViewCell()
        if indexPath.row == 0 {
            if isFiltering {
                cell.configure(text: filteredSections[indexPath.section].title, isSelected: filteredSections[indexPath.section].opened)
            } else {
                cell.configure(text: sections[indexPath.section].title, isSelected: sections[indexPath.section].opened)
            }
        } else {
            if isFiltering {
                // "      "
                cell.configure(text: LanguageLevels(rawValue: filteredSections[indexPath.section].options[indexPath.row - 1])?.toString() ?? "", isSelected: nil)
            } else {
                cell.configure(text: LanguageLevels(rawValue: sections[indexPath.section].options[indexPath.row - 1])?.toString() ?? "", isSelected: nil)
            }
            if indexPath.row != 4 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
            }
        }
        cell.selectionStyle = .blue
        return cell
    }
}

extension LanguagesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // 검색시 그전에 열린 섹션은 인덱스에 벗어남 따라서 검색시에는 그전에 열렸던 섹션 닫아줘야한다.
        print("필터링")
        
        
        if isFiltering {
            if oldFilterSection != nil {
                filteredSections[oldFilterSection!].opened = false
                oldFilterSection = nil
            }
        } else {
            if oldSection != nil {
                sections[oldSection!].opened = false
                oldSection = nil
            }
        }
        
        guard let text = searchController.searchBar.text?.lowercased() else { return }
//        self.filteredSections = self.sections.filter { $0.title.lowercased().hasPrefix(text) } // hasPrefix(text) " "로 분리한다
        let localizedSections = self.sections.filter { $0.title.components(separatedBy: " (")[0].lowercased().hasPrefix(text) }
        let originLangSections = self.sections.filter { $0.title.components(separatedBy: " (")[1].lowercased().hasPrefix(text) }
        let duplicatedArray = localizedSections + originLangSections
        self.filteredSections = Array(Set(duplicatedArray))
        
        print("filter = \(filteredSections)")
        print("filter count = \(filteredSections.count)")
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            self.languagesTableView.reloadData()
        })
    }
}

extension LanguagesViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationItem.searchController?.searchBar.searchTextField.resignFirstResponder()
    }
}
