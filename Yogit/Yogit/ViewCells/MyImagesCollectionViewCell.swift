//
//  MyImagesCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/27.
//

import UIKit
import Kingfisher

class MyImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyImagesCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(rgb: 0xCDCCCC, alpha: 1)
        imageView.tintColor = UIColor(rgb: 0xEBEBEB, alpha: 1)
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
        label.backgroundColor = UIColor(rgb: 0xEBEBEB, alpha: 0.5)
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
        configureView()
        configureLayout()
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
    
    private func configureView() {
        contentView.addSubview(imageView)
        contentView.addSubview(imageSequenceLabel)
        contentView.addSubview(mainImageLabel)
    }
    
    private func configureLayout() {
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
    
    func configureDownload(imageString: String, sequence: Int, kind: Kind) {
        self.imageView.setImage(with: imageString)
        self.imageSequenceLabel.text = "\(sequence)"
        switch kind {
        case .profile: if sequence == 1 { mainImageLabel.isHidden = false }
        case .boardSelectDetail: break
        default: fatalError("Not exist kind of imageview")
        }
    }
    
    func configureUpload(image: UIImage, sequence: Int, kind: Kind) {
        self.imageView.image = image
        self.imageSequenceLabel.text = "\(sequence)"
        switch kind {
        case .profile: if sequence == 1 { mainImageLabel.isHidden = false }
        case .boardSelectDetail: break
        default: fatalError("Not exist kind of imageview")
        }
    }
    

    func configureNull(image: UIImage?, sequence: Int, kind: Kind) { // imageString: String,
        self.imageView.image = image
        self.imageSequenceLabel.text = "\(sequence)"
        switch kind {
        case .profile: if sequence == 1 { mainImageLabel.isHidden = false }
        case .boardSelectDetail: break
        default: fatalError("Not exist kind of imageview")
        }
    }
}
