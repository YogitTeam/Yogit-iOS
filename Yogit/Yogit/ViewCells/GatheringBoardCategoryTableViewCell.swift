//
//  GatheringBoardCategoryTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/10.
//

import UIKit
import SnapKit

class GatheringBoardCategoryTableViewCell: UITableViewCell {

    static let identifier = "GatheringBoardCategoryTableViewCel"
    
    //
    var isTapped: Bool? = nil {
        didSet {
            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                if isTapped == nil {
                    categoryContentView.layer.borderColor = UIColor.label.cgColor
                    categoryContentView.backgroundColor = .systemBackground
                    categoryImageView.tintColor = UIColor.label
                    categoryTitleLabel.textColor = UIColor.label
                    categoryDescriptionLabel.textColor = UIColor.label
                }
                else if isTapped == true {
                    categoryContentView.layer.borderColor = ServiceColor.primaryColor.cgColor
                    categoryContentView.backgroundColor = ServiceColor.primaryColor
                    categoryImageView.tintColor = .white
                    categoryTitleLabel.textColor = .white
                    categoryDescriptionLabel.textColor = .white
                } else {
                    categoryContentView.layer.borderColor = UIColor.placeholderText.cgColor
                    categoryContentView.backgroundColor = .systemBackground
                    categoryImageView.tintColor = .placeholderText
                    categoryTitleLabel.textColor = .placeholderText
                    categoryDescriptionLabel.textColor = .placeholderText
                }
            })
        }
    }
    
    lazy var categoryContentView:  UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.4
        view.layer.borderColor = UIColor.label.cgColor
        view.backgroundColor = .systemBackground
        [self.categoryImageView,
         self.categoryLabelStackView].forEach { view.addSubview($0) }
        return view
    }()
    
    lazy var categoryLabelStackView: UIView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        [self.categoryTitleLabel,
         self.categoryDescriptionLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    let categoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
    
    private func configureView() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(categoryContentView)
    }
    
    private func configureLayout() {
        categoryImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        categoryLabelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(categoryImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        categoryContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImageView.image = nil
        categoryTitleLabel.text = nil
        categoryDescriptionLabel.text = nil
    }
}
