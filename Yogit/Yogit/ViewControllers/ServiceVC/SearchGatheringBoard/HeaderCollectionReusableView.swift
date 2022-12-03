////
////  HeaderCollectionReusableView.swift
////  Yogit
////
////  Created by Junseo Park on 2022/11/27.
////
//
//import UIKit
//import SnapKit
//
//class HeaderCollectionReusableView: UICollectionReusableView {
//    
//    static let identifier = "HeaderCollectionReusableView"
//    
//    private let headerLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.font = .systemFont(ofSize: 12, weight: UIFont.Weight.regular)
//        label.text = "Main Photo"
//        label.sizeToFit()
//        label.adjustsFontSizeToFitWidth = true
//        label.numberOfLines = 1
//        label.layer.borderColor = UIColor.systemYellow.cgColor
//        label.layer.borderWidth = 1
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(headerLabel)
////        contentView.addSubview(imageView)
////        contentView.addSubview(imageSequenceView)
////        contentView.addSubview(mainImageView)
////        contentView.addSubview(deleteButton)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        headerLabel.frame = bounds
//        print("profile images layoutSubviews")
////        headerLabel.snp.makeConstraints { make in
////            make.edges.equalToSuperview()
////        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
////        imageView.image = nil
////        imageSequenceLabel.text = nil
////        mainImageView.isHidden = true
//    }
//
////    func configure(image: UIImage?, sequence: Int, kind: Kind) {
////        imageView.image = image
////        imageSequenceLabel.text = "\(sequence)"
////        switch kind {
////        case .profile: if sequence == 1 { mainImageView.isHidden = false }
////        case .boardSelectDetail: break
////        default: fatalError("Not exist kind of imageview")
////        }
////    }
//}
