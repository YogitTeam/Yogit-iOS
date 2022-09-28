//
//  ProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

import UIKit

class SetUpProfileTableViewController: UIViewController, UITableViewDelegate {
    
    private lazy var infoTableView: UITableView = {
        let tableView = UITableView()

        // register new cell
        // self: reference the type object
        tableView.register(SetUpProfileTableViewCell.self, forCellReuseIdentifier: SetUpProfileTableViewCell.identifier)

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(infoTableView)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoTableView.frame = view.bounds
        
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
        return 2
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

extension SetUpProfileTableViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
            // name, age, location
                return 3
            case 1:
            // gender, nationality
                return 2
            default:
                return 0
        }
    }
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetUpProfileTableViewCell.identifier, for: indexPath) as? SetUpProfileTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
            case 0:
                // name, age, location
                switch indexPath.row {
                    case 0: cell.configure(text: "Name")
                    case 1: cell.configure(text: "Age")
                    case 2: cell.configure(text: "Location")
                    default: fatalError("FirstSetUpTableVeiw section 0: indexPath row error")
                }
            case 1:
            // gender, nationality
                switch indexPath.row {
                    case 0: cell.configure(text: "Gender")
                    case 1: cell.configure(text: "Nationality")
                    default: fatalError("FirstSetUpTableVeiw Section 1: indexPath row error")
                }
            default:
                print("Section default")
        }

//        // Configure content
//        // Similar View - ViewModel arhitecture
//        var content = cell.defaultContentConfiguration()
//        content.text = "alarm  tableView: \(indexPath.row)"
////        content.image = UIImage(systemName: "bell")
//        content.secondaryText = "Secondaryt"
//
//        // Customize appearence
//        cell.contentConfiguration = content

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97 // FirstSetUpTableViewCell().infoContentStackView.bounds.size.height + 10
    }
}

