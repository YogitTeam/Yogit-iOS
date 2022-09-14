//
//  SignUpDetailViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/12.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var userDetailtableView: UITableView = {
        let tableView = UITableView()
        
        // register new cell
        // self: reference the type object
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private lazy var nameTextfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Your name"
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(userDetailtableView)
        userDetailtableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // frame: the view’s location and size in its superview’s coordinate system.
        // bound: the view’s location and size in its own coordinate system.
        userDetailtableView.frame = view.bounds
    }
    
    
    // MARK: - Table view data source object
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        switch indexPath.section {
//            case 0:
//            // name, age, location
//            switch indexPath.row {
//                case 0:
//                    cell.addSubview(nameTextfield)
//                case 1:
//                    print(":dfdf")
//                case 2:
//                    print(":dfdf")
//                default:
//                    print("default")
//            }
//            case 1:
//            // gender, nationality
//                switch indexPath.row {
//                    case 0:
//                        print(":dfdf")
//                    case 1:
//                        print(":dfdf")
//                    default:
//                        print("default")
//                }
//            default:
//                print("Section default")
//        }
        
        cell.contentView.addSubview(nameTextfield) // custom content view
        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
