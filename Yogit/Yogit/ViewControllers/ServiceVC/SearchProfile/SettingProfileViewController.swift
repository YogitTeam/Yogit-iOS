//
//  SettingProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/05.
//

import UIKit

//protocol NationalityProtocol {
//    func nationalitySend(nationality: String)
//}

class SettingProfileViewController: UIViewController {
    // MARK: - TableView
    // 이미지도 같이
    let settings: [String] = ["LogOut", "Delete account"]
    
//    var delegate: NationalityProtocol?
    
    // closure parttern
    // () parameter
    private let settingTableView: UITableView = {
        let tableView = UITableView()
        // register new cell
        // self: reference the type object
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingTableView)
        settingTableView.dataSource = self
        settingTableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = "Setting"
        settingTableView.frame = view.bounds
    }

    
    private func deleteButtonTapped() {
        let alert = UIAlertController(title: "Delete account", message: "Would you want to delete account?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .destructive) { (ok) in
            self.deleteAccount()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func deleteAccount() {
        print("Delete Acccount")
        // keychain 정보 삭제
//        do {
//            try KeychainManager.deleteUserItem()
//        } catch {
//            print(error)
//        }
    }
    
//    private func logOut() {
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
////        guard let deviceToken = userItem.deviceToken else { return }
//        let parameter = LogOut(refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AF.request(API.BASE_URL + "users/log-out",
//                   method: .post,
//                   parameters: parameter,
//                   encoder: URLEncodedFormParameterEncoder(destination: .httpBody)) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
////                userDefaults.removeObject(forKey: "DeviceToken")
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure content
        // Similar View - ViewModel arhitecture
        var content = cell.defaultContentConfiguration()
        content.text = settings[indexPath.row]
        switch indexPath.row {
        case 0, 1:
            content.textProperties.color = .systemRed
        default:
            content.textProperties.color = .label
        }
//        content.image = UIImage(systemName: "bell")

        // Customize appearence
        cell.contentConfiguration = content
        
    
        return cell
    }
}

extension SettingProfileViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}

extension SettingProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)
        switch indexPath.row {
        case 1:
            deleteButtonTapped()
        default:
            break
        }
//        delegate?.nationalitySend(nationality: settings[indexPath.row])
//        self.navigationController?.popViewController(animated: true)
    }
}

