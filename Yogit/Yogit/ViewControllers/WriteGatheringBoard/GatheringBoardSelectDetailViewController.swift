//
//  GatheringSelectOptionViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/12.
//

import UIKit

class GatheringBoardSelectDetailViewController: UIViewController {

    let step = 2.0
    var createBoardReq = CreateBoardReq() {
        didSet {
            print("Select Detail createBoardReq.categoryId \(createBoardReq.categoryId)")
        }
    }
    
    private var numberData: [Int] = []
    
    private let placeholderData = ["Nick name", "International age", "Add conversational language", "Select gender", "Select nationaltiy"]
    
    private let numberPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let datetimePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let selectDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.sectionHeaderTopPadding = 16
        tableView.register(CommonTextFieldTableViewCell.self, forCellReuseIdentifier: CommonTextFieldTableViewCell.identifier)
        tableView.register(RequirementTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RequirementTableViewHeader.identifier)
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
        view.addSubview(selectDetailTableView)
        view.addSubview(nextButton)
        selectDetailTableView.delegate = self
        selectDetailTableView.dataSource = self
        datetimePickerView.delegate = self
        for i in 18...60 { numberData.append(i) }
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectDetailTableView.frame = view.bounds
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(30)
            make.height.equalTo(50)
        }
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let GBTDVC = GatheringBoardTextDetailViewController()
            GBTDVC.createBoardReq = self.createBoardReq
            self.navigationController?.pushViewController(GBTDVC, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GatheringBoardSelectDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = StepHeaderView()
        headerView.step = self.step
        headerView.titleLabel.text = "Category"
//        headerView.layoutIfNeeded()
        
        return headerView
    }
}
