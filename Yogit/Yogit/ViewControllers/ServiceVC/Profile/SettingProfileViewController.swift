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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        configureProgressHUD()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationItem.title = "SETTING".localized()
        settingTableView.frame = view.bounds
    }

    private func configureView() {
        view.addSubview(settingTableView)
    }
    
    private func configureTableView() {
        settingTableView.dataSource = self
        settingTableView.delegate = self
    }
    
    private func configureProgressHUD() {
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
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
        guard let identifier = UserDefaults.standard.object(forKey: UserSessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        let deleteApple = DeleteAppleAccountReq(identityToken: userItem.id_token, refreshToken: userItem.refresh_token, userId: userItem.userId)
        ProgressHUD.show(interaction: false)
        UserSessionManager.shared.deleteAccount(deleteAccountReq: deleteApple, userItem: userItem) { (response) in
            switch response {
            case .success:
                // 애플 회원탈퇴 후, 애플 계정 ID 사용 중단까지 실제 시간 추가 소요 (2~3초) >> 탈퇴 이후 바로 회원가입시 문제 안생김
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                    self?.moveToLoginVC()
                    ProgressHUD.dismiss()
                }
            case .badResponse:
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
            case .failureResponse:
                DispatchQueue.main.async {
                    ProgressHUD.showFailed("NETWORKING_FAIL".localized())
                }
            }
        }
    }
    
    // userStatus logOut 저장됨
    // userStatus로 화면 이동, 유저 디폴트 현재 servicetype 삭제
    
    private func logOut() {
        guard let identifier = UserDefaults.standard.object(forKey: UserSessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        ProgressHUD.show(interaction: false)
        let logOut = LogOutAppleReq(refreshToken: userItem.refresh_token, userId: userItem.userId)
        UserSessionManager.shared.logOut(logOutReq: logOut, userItem: userItem) { (response) in
            switch response {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.moveToLoginVC()
                    ProgressHUD.dismiss()
                }
            case .badResponse:
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
            case .failureResponse:
                DispatchQueue.main.async {
                    ProgressHUD.showFailed("NETWORKING_FAIL".localized())
                }
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
