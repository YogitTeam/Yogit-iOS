//
//  nationalityViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/03.
//

import UIKit

protocol NationalityProtocol {
    func nationalitySend(nationality: String)
}

class NationalityViewController: UIViewController {

    // MARK: - TableView
    // 이미지도 같이
    let nationalityData: [String] = ["Korea", "USA"]
    
    var delegate: NationalityProtocol?
    
    // closure parttern
    // () parameter
    private let nationalityTableView: UITableView = {
        let tableView = UITableView()
        // register new cell
        // self: reference the type object
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(nationalityTableView)
        nationalityTableView.dataSource = self
        nationalityTableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // frame: the view’s location and size in its superview’s coordinate system.
        // bound: the view’s location and size in its own coordinate system.
        nationalityTableView.frame = view.bounds
    }
    
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure content
        // Similar View - ViewModel arhitecture
        var content = cell.defaultContentConfiguration()
        content.text = nationalityData[indexPath.row]
        content.image = UIImage(systemName: "bell")

        // Customize appearence
        cell.contentConfiguration = content
        
    
        return cell
    }
}

extension NationalityViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nationalityData.count
    }
}

extension NationalityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)
        delegate?.nationalitySend(nationality: nationalityData[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

