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
            if isTapped == nil {
                categoryContentView.layer.borderColor = UIColor.black.cgColor
                categoryContentView.backgroundColor = .white
                categoryImageView.tintColor = .black
                categoryTitleLabel.textColor = .black
                categoryDescriptionLabel.textColor = .black
            }
            else if isTapped == true {
                categoryContentView.layer.borderColor = UIColor(rgb: 0x3232FF, alpha: 1.0).cgColor
                categoryContentView.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
                categoryImageView.tintColor = .white
                categoryTitleLabel.textColor = .white
                categoryDescriptionLabel.textColor = .white
            } else {
                categoryContentView.layer.borderColor = UIColor.placeholderText.cgColor
                categoryContentView.backgroundColor = .white
                categoryImageView.tintColor = .placeholderText
                categoryTitleLabel.textColor = .placeholderText
                categoryDescriptionLabel.textColor = .placeholderText
            }
        }
    }
    
    lazy var categoryContentView:  UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.4
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
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        label.sizeToFit()
        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderColor = UIColor.systemRed.cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    let categoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.sizeToFit()
        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderColor = UIColor.systemRed.cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(categoryContentView)
        contentView.backgroundColor = .white
//        contentView.addSubview(categoryImageView)
//        contentView.addSubview(categoryLabelStackView)
        contentView.addSubview(categoryContentView)
//        contentView.layer.cornerRadius = 10
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.brown.cgColor
//        contentView.isUserInteractionEnabled = false
       
//        contentView.directionalLayoutMargins = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
//        self.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
        print("gathering layoutSubviews")
        categoryImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        categoryLabelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(categoryImageView.snp.trailing).offset(20)
        }
        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 10))
        
        categoryContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
//            make.height.equalTo(80)
        }
//        contentView.isUserInteractionEnabled = false
//        contentView.directionalLayoutMargins = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
//        directionalLayoutMargins = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
//        self.contentView.frame = self.contentView.frame.insetBy(dx: <#T##CGFloat#>, dy: <#T##CGFloat#>)
//        self.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
//        contentView.snp.makeConstraints { make in
//            make.margins
//        }

    }
    
//    override func layoutMarginsDidChange() {
//        super.layoutMarginsDidChange()
//        self.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("category cell prepareForReuse")
        categoryImageView.image = nil
        categoryTitleLabel.text = nil
        categoryDescriptionLabel.text = nil
    }
    
//    // cell content update
//    func configure(title: String?, subTitle: String?) {
//        if isTapped == true {
//            categoryContentView.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//            categoryImageView.image = UIImage(named: "\(title) ")
//            categoryTitleLabel.textColor = .white
//            categoryDescriptionLabel.textColor = .white
//        } else {
//            categoryContentView.backgroundColor = .white
//            categoryTitleLabel.textColor = .black
//            categoryDescriptionLabel.textColor = .black
//        }
//    }

}
