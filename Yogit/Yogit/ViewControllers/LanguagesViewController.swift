//
//  LanguagesViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/30.
//

import UIKit
import SnapKit

struct CellData {
    var opened: Bool = false
    var title: String
    var sectionData = ["Beginner", "Elementary", "Intermediate", "Fluent", "Native"]
}

class LanguagesViewController: UIViewController {
    
    // MARK: - Data
    
    var lang = ["English", "Korean", "Japanese", "Chinese"]
    
    var tableViewData: [CellData] = [
        CellData(title: "English"),
        CellData(title: "Korean"),
        CellData(title: "Japanese"),
        CellData(title: "Chinese"),
        CellData(title: "Jann")
    ]
    
    var filteredArr: [CellData] = []
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    // MARK: - Property
    
    private let languagesTableView: UITableView = {
        let tableView = UITableView()
//        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(LanguagesTableViewCell.self, forCellReuseIdentifier: "LanguagesTableViewCell")
        return tableView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponent()
    }
    
    override func viewDidLayoutSubviews() {
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
        
        // section 부분 선택하면 열리게 설정
//        if indexPath.row == 0 {
//            // section이 열려있다면 다시 닫힐 수 있게 해주는 코드
//            tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
////            tableView.cellForRow(at: indexPath)?.contentView.con
//            // 모든 데이터를 새로고침하는 것이 아닌 해당하는 섹션 부분만 새로고침
//            tableView.reloadSections([indexPath.section], with: .none)
//
//        // sectionData 부분을 선택하면 아무 작동하지 않게 설정
//        }
//        else {
//            print([indexPath.section], [indexPath.row])
//            print(tableViewData[indexPath.section].title, tableViewData[indexPath.section].sectionData[indexPath.row - 1])
//            //            print("이건 sectionData 선택한 거야")
//        }
        
        if isFiltering {
            if indexPath.row == 0 {
                // section이 열려있다면 다시 닫힐 수 있게 해주는 코드
                filteredArr[indexPath.section].opened = !filteredArr[indexPath.section].opened
    //            tableView.cellForRow(at: indexPath)?.contentView.con
                // 모든 데이터를 새로고침하는 것이 아닌 해당하는 섹션 부분만 새로고침
                tableView.reloadSections([indexPath.section], with: .none)
            
            // sectionData 부분을 선택하면 아무 작동하지 않게 설정
            }
            else {
                print([indexPath.section], [indexPath.row])
                print(filteredArr[indexPath.section].title, filteredArr[indexPath.section].sectionData[indexPath.row - 1])
                //            print("이건 sectionData 선택한 거야")
            }
        } else {
            if indexPath.row == 0 {
                // section이 열려있다면 다시 닫힐 수 있게 해주는 코드
                tableViewData[indexPath.section].opened = !tableViewData[indexPath.section].opened
    //            tableView.cellForRow(at: indexPath)?.contentView.con
                // 모든 데이터를 새로고침하는 것이 아닌 해당하는 섹션 부분만 새로고침
                tableView.reloadSections([indexPath.section], with: .none)
            
            // sectionData 부분을 선택하면 아무 작동하지 않게 설정
            }
            else {
                print([indexPath.section], [indexPath.row])
                print(tableViewData[indexPath.section].title, tableViewData[indexPath.section].sectionData[indexPath.row - 1])
                //            print("이건 sectionData 선택한 거야")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 50
        default: return 44
        }
    }
    

}


// MARK: - UITableViewDataSource

extension LanguagesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering ? filteredArr.count : tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableViewData[section].opened == true {
//            // tableView Section이 열려있으면 Section Cell 하나에 sectionData 개수만큼 추가해줘야 함
////            return self.isFiltering ? self.filteredArr[section].sectionData.count + 1 : self.tableViewData[section].sectionData.count + 1
//            print("filter = \(filteredArr)")
//            print("filter count = \(filteredArr.count)")
//            print("Data = \(tableViewData)")
//            print("data count = \(tableViewData.count)")
//            return tableViewData[section].sectionData.count + 1
//        } else {
//            // tableView Section이 닫혀있을 경우에는 Section Cell 하나만 보여주면 됨
//            return 1
//        }
        
        if isFiltering {
            if filteredArr[section].opened == true {
                return filteredArr[section].sectionData.count + 1
            } else {
                return 1
            }
        } else {
            if tableViewData[section].opened == true {
                return tableViewData[section].sectionData.count + 1
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // section 부분 코드
        print("indexpathrow = \(indexPath.row)")
        let cell = LanguagesTableViewCell()
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguagesTableViewCell", for: indexPath)
//                as? LanguagesTableViewCell else { return UITableViewCell() }
        
//        cell.configureUI()
        
        if indexPath.row == 0 {
//            cell.tableLabel.text = tableViewData[indexPath.section].title
            cell.tableLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
            if tableViewData[indexPath.section].opened == true {
                cell.configure(color: .systemBlue)
            }
            cell.tableLabel.text = isFiltering ? filteredArr[indexPath.section].title : tableViewData[indexPath.section].title
//            if self.isFiltering {
//                cell.tableLabel.text = self.filteredArr[indexPath.section].title
//
//            } else {
//                cell.tableLabel.text = self.tableViewData[indexPath.section].title
//            }
            
//            cell.addViewBorder(withColor: .placeholderText, width: 0.3)
        // sectionData 부분 코드
        } else {
            cell.tableLabel.text = isFiltering ? "    " + filteredArr[indexPath.section].sectionData[indexPath.row - 1] : "    " + tableViewData[indexPath.section].sectionData[indexPath.row - 1]
//            cell.tableLabel.text = "    " + tableViewData[indexPath.section].sectionData[indexPath.row - 1]
        }

        

        
        return cell
        
    }
    
}

extension LanguagesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.filteredArr = self.tableViewData.filter { $0.title.lowercased().hasPrefix(text) }
        print("filter = \(filteredArr)")
        print("filter count = \(filteredArr.count)")
//        dump(filteredArr)
        languagesTableView.reloadData()
//        print("isfilter \(isFiltering)")
//        dump(searchController.searchBar.text)
    }


}

extension LanguagesViewController: UISearchBarDelegate {

}
