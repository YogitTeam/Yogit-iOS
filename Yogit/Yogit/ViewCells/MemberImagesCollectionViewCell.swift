//
//  MemberImagesCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/04.
//

import UIKit

class MemberImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "MemberImagesCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .placeholderText
//        imageView.tintColor = .systemGray.withAlphaComponent(0.5) // image color
        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("Member images layoutSubviews")
        imageView.frame = contentView.bounds
        imageView.layer.cornerRadius = contentView.frame.height/2
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configure(image: UIImage?) {
        imageView.image = image
    }
}
