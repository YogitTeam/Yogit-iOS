//
//  PhoneVerificationViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/06.
//

import UIKit
import SnapKit
import Alamofire

class PhoneNumberVerificationViewController: UIViewController {

    lazy var viewMovePrintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.text = "Push" // country code
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewMovePrintLabel)
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewMovePrintLabel.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.top.equalTo(view).inset(100)
            make.height.equalTo(30)
        }
    }
    
    // MARK: Configure View Component
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
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
