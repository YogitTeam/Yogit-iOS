//
//  SettingProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/05.
//

import UIKit
import ProgressHUD
import MessageUI

//protocol NationalityProtocol {
//    func nationalitySend(nationality: String)
//}

class SettingProfileViewController: UIViewController {
    // MARK: - TableView
    // 이미지도 같이

    private let settings: [String] = ["LOGOUT_TITLE".localized(), "DELETE_ACCOUNT_TITLE".localized(), "CUSTOMER_SERVICE_CENTER_TITLE".localized()]
    
    private let settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingTableView)
        settingTableView.dataSource = self
        settingTableView.delegate = self
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = "SETTING".localized()
        settingTableView.frame = view.bounds
    }

    private func logOutButtonTapped() {
        let alert = UIAlertController(title: "LOGOUT_TITLE".localized(), message: "LOGOUT_ALERT_MESSAGE".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel)
        let ok = UIAlertAction(title: "OK".localized(), style: .destructive) { (ok) in
            self.logOut()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func deleteButtonTapped() {
        let alert = UIAlertController(title: "DELETE_ACCOUNT_TITLE".localized(), message: "DELETE_ACCOUNT_ALERT_MESSAGE".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel)
        let ok = UIAlertAction(title: "OK".localized(), style: .destructive) { (ok) in
            self.deleteAccount()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func moveToLoginVC() {
        let rootVC = UINavigationController(rootViewController: LoginViewController())
        rootVC.navigationBar.tintColor = UIColor.label
        rootVC.navigationBar.topItem?.backButtonTitle = ""
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemBackground
        rootVC.navigationBar.standardAppearance = navigationBarAppearance
        view.window?.rootViewController = rootVC
        view.window?.makeKeyAndVisible()
    }
    
    private func deleteAccount() {
        // keychain 정보 삭제
        // catch 확인
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        let deleteApple = DeleteAppleAccountReq(identityToken: userItem.id_token, refreshToken: userItem.refresh_token, userId: userItem.userId)
        ProgressHUD.show(interaction: false)
        AlamofireManager.shared.session
            .request(SessionRouter.deleteApple(parameters: deleteApple))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<String>.self) { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 || value.httpCode == 201 {
                        do {
                            try KeychainManager.deleteUserItem(userItem: userItem)
                            
                            // 애플 회원탈퇴후 회원가입시 바로 안됨
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                                moveToLoginVC()
                                ProgressHUD.dismiss()
                            }
                        } catch {
                            print("KeychainManager.deleteUserItem \(error.localizedDescription)")
                        }
                    }
                case let .failure(error):
                    print("Delete account decoding error", error)
                }
            }
    }
    
    // userStatus logOut 저장됨
    // userStatus로 화면 이동, 유저 디폴트 현재 servicetype 삭제
    
    private func logOut() {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        ProgressHUD.show(interaction: false)
        let logOut = LogOutAppleReq(refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(SessionRouter.logOut(parameters: logOut))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<LogOutAppleRes>.self) { response in
                switch response.result {
                case .success:
                    if let value = response.value, value.httpCode == 200 || value.httpCode == 201, let data = value.data {
                        do {
                            userItem.userStatus = data.userStatus
                            try KeychainManager.updateUserItem(userItem: userItem)
                            DispatchQueue.main.async { [self] in
                                moveToLoginVC()
                                ProgressHUD.dismiss()
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
        var content = cell.defaultContentConfiguration()
        content.text = settings[indexPath.row]
        switch indexPath.row {
        case 0, 1: content.textProperties.color = .systemRed
        default: content.textProperties.color = .label
        }
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
        return 50
    }
}

extension SettingProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: logOutButtonTapped()
        case 1: deleteButtonTapped()
        case 2: openEmail()
        default: break
        }
    }
}

extension SettingProfileViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

    private func openEmail() {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            
            DispatchQueue.main.async(qos: .userInteractive) {
                compseVC.setToRecipients(["yogit.service@gmail.com"])
                compseVC.setSubject("CUSTOMER_INQUIRY".localized())
                compseVC.setMessageBody("CUSTOMER_INQUIRY_CONENT".localized(), isHTML: false)
                self.present(compseVC, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title:  "CUSTOMER_SERVICE_MAIL_TRANSFER_FAIL_ALERT_TITLE".localized(), message:  "CUSTOMER_SERVICE_MAIL_TRANSFER_FAIL_ALERT_MESSAGE".localized(), preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK".localized(), style: .default)
            alert.addAction(ok)
            DispatchQueue.main.async(qos: .userInteractive) {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
