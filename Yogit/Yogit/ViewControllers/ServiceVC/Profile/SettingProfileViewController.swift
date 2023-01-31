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
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
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

    private func logOutButtonTapped() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure want to log out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .destructive) { (ok) in
            self.logOut()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func deleteButtonTapped() {
        let alert = UIAlertController(title: "Delete account", message: "Are you sure want to delete account?", preferredStyle: .alert)
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
//        guard let userServiceType = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String else {
//            print("userServiceType - NULL")
//            return
//        }
        
        // keychain 정보 삭제
        guard let userItem = try? KeychainManager.getUserItem() else { return } // 인자 userServiceType
        let deleteApple = DeleteAppleAccountReq(identityToken: userItem.id_token, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(SessionRouter.deleteApple(parameters: deleteApple))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<String>.self) { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
//                        guard let data = value.data else { return }
                        do {
                            try KeychainManager.deleteUserItem(userItem: userItem)
                            let rootVC = UINavigationController(rootViewController: LoginViewController())
                            DispatchQueue.main.async { [self] in
                                view.window?.rootViewController = rootVC
                                view.window?.makeKeyAndVisible()
                            }
                        } catch {
                            print("KeychainManager.deleteUserItem \(error.localizedDescription)")
                        }
                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    // userStatus logOut 저장됨
    // userStatus로 화면 이동, 유저 디폴트 현재 servicetype 삭제
    
    private func logOut() {
//        guard let userServiceType = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String else {
//            print("userServiceType - NULL")
//            return
//        }
        guard let userItem = try? KeychainManager.getUserItem() else { return } // 인자 userServiceType
        
        let logOut = LogOutAppleReq(refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(SessionRouter.logOut(parameters: logOut))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<LogOutAppleRes>.self) { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        guard let data = value.data else { return }
                        do {
                            userItem.userStatus = data.userStatus
                            try KeychainManager.updateUserItem(userItem: userItem)
                            let rootVC = UINavigationController(rootViewController: LoginViewController())
                            DispatchQueue.main.async { [self] in
                                view.window?.rootViewController = rootVC
                                view.window?.makeKeyAndVisible()
                            }
                        } catch {
                            print("KeychainManager.deleteUserItem \(error.localizedDescription)")
                        }
                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    
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
        case 0:
            logOutButtonTapped()
        case 1:
            deleteButtonTapped()
        default:
            break
        }
//        delegate?.nationalitySend(nationality: settings[indexPath.row])
//        self.navigationController?.popViewController(animated: true)
    }
}

