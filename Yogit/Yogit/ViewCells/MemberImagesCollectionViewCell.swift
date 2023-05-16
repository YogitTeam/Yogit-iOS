//
//  MemberImagesCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/04.
//

import UIKit
import SkeletonView

class MemberImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MemberImagesCollectionViewCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
//        imageView.backgroundColor = .placeholderText
//        imageView.tintColor = .systemGray.withAlphaComponent(0.5) // image color
        imageView.contentMode = .scaleAspectFill
        imageView.isSkeletonable = true
//        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        configureView()
        configureLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = contentView.frame.height/2
    }
    
    private func configureView() {
        contentView.addSubview(imageView)
    }
    
    private func configureLayout() {
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configure(imageString: String) {
        if imageString.contains("null") {
            imageView.image = UIImage(named: "profileImageNULL")
        } else {
            imageView.setImage(with: imageString)
        }
    }
}
