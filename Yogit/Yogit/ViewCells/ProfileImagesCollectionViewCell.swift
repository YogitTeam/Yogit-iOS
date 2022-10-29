//
//  ProfileImagesCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/27.
//

import UIKit

class ProfileImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileImagesCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .placeholderText
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
//    private lazy var deleteButton: UIButton = {
//        var config = UIButton.Configuration.plain()
//        config.image = UIImage(named: "imageDeleteButton")
////        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
////        config.setDefaultContentInsets()
////        config.imagePadding = 5
////        config.imagePlacement = .all
//        let button = UIButton(configuration: config)
//        return button
//    }()
    
    private let imageSequenceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = .white
        
        // Label frame size to fit as text of label
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var imageSequenceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xD9D9D9, alpha: 0.6)
//        view.backgroundColor = UIColor(red: 50, green: 50, blue: 255, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.addSubview(imageSequenceLabel)
        return view
    }()
    
    private let mainImageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = .white
        label.text = "Main Photo"
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var mainImageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x3246FF, alpha: 1.0)
//        view.backgroundColor = UIColor(red: 50, green: 50, blue: 255, alpha: 1.0)
        view.layer.cornerRadius = 8
        view.addSubview(mainImageLabel)
//        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
//        contentView.addSubview(deleteButton)
        contentView.addSubview(imageSequenceView)
        contentView.addSubview(mainImageView)
//        let images: [UIImage] = [
//            UIImage(named: "image1"),
//            UIImage(named: "image2"),
//            UIImage(named: "image3"),
//            UIImage(named: "image4"),
//            UIImage(named: "image5"),
//            UIImage(named: "image6")
//        ].compactMap({$0})
//        imageView.image = images.randomElement()
//        imageView.image =
//        print("1")
//        deleteButton.imageView?.image = UIImage(named: "imageDeleteButton")
        contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
//        imageView.layer.cornerRadius = 6
        imageSequenceView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.leading.equalToSuperview().inset(6)
        }
        imageSequenceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        mainImageView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(16)
            make.bottom.trailing.equalToSuperview().inset(6)
        }
        mainImageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageSequenceLabel.text = nil
    }

    public func configure(image: UIImage?, sequence: String) {
        imageView.image = image
        imageSequenceLabel.text = sequence
        if sequence == "1" {
            mainImageView.isHidden = false
        } else {
            mainImageView.isHidden = true
        }
//        if image != nil {
//            imageView.isUserInteractionEnabled = false
//        } else {
//            imageView.isUserInteractionEnabled = true
//        }
    }
}
