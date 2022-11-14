

import UIKit
import SnapKit

struct Section {
    let title: String
    let options: [String]
    var opened: Bool
    
    init(title: String, options: [String], opened: Bool = false) {
        self.title = title
        self.options = options
        self.opened = opened
    }
}

protocol LanguageProtocol {
    func languageSend(language: String, level: String)
}

class LanguagesViewController: UIViewController {
    
    // MARK: - Data
    
//    var lang = ["English", "Korean", "Japanese", "Chinese", "fdfdf", "wqwq"]
    
    private var sections = [Section]()
    
    var userLangs: [String]?
    
    var delegate: LanguageProtocol?
    
    private var oldSection: Int? = nil
    private var oldFilterSection: Int? = nil
    
    private var filteredSections: [Section] = []
    
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
        tableView.backgroundColor = .systemBackground
        tableView.register(LanguagesTableViewCell.self, forCellReuseIdentifier: "LanguagesTableViewCell")
        return tableView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("처음 oldfilter section \(oldFilterSection)")
        sections = [
            Section(title: "English", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
            Section(title: "Chinese", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
            Section(title: "Korean", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
            Section(title: "Kornag", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
            Section(title: "kdada", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
            Section(title: "Jann", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]),
            Section(title: "Japanese", options: ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"])]
        duplicateRemove(userLanuages: userLangs)
        configureViewComponent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        languagesTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
    
    private func duplicateRemove(userLanuages: [String]?) {
        if userLanuages != nil {
            for i in 0..<userLanuages!.count {
                self.sections = self.sections.filter { !$0.title.hasPrefix(userLanuages![i]) }
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
                delegate?.languageSend(language: filteredSections[indexPath.section].title, level: filteredSections[indexPath.section].options[indexPath.row - 1])
            } else {
                print(sections[indexPath.section].title, sections[indexPath.section].options[indexPath.row - 1])
                delegate?.languageSend(language: sections[indexPath.section].title, level: sections[indexPath.section].options[indexPath.row - 1])
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 52
        default: return 44
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
                cell.configure(text: "      " + filteredSections[indexPath.section].options[indexPath.row - 1], isSelected: nil)
            } else {
                cell.configure(text: "      " + sections[indexPath.section].options[indexPath.row - 1], isSelected: nil)
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        }
        cell.selectionStyle = .blue
        return cell
    }
}

extension LanguagesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // 검색시 그전에 열린 섹션은 인덱스에 벗어남 따라서 검색시에는 그전에 열렸던 섹션 닫아줘야한다.
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
        self.filteredSections = self.sections.filter { $0.title.lowercased().hasPrefix(text) }
        print("filter = \(filteredSections)")
        print("filter count = \(filteredSections.count)")
//        dump(filteredArr)
        languagesTableView.reloadData()
//        languagesTableView.reloadSections(IndexSet(integer: <#T##IndexSet.Element#>), with: <#T##UITableView.RowAnimation#>)
//        print("isfilter \(isFiltering)")
//        dump(searchController.searchBar.text)
    }
}


