//
//  SetupProfileHeaderFooterView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/08.
//

import UIKit
import SnapKit

class SetUpProfileTableViewHeader: UITableViewHeaderFooterView {

    static let identifier = "setUpProfileTableViewHeader"
    
    // requirement expression blue point
    private lazy var requirementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        view.layer.cornerRadius = 3
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.systemPink.cgColor
        return view
    }()
    
    // name of content
    private lazy var contentNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
//        label.text = "Label"
        
        // Label frame size to fit as text of label
        label.sizeToFit()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    // requirementView & contentNameLabel horizontal stack view
//    private lazy var profileHeaderStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = 4
//        stackView.alignment = .leading
////        stackView.backgroundColor = .systemBackground
////        stackView.layer.borderWidth = 1
////        stackView.layer.borderColor = UIColor.systemOrange.cgColor
//        [self.requirementImageView,
//         self.contentNameLabel].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()
    
//    // requirementView & contentNameLabel horizontal stack view
//    private lazy var profileHeaderView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        [self.requirementImageView,
//         self.contentNameLabel].forEach { view.addSubview($0) }
//        return view
//    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(requirementView)
        contentView.addSubview(contentNameLabel)
        contentView.addSubview(editButton)
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
//        profileHeaderView.snp.makeConstraints { make in
//            make.leading.trailing.equalTo(contentView).inset(10)
//            make.top.bottom.equalTo(contentView).inset(0)
//        }
        contentNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(requirementView.snp.trailing).offset(6)
//            make.height.equalTo(22)
            make.top.bottom.equalToSuperview().inset(0)
//            make.height.equalTo(24)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(0)
        }
//        profileHeaderStackView.snp.makeConstraints { make in
//            make.top.bottom.equalTo(contentView).inset(0)
//            make.leading.trailing.equalTo(contentView).inset(10)
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentNameLabel.text = nil
    }

    public func configure(text: String) {
        contentNameLabel.text = text
        if text == "Languages" {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
        // uiview 설정
        // 이벤트 전환
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
