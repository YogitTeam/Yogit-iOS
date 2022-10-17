//
//  StackViewTeestViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/04.
//

import UIKit

class StackViewTeestViewController: UIViewController, UITableViewDelegate {
    
    let langages = ["English", "Korean"]
    
    var languageCount = 1
    
//    // requirement expression blue point
//    private lazy var requirementView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "RequirementExpresstion")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    // name of content
//    private lazy var contentNameLabel: UILabel = {
//        let label = UILabel()
////        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 16.0)
//        label.textAlignment = .left
//        label.text = "Label"
//
//        // Label frame size to fit as text of label
////        label.sizeToFit()
//        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
//
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.black.cgColor
//        return label
//    }()
//
//    // requirementExpressionView & contentNameLabel horizontal stack view
//    public lazy var profileHeaderStackView: UIView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = 4
//        stackView.alignment = .leading
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.systemBlue.cgColor
//        [self.requirementView,
//         self.contentNameLabel].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()
    
    private lazy var profileImageContentView: UIView = {
       let view = UIView()
        view.backgroundColor = .systemYellow
        return view
    }()
    
    private lazy var infoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
//        tableView.sectionHeaderHeight = 22
//        tableView.estimatedRowHeight = 48
//        tableView.estimatedSectionHeaderHeight = 24
//        tableView.sectionHeaderHeight = 22
        
        tableView.register(SetUpProfileTableViewCell.self, forCellReuseIdentifier: SetUpProfileTableViewCell.identifier)
        tableView.register(SetUpProfileTableViewHeader.self, forHeaderFooterViewReuseIdentifier: SetUpProfileTableViewHeader.identifier)
        tableView.register(SetUpProfileTableViewFooter.self, forHeaderFooterViewReuseIdentifier: SetUpProfileTableViewFooter.identifier)
        
//        tableView.sectionFooterHeight = UITableView.automaticDimension
//        tableView.estimatedSectionFooterHeight = 20
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileImageContentView)
        view.addSubview(infoTableView)
        infoTableView.delegate = self
        infoTableView.dataSource = self
//        infoTableView.rowHeight = UITableView.automaticDimension
//        infoTableView.estimatedRowHeight = UITableView.automaticDimension
//        infoTableView.estimatedRowHeight = 50 // 테이블뷰 셀사이즈 동적 변경 안됨
        configureViewComponent()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageContentView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.top.left.right.equalToSuperview().inset(0)
        }
        
//        infoTableView.frame = view.bounds
        infoTableView.snp.makeConstraints { make in
            make.top.equalTo(profileImageContentView.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(view).inset(0)
        }
//        requirementView.snp.makeConstraints { make in
//            make.width.height.equalTo(6)
//            make.top.equalTo(profileHeaderStackView).inset(0)
//        }
//        profileHeaderStackView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
//        }
//        infoTableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        infoTableView.rowHeight = UITableView.automaticDimension
//        infoTableView.rowHeight = UITableView.automaticDimension
//        infoTableView.estimatedRowHeight = UITableView.automaticDimension
//        infoTableView.rowHeight = UITableView.automaticDimension
//        infoTableView.estimatedRowHeight = 60
//        contentNameLabel.snp.makeConstraints { make in
//            make.left.right.equalTo(view).inset(20)
//            make.top.equalTo(phoneNumberContentStackView.snp.bottom).offset(10)
//            make.height.equalTo(50)
//        }
//
//        touchPrintLabel.snp.makeConstraints { make in
//            make.left.right.equalTo(view).inset(20)
//            make.top.equalTo(view).inset(100)
//            make.height.equalTo(30)
//        }
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("tapped cell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        50
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 40
//    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return tableView.row
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 22
//    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return 24
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StackViewTeestViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
            // name
                return 1
            case 1:
            // age
                return 1
            case 2:
            // langages
                return langages.count
            case 3:
            // gender
                return 1
            case 4:
            // nationality
                return 1
            default:
                return 0
        }
    }
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetUpProfileTableViewCell.identifier, for: indexPath) as? SetUpProfileTableViewCell else { return UITableViewCell() }
//        cell.layer.borderWidth = 1
//        cell.addBorder2(withColor: UIColor.systemPink, width: 1)
        
        // name, age, lanages, gender, nationality
        switch indexPath.section {
            case 0: cell.configure(text: "Your name")
            case 1: cell.configure(text: "Your age")
            case 2:
                cell.configure(text: "Language you can speak")
                cell.accessoryType = .disclosureIndicator
//                if languageCount < langages.count {
//                    languageCount+=1
//
////                    cell.addBorder(toSide: .Bottom, withColor: UIColor.systemRed.cgColor, andThickness: 1.0)
////                    cell.contentView.layer.addBorder(arr_edge: [.bottom], color: UIColor.systemGray, width: 0.5)
//                }
            case 3: cell.configure(text: "Prefer not to say")
            case 4:
                cell.configure(text: "Your nationaltiy")
                cell.accessoryType = .disclosureIndicator
            default: fatalError("cellInSection default")
        }
        
//        switch indexPath.section {
//            case 0:
//                // name, age, location
//                switch indexPath.row {
//                    case 0: cell.configure(text: "Name")
//                    case 1: cell.configure(text: "Age")
//                    case 2: cell.configure(text: "Location")
//                    default: fatalError("FirstSetUpTableVeiw section 0: indexPath row error")
//                }
//            case 1:
//            // gender, nationality
//                switch indexPath.row {
//                    case 0: cell.configure(text: "Gender")
//                    case 1: cell.configure(text: "Nationality")
//                    default: fatalError("FirstSetUpTableVeiw Section 1: indexPath row error")
//                }
//            default:
//                print("Section default")
//        }

//        // Configure content
//        // Similar View - ViewModel arhitecture
//        var content = cell.defaultContentConfiguration()
//        content.text = "alarm  tableView: \(indexPath.row)"
////        content.image = UIImage(systemName: "bell")
//        content.secondaryText = "Secondaryt"
//
//        // Customize appearence
//        cell.contentConfiguration = content
//        cell.frame.size = CGSize(width: <#T##Double#>, height: <#T##Double#>)
        cell.selectionStyle = .blue
        cell.layoutIfNeeded()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SetUpProfileTableViewHeader.identifier) as? SetUpProfileTableViewHeader else { return UITableViewHeaderFooterView() }

        // name, age, lanages, gender, nationality
        switch section {
            case 0: headerView.configure(text: "Name")
            case 1: headerView.configure(text: "Age")
            case 2: headerView.configure(text: "Languages")
            case 3: headerView.configure(text: "Gender")
            case 4: headerView.configure(text: "Nationality")
            default: fatalError("headerInSection default")
        }
        return headerView
    }

////    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
////        switch section {
////        case 2:
////            return "Your name, age, languages will be public.\n\n"
////        case 4:
////            return "Gender, nationality help improve recommendations but are not shown publicly."
////        default:
////            return nil
////        }
////    }
//
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SetUpProfileTableViewFooter.identifier) as? SetUpProfileTableViewFooter else { return UITableViewHeaderFooterView() }


        // name, age, lanages, gender, nationality
        switch section {
            case 2: footerView.configure(text: "Your name, age, languages will be public.")
            case 4: footerView.configure(text: "Gender, nationality help improve recommendations but are not shown publicly.")
            default: return nil // footerView.configure(text: "")
        }

        footerView.layoutIfNeeded()
        return footerView
    }
    
  
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    // static size
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//            case 0: return 100  // image
//            case 1: return 200
//            default: fatalError("FirstSetUpTableVeiw section 0: indexPath row error")
//        }
//
//        return tableView.rowHeight
//    }


}


