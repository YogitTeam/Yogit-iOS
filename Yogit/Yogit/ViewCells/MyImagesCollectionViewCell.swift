//
//  MyImagesCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/27.
//

import UIKit

class MyImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyImagesCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
//        imageView.backgroundColor = UIColor(rgb: 0xD9D9D9, alpha: 1.0)
        imageView.backgroundColor = .placeholderText
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.addSubview(imageSequenceView)
        imageView.addSubview(mainImageView)
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
        view.backgroundColor = .placeholderText.withAlphaComponent(0.5)
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
        view.layer.cornerRadius = 8
        view.addSubview(mainImageLabel)
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
//        contentView.addSubview(imageView)
//        contentView.addSubview(imageSequenceView)
//        contentView.addSubview(mainImageView)
//        contentView.addSubview(deleteButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("profile images layoutSubviews")
        imageView.frame = contentView.bounds

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
        mainImageView.isHidden = true
    }

    func configure(image: UIImage?, sequence: Int, kind: Kind) {
        imageView.image = image
        imageSequenceLabel.text = "\(sequence)"
        switch kind {
        case .profile: if sequence == 1 { mainImageView.isHidden = false }
        case .boardSelectDetail: break
        default: fatalError("Not exist kind of imageview")
        }
    }
}
