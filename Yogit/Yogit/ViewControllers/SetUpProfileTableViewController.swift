//
//  ProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

import UIKit

class SetUpProfileTableViewController: UIViewController, UITableViewDelegate {
    
    private let langages = ["English", "Korean","Korean","Korean","Korean"]
    
    private var image: UIImage? = nil
    
    var languageCount = 1

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .placeholderText
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var profileImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        label.text = "Select photos"
        
        // Label frame size to fit as text of label
        label.sizeToFit()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    private lazy var profileImageContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileImageViewTapped(_:))))
        [self.profileImageView, self.profileImageLabel].forEach { view.addSubview($0) }
        return view
    }()
    
    private lazy var infoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
//        tableView.separatorColor = UIColor(rgb: 0xF5F5F5)
        tableView.backgroundColor = .systemBackground
//        tableView.sectionFooterHeight = 20
//        tableView.backgroundColor = UIColor(rgb: 0xF5F5F5)
//        tableView.sectionIndexTrackingBackgroundColor = .systemBackground
//        tableView.tintColor = .systemPink
//        tableView.sectionHeaderHeight = 24
    
        tableView.sectionHeaderTopPadding = 16
//        tableView.separatorColor = .systemPink

//        tableView.sectionHeaderTopPadding = 10
//        tableView.sectionIndexColor = .systemBackground
//        tableView.sectionIndexBackgroundColor = .systemBackground
//        table
        // register new cell
        // self: reference the type object
        tableView.register(SetUpProfileTableViewCell.self, forCellReuseIdentifier: SetUpProfileTableViewCell.identifier)
        tableView.register(SetUpProfileTableViewHeader.self, forHeaderFooterViewReuseIdentifier: SetUpProfileTableViewHeader.identifier)
        tableView.register(SetUpProfileTableViewFooter.self, forHeaderFooterViewReuseIdentifier: SetUpProfileTableViewFooter.identifier)
        return tableView
    }()
    
    private lazy var profileContentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
//        stackView.axis = .vertical
//        stackView.alignment = .fill
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        [self.profileImageContentView, self.infoTableView].forEach { scrollView.addSubview($0) }
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(profileImageContentView)
        view.addSubview(profileContentScrollView)
        infoTableView.delegate = self
        infoTableView.dataSource = self
//        picker.delegate = self

//        infoTableView.rowHeight = UITableView.automaticDimension
//        infoTableView.estimatedRowHeight = UITableView.automaticDimension
//        infoTableView.estimatedRowHeight = 50 // 테이블뷰 셀사이즈 동적 변경 안됨
        configureViewComponent()
        // Do any additional setup after loading the view.
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        profileContentScrollView.frame = view.bounds
        profileContentScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(110)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(24)
//            make.top.equalToSuperview().inset(30)
        }
        
        configureImageViewComponent()
        
        profileImageLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
//            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        profileImageContentView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
//
        infoTableView.snp.makeConstraints { make in
            make.height.equalTo(1000)
            make.top.equalTo(profileImageContentView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
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
        self.navigationItem.title = "Profile"
        view.backgroundColor = .systemBackground
    }
    
    private func configureImageViewComponent() {
//        imageView.layer.cornerRadius = imageView.frame.width / 2
//        imageView.clipsToBounds = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("tapped cell")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        switch section {
//        case 2, 4:
//            return 50
//        default:
//            return 0
//        }
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

extension SetUpProfileTableViewController: UITableViewDataSource {
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
            case 0: cell.configure(text: "Input name")
            case 1: cell.configure(text: "Select international age")
            case 2:
                cell.configure(text: "Add conversational language")
                cell.accessoryType = .disclosureIndicator
//                if languageCount < langages.count {
//                    languageCount+=1
//
//            cell.addBorder(toSide: .Bottom, withColor: UIColor.systemRed.cgColor, andThickness: 1.0)
////                    cell.contentView.layer.addBorder(arr_edge: [.bottom], color: UIColor.systemGray, width: 0.5)
//                }
            case 3: cell.configure(text: "Select gender")
            case 4:
                cell.configure(text: "Select nationaltiy")
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
//        cell.layoutIfNeeded()
        cell.addViewBorder(withColor: .placeholderText, width: 0.3) // UIColor(rgb: 0xBDBDBD)
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
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 2:
            return "Your name, age, languages will be public.\n\n"
        case 4:
            return "Gender, nationality help improve recommendations but are not shown publicly."
        default:
            return nil
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SetUpProfileTableViewFooter.identifier) as? SetUpProfileTableViewFooter else { return UITableViewHeaderFooterView() }
//
//
//        // name, age, lanages, gender, nationality
//        switch section {
//            case 2: footerView.configure(text: "Your name, age, languages will be public.")
//            case 4: footerView.configure(text: "Gender, nationality help improve recommendations but are not shown publicly.")
//            default: return nil // footerView.configure(text: "")
//        }
//
////        footerView.layoutIfNeeded() // layout 로딩 (동적이므로 다름)
//        return footerView
//    }
    
  
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

extension SetUpProfileTableViewController: ImagesProtocol {
    func imagesSend(profileImage: UIImage?) {
        image = profileImage
        profileImageView.image = image
    }
    
    @objc func profileImageViewTapped(_ sender: UITapGestureRecognizer) {
        let PICV = ProfileImagesCollectionViewController()
        PICV.delegate = self
        self.navigationController?.pushViewController(PICV, animated: true)
    }
}
