//
//  SetupProfileHeaderFooterView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/08.
//

import UIKit
import SnapKit

class SetProfileTableViewFooter: UITableViewHeaderFooterView {

    static let identifier = "SetProfileTableViewFooter"
    
    // name of content
    let footerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.label
        label.textAlignment = .left
//        label.text = "Label"
        
        // Label frame size to fit as text of label
        label.sizeToFit()
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
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    // MARK: - Layout
   

    override func layoutSubviews() {
        super.layoutSubviews()
        footerLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(4)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        footerLabel.text = nil
    }
    
    public func nameCountLabelChanged(text: String) {
        if text.count >= 2 {
            footerLabel.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        } else {
            footerLabel.textColor = .systemRed
        }
        footerLabel.text = "\(text.count) / 20"
    }
    
    public func configure(text: String, kind: Int) {
        switch kind {
        case 0: nameCountLabelChanged(text: text)
        case 2, 4:
            footerLabel.text = text
            footerLabel.textColor = .darkGray
        default: break
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
