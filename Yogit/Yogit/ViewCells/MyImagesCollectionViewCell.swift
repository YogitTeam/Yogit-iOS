//
//  MyImagesCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/27.
//

import UIKit
import Kingfisher
import SkeletonView

class MyImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyImagesCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(rgb: 0xCDCCCC, alpha: 1)
        imageView.tintColor = UIColor(rgb: 0xEBEBEB, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.isSkeletonable = true
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
        label.backgroundColor = UIColor(rgb: 0xEBEBEB, alpha: 0.5)
        label.isSkeletonable = true
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
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageSequenceLabel.text = nil
        mainImageLabel.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    private func configureView() {
        contentView.addSubview(imageView)
        contentView.addSubview(imageSequenceLabel)
        contentView.addSubview(mainImageLabel)
    }
    
    func configureDownload(imageString: String, sequence: Int, kind: Kind) {
        imageView.setImage(with: imageString)
        imageSequenceLabel.text = "\(sequence)"
        switch kind {
        case .profile: if sequence == 1 { mainImageLabel.isHidden = false }
        case .boardSelectDetail: break
        default: fatalError("Not exist kind of imageview")
        }
    }
    
    func configureUpload(image: UIImage, sequence: Int, kind: Kind) {
        imageView.image = image
        imageSequenceLabel.text = "\(sequence)"
        switch kind {
        case .profile: if sequence == 1 { mainImageLabel.isHidden = false }
        case .boardSelectDetail: break
        default: fatalError("Not exist kind of imageview")
        }
    }
    

    func configureNull(image: UIImage?, sequence: Int, kind: Kind) { // imageString: String,
        imageView.image = image
        imageSequenceLabel.text = "\(sequence)"
        switch kind {
        case .profile: if sequence == 1 { mainImageLabel.isHidden = false }
        case .boardSelectDetail: break
        default: fatalError("Not exist kind of imageview")
        }
    }
}
