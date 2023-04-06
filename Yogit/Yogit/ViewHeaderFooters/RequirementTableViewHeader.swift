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
        view.backgroundColor = ServiceColor.primaryColor
        view.layer.cornerRadius = 3
        return view
    }()
    
    // name of content
    let contentNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium) // 글시체 생각해보자
        
        label.sizeToFit()

        // Label frame size to fit as text of label
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(requirementView)
        addSubview(contentNameLabel)
//        configureViewComponent()
    }
    
    private func configureViewComponent() {
        backgroundColor = .systemBackground
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
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentNameLabel.text = nil
        requirementView.isHidden = false
    }

    public func configure(at: Int) { // needAccessory: Bool
        contentNameLabel.text = ProfileSectionData(rawValue: at)?.toString()
        switch at {
        case ProfileSectionData.job.rawValue, ProfileSectionData.aboutMe.rawValue, ProfileSectionData.interests.rawValue:
            requirementView.isHidden = true
        default: break
        }
    }
}
