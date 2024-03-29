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
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        footerLabel.text = nil
    }
    
    private func configureView() {
        addSubview(footerLabel)
    }
    
    private func configureLayout() {
        footerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }
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
