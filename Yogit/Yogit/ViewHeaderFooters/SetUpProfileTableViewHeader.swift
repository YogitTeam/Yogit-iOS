//
//  SetupProfileHeaderFooterView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/08.
//

import UIKit
import SnapKit

class RequirementTableViewHeader: UITableViewHeaderFooterView {

    static let identifier = "RequirementTableViewHeader"
    
    // requirement expression blue point
    let requirementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        view.layer.cornerRadius = 3
        return view
    }()
    
    // name of content
    private let contentNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        
        // Label frame size to fit as text of label
        label.numberOfLines = 1
//        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(requirementView)
        contentView.addSubview(contentNameLabel)
//        configureViewComponent()
    }
    
    private func configureViewComponent() {
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        requirementView.snp.makeConstraints { make in
            make.width.height.equalTo(6)
            make.top.equalToSuperview().inset(0)
            make.leading.equalToSuperview().inset(10)
        }

        contentNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(requirementView.snp.trailing).offset(4)
            make.top.bottom.equalToSuperview().inset(0)
            make.height.equalTo(24)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentNameLabel.text = nil
    }

    public func configure(text: String?) { // needAccessory: Bool
        contentNameLabel.text = text
    }
}
