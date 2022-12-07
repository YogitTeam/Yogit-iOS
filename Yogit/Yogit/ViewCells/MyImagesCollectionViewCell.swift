//
//  MyImagesCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/27.
//

import UIKit

class MyImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyImagesCollectionViewCell"
    
    private var imageId: Int64?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .placeholderText
        imageView.tintColor = .systemGray.withAlphaComponent(0.5) // image color
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    

    
    private let imageSequenceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.numberOfLines = 1
        label.backgroundColor = .systemGray.withAlphaComponent(0.5)
        return label
    }()

    private let mainImageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = .white
        label.text = "Main Photo"
        label.sizeToFit()
        label.numberOfLines = 1
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.backgroundColor = UIColor(rgb: 0x3246FF, alpha: 1.0)
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(imageSequenceLabel)
        contentView.addSubview(mainImageLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("profile images layoutSubviews")
        imageView.frame = contentView.bounds

        imageSequenceLabel.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.leading.equalToSuperview().inset(6)
        }

        mainImageLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.bottom.trailing.equalToSuperview().inset(6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageId = nil
        imageView.image = nil
        imageSequenceLabel.text = nil
        mainImageLabel.isHidden = true
    }

    func configure(image: UIImage?, imageId: Int64?, sequence: Int, kind: Kind) {
        self.imageView.image = image
        self.imageId = imageId
        self.imageSequenceLabel.text = "\(sequence)"
        switch kind {
        case .profile: if sequence == 1 { mainImageLabel.isHidden = false }
        case .boardSelectDetail: break
        default: fatalError("Not exist kind of imageview")
        }
    }
    
    func getImageID() -> Int64? {
        return imageId
    }
}
