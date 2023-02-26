//
//  CategoryImageViewCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/06.
//

import UIKit

class CategoryImageViewCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryImageViewCollectionViewCell"
    
//    var isTapped: Bool? = nil {
//        didSet {
////            if isTapped == nil {
////                categoryContentView.layer.borderColor = UIColor.label.cgColor
////                categoryContentView.backgroundColor = .systemBackground
////                categoryImageView.tintColor = UIColor.label
////                categoryTitleLabel.textColor = UIColor.label
////                categoryDescriptionLabel.textColor = UIColor.label
////            }
////            else
//            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
//                if isTapped == true {
//    //                imageView.layer.borderColor = UIColor(rgb: 0x3232FF, alpha: 1.0).cgColor
//    //                imageView.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//                    imageView.tintColor = .white // .white
//                    titleLabel.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//                    backView.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//                    backView.layer.shadowColor = ServiceColor.primaryColor.cgColor
//                    backView.layer.shadowOffset = CGSize(width: 1, height: 1)
//                    backView.layer.shadowRadius = 1
//                    backView.layer.shadowOpacity = 0.2
//    //                backView.layer.borderColor = UIColor(rgb: 0x3232FF, alpha: 1.0).cgColor
//                } else {
//    //                imageView.layer.borderColor = UIColor.label.cgColor // UIColor.placeholderText.cgColor
//    //                imageView.backgroundColor = .systemBackground
//                    imageView.tintColor = .label
//                    titleLabel.textColor = .label
//                    backView.backgroundColor = .systemBackground
//        //                backView.layer.borderColor = UIColor.label.cgColor
//                    
//                    backView.layer.shadowColor = nil//UIColor.black.cgColor
//                    backView.layer.shadowOffset = CGSize(width: 0, height: 0)//CGSize(width: 1, height: 1)
//                    backView.layer.shadowRadius = 0//1
//                    backView.layer.shadowOpacity = 0//0.2
//                    
////                    backView.layer.shadowColor = nil
////                    backView.layer.shadowOffset = CGSize(width: 0, height: 0)
////                    backView.layer.shadowRadius = 0
////                    backView.layer.shadowOpacity = 0
//                }
//            })
//        }
//    }
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.red.cgColor
        [backView, titleLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.backgroundColor = .systemGray6 //.systemBackground
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
//        imageView.backgroundColor = .placeholderText
//        imageView.tintColor = .systemGray.withAlphaComponent(0.5) // image color
        
//        imageView.layer.borderColor = UIColor.label.cgColor
//        imageView.layer.borderWidth = 1.6
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
//        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 2
//        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(contentStackView)
//        contentView.addSubview(imageView)
//        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("Member images layoutSubviews")
        contentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        
//            $0.top.equalToSuperview().inset(10)
//            $0.bottom.lessThanOrEqualToSuperview().inset(10)
        }
        imageView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(4)
//            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
        backView.snp.makeConstraints {
            $0.width.height.equalTo(imageView.snp.width).inset(-8)
        }
        backView.layoutIfNeeded()
        backView.layer.cornerRadius = backView.frame.size.width/2
        
//        backView.layer.shadowColor = ServiceColor.primaryColor.cgColor
//        backView.layer.shadowOffset = CGSize(width: 0, height: 3)
//        backView.layer.shadowRadius = 3
//        backView.layer.shadowOpacity = 0.25
//        titleLabel.snp.makeConstraints {
//            $0.top.equalTo(imageView.snp.bottom).offset(4)
//            $0.centerX.equalToSuperview()
////            $0.width.equalTo(80)
////            $0.leading.trailing.equalToSuperview()
////            $0.bottom.equalToSuperview().inset(4)
//        }
//        imageView.layoutIfNeeded()
//        imageView.layer.cornerRadius = imageView.frame.size.width/2
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        setNeedsLayout()
//        layoutIfNeeded()
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var frame = layoutAttributes.frame
//        frame.size.height = ceil(size.height)
//        layoutAttributes.frame = frame
//        return layoutAttributes
//    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }

    func configure(at: Int) {
        guard let categoryString = CategoryId(rawValue: at + 1)?.toString() else { return }
        imageView.image = UIImage(named: categoryString)?.withRenderingMode(.alwaysTemplate)
        var str: String = ""
        for ch in categoryString {
            if ch == " " {
                str.append("\n")
            }
            str.append(ch)
        }
        titleLabel.text = str
//        let str = categoryString.components(separatedBy: " ")
//        titleLabel.text = "\(str[0])\n\(str[1])"
    }
}

