//
//  SearchProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/20.
//

import UIKit

class SearchProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try KeychainManager.deleteUserItem()
        } catch {
            print("userItem \(error.localizedDescription)")
        }
        guard let userItem = try? KeychainManager.getUserItem() else {
            print("loginview user item get nil ")
            return
        }
        print("Get in loginview \(userItem)")
        print(userItem.userId)
        print(userItem.account.user.email)
        print(userItem.refresh_token)
        // Do any additional setup after loading the view.
    }
    

    private func configureViewComponent() {
        view.backgroundColor = .brown
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
