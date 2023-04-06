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
    
    public func configure(text: String, kind: Int) {
        footerLabel.text = text.localized()
        footerLabel.textColor = .darkGray
        switch kind {
        case ProfileSectionData.name.rawValue:
            footerLabel.textColor = ServiceColor.primaryColor
        case ProfileSectionData.nationality.rawValue:
            footerLabel.textColor = ServiceColor.primaryColor
        default: break
        }
    }
}
