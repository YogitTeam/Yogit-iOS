//
//  GatheringBoardCategoryViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/10.
//

import UIKit

enum Mode {
    case post
    case edit
}

class GatheringBoardCategoryViewController: UIViewController {
    
//    let stateDefaultView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .placeholderText
//        view.layer.cornerRadius = 3
//        return view
//    }()
//    
//    let stateStepView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        view.layer.cornerRadius = 3
//        return view
//    }()
    
//    lazy var myGatheringBoardView = MyGatheringBoardView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), step: 1)
    
    let step = 1.0
    
    var tapIndex: Int? = nil
    
    let categoryText = ["Daily Spot", "Traditional Culture", "Nature", "Language exchange"]
    let categoryDescription = ["example, example, example", "example, example, example", "example, example, example", "example, example, example"]
    
//    let stepViewHeader = StepHeaderView()
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
//        tableView.allowsSelection = false
//        tableView.isUserInteractionEnabled = false
//        tableView.separatorInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        tableView.register(GatheringBoardCategoryTableViewCell.self, forCellReuseIdentifier: GatheringBoardCategoryTableViewCell.identifier)
//        tableView.register(StepHeaderView.self, forHeaderFooterViewReuseIdentifier: StepHeaderView.identifier)
//        tableView.tableHeaderView = StepHeaderView()
        

//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tableView
    }()
    
//    lazy var stateDefaultView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .placeholderText
//        view.addSubview(stateStepView)
//        view.layer.cornerRadius = 3
//        return view
//    }()
//
//    let stateStepView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        view.layer.cornerRadius = 3
//        return view
//    }()
//
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .white
//        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
//        label.sizeToFit()
//        label.text = "Choose Category"
//        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(myGatheringBoardView)
//        view.addSubview(stateDefaultView)
//        view.addSubview(titleLabel)
        view.addSubview(categoryTableView)
        configureViewComponent()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        categoryTableView.frame = view.bounds
//        stateDefaultView.snp.makeConstraints { make in
//            make.height.equalTo(5)
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.width.equalTo(120)
//            make.centerX.equalToSuperview()
////            make.leading.trailing.equalToSuperview().inset(118)
//        }
//        stateStepView.snp.makeConstraints { make in
//            make.height.equalTo(5)
//            make.top.bottom.leading.equalToSuperview()
//            make.width.equalTo(40)
//        }
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(stateDefaultView.snp.bottom).offset(20)
//            make.leading.equalToSuperview().inset(20)
//        }
        categoryTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            
//            make.top.equalTo(titleLabel.snp.bottom).offset(30)
//            make.leading.trailing.bottom.equalToSuperview()
//            make.edges.leading.trailing.bottom.equalToSuperview()
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalToSuperview()
        }
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .white
    }
    
    @objc func categoryContentViewTapped(sender: UITapGestureRecognizer) {
        // toggle 값
        tapIndex == sender.view?.tag ? (tapIndex = nil) : (tapIndex = sender.view?.tag)
        categoryTableView.reloadData()
        print(sender.view?.tag)
        // reload >> change color
        
        
//        guard let cell = tableView(categoryTableView, cellForRowAt: IndexPath(row: sender.view?.tag ?? 0, section: 0)) as? GatheringBoardCategoryTableViewCell else { return }
//        cell.categoryContentView.backgroundColor = .brown
    }
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GatheringBoardCategoryTableViewCell.identifier, for: indexPath) as? GatheringBoardCategoryTableViewCell else { return UITableViewCell() }
        
        cell.categoryImageView.image = UIImage(named: categoryText[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.categoryTitleLabel.text = categoryText[indexPath.row]
        cell.categoryDescriptionLabel.text = categoryDescription[indexPath.row]
        cell.categoryContentView.tag = indexPath.row
        cell.categoryContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.categoryContentViewTapped(sender:))))
        
        // 기존 탭한 값 있으면 istapped false로 바꿈
//        tapIndex == indexPath.row ? (cell.isTapped = true) : (cell.isTapped = false) // 현재
        
        if tapIndex == nil {
            cell.isTapped = nil
        } else if tapIndex == indexPath.row {
            cell.isTapped = true
        } else {
            cell.isTapped = false
        }
    
//        cell.directionalLayoutMargins = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        // Configure content
        // Similar View - ViewModel arhitecture
//        var content = cell.defaultContentConfiguration()
//        content.text = categoryText[indexPath.row]
//        content.secondaryText = secondText[indexPath.row]
//        content.image = UIImage(named: categoryText[indexPath.row])
//        // Customize appearence
//        content.textProperties.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
//        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        cell.frame = cell.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 8))
//        cell.layer.cornerRadius = 10
//        cell.layer.borderColor = UIColor(rgb: 0xBDBDBD, alpha: 1.0).cgColor
//        cell.layer.borderWidth = 1
////        cell.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
//        cell.contentConfiguration = content
//        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
//        cell.layoutIfNeeded()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = StepHeaderView()
        headerView.step = self.step
        headerView.titleLabel.text = "Category"
//        headerView.layoutIfNeeded()
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SetUpProfileTableViewHeader.identifier) as? SetUpProfileTableViewHeader else { return UITableViewHeaderFooterView() }
        
        return headerView
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 100
//    }
}

extension GatheringBoardCategoryViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)
//        // 선택시 셀 색 변경흐 버튼 on
//        print("dfdsfdfdf")
//
//    }
}

extension GatheringBoardCategoryViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryText.count
    }
}
