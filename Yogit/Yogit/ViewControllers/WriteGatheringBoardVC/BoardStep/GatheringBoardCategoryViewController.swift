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

    let stepHeaderView = StepHeaderView()
    
    
    let step = 1.0
    let categoryText = ["Daily Spot", "Traditional Culture", "Nature", "Language exchange"]
    let categoryDescription = ["example, example, example", "example, example, example", "example, example, example", "example, example, example"]
    
    var tapIndex: Int? = nil {
        didSet {
            print("tapIndex \(tapIndex)")
            DispatchQueue.main.async {
                if self.tapIndex != nil {
                    self.nextButton.isEnabled = true
                    self.nextButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
                } else {
                    self.nextButton.isEnabled = false
                    self.nextButton.backgroundColor = .placeholderText
                }
            }
        }
    }
    
    var createBoardReq = CreateBoardReq()
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(GatheringBoardCategoryTableViewCell.self, forCellReuseIdentifier: GatheringBoardCategoryTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.setTitle("Next", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.backgroundColor = .placeholderText
        button.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stepHeaderView)
        view.addSubview(categoryTableView)
        view.addSubview(nextButton)
        configureViewComponent()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.right.equalToSuperview()
            make.height.equalTo(40)
        }
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(stepHeaderView.snp.bottom).offset(0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(30)
            make.height.equalTo(50)
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
//    }
    
    private func configureViewComponent() {
//        self.navigationItem.title = "Category"
//        self.tabBarController?.tabBar.isHidden = true

        view.backgroundColor = .systemBackground
        stepHeaderView.step = self.step
        stepHeaderView.titleLabel.text = "Category"
    }
    
    @objc func categoryContentViewTapped(sender: UITapGestureRecognizer) {
        // 3 state toggle 값
        tapIndex == sender.view?.tag ? (tapIndex = nil) : (tapIndex = sender.view?.tag)
        categoryTableView.reloadData()
        createBoardReq.categoryId = (sender.view?.tag ?? 0) + 1
        print("Set category createBoardReq.categoryId \(createBoardReq.categoryId)")
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let GBSDVC = TestBoardViewController() // GatheringBoardOptionViewController()
            GBSDVC.createBoardReq = self.createBoardReq
            self.navigationController?.pushViewController(GBSDVC, animated: true)
        }
//        DispatchQueue.main.async {
//            let GBSDVC = GatheringBoardOptionViewController()
//            GBSDVC.createBoardReq = self.createBoardReq
//            self.navigationController?.pushViewController(GBSDVC, animated: true)
//        }
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
        
        cell.selectionStyle = .none
        return cell
    }
}

extension GatheringBoardCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = StepHeaderView()
//        headerView.step = self.step
//        headerView.titleLabel.text = "Category"
////        headerView.layoutIfNeeded()
//
//        return headerView
//    }
}

extension GatheringBoardCategoryViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryText.count
    }
}
