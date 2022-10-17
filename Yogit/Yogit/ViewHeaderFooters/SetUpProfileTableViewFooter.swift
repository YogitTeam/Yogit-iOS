//
//  SetupProfileHeaderFooterView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/08.
//

import UIKit
import SnapKit

class SetUpProfileTableViewFooter: UITableViewHeaderFooterView {

    static let identifier = "setUpProfileTableViewFooter"
    
    // name of content
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
//        label.text = "Label"
        
        // Label frame size to fit as text of label
//        label.sizeToFit()
        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.systemYellow.cgColor
        return label
    }()
    
//    private lazy var profileFooterView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(rgb: 0xF5F5F5)
//        view.addSubview(footerLabel)
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.systemBlue.cgColor
//        return view
//    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(footerLabel)
        contentView.backgroundColor = UIColor(rgb: 0xF5F5F5)
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    // MARK: - Layout
   

    override func layoutSubviews() {
        super.layoutSubviews()
        footerLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//            make.top.equalToSuperview().offset(10)
//            make.bottom.equalToSuperview().offset(-10).priority(.high)
//            make.top.bottom.equalToSuperview().inset(10)
//            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
//            make.center.equalTo(contentView)
            make.top.equalTo(contentView).inset(10)
            make.leading.trailing.equalTo(contentView).inset(20)
//            make.leading.trailing.equalTo(contentView).inset(20)
//            make.top.equalToSuperview().inset(10)
        }
//        profileFooterView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.equalTo(contentView).inset(0)
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        footerLabel.text = nil
    }
    
    public func configure(text: String?) {
        footerLabel.text = text
//        if text == "" {
////            profileFooterView.backgroundColor = .systemBackground
//            footerLabel.snp.makeConstraints { make in
//                make.top.bottom.equalTo(profileFooterView).inset(0.01)
//            }
//        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
