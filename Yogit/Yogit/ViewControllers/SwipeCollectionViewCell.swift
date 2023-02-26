//
//  SwipeCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/03.
//

import UIKit

class SwipeCollectionViewCell: UICollectionViewCell {
    static let identifier = "SwipeThumbnailCollectionViewCell"
//
//    private lazy var backView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(titleLabel)
//        view.backgroundColor = .black.withAlphaComponent(0.3)
//        return view
//    }()

//
//    private lazy var boardImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.backgroundColor = .placeholderText
//        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.addSubview(backView)
////        imageView.tintColor = .black.withAlphaComponent(0.7)
////        imageView.layer.cornerRadius = 6
////        imageView.layer.borderWidth = 1
////        imageView.layer.borderColor = UIColor.green.cgColor
////        imageView.isHidden = true
////        let customSize: CGFloat = contentView.frame.size.height * 2/3
////        imageView.frame.size = CGSize(width:  contentView.frame.size.width, height: customSize)
//        return imageView
//    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
//        label.textColor = .black
        label.text = "titleLabel"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 1
//        label.textColor = .white
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()

    // MARK: - Init (custom collection view cell)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        [self.boardImageView].forEach { contentView.addSubview($0) }
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
//        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
//        contentView.layer.shadowOpacity = 0.5
//        contentView.layer.cornerRadius = 6
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .systemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        boardImageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
        
//        backView.snp.makeConstraints {
//            $0.top.bottom.leading.trailing.equalToSuperview().inset(-10)
//            $0.edges.equalToSuperview()
//        }
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(titleLabel).inset(-10)
        }
//        titleLabel.snp.makeConstraints {
////            $0.center.equalToSuperview()
//            $0.top.bottom.leading.trailing.equalToSuperview().inset(10)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
//        self.boardImageView.image = nil
        self.titleLabel.text = nil
 
    }
    
    func configure(tag: String) {
        print("configure")
        DispatchQueue.global().async {
//            var boardImage: UIImage?
////            var hostImage: UIImage?
//            print(board.imageURL)
//            board.imageURL.urlToImage { (image) in
//                guard let image = image else { return }
//                boardImage = image
//            }
//            board.profileImgURL.urlToImage { (image) in
//                guard let image = image else {
//                    return
//                }
//                hostImage = image
//            }
            DispatchQueue.main.async() {
//                self.boardImageView.image = boardImage
                self.titleLabel.text = tag
            }
        }
    }
}

