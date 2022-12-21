//
//  GatheringGatheringThumbnailCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/19.
//

import UIKit

class GatheringBoardThumbnailCollectionViewCell: UICollectionViewCell {
    static let identifier = "GatheringThumbnailCollectionViewCell"
    
//    private lazy var thumbnailContentView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        view.clipsToBounds = true
//        [self.boardImageView, self.hostImageView, self.labelStackView].forEach { view.addSubview($0) }
//        return view
//    }()
    
//    private lazy var bottomContentView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        view.addSubview(bottomStackView)
//        return view
//    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelStackView)
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.red.cgColor
        [self.titleLabel,
         self.dateLabel,
         self.cityLabel,
         self.memberNumberLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var boardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .placeholderText
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(backView)
//        imageView.tintColor = .black.withAlphaComponent(0.7)
//        imageView.layer.cornerRadius = 6
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.green.cgColor
//        imageView.isHidden = true
//        let customSize: CGFloat = contentView.frame.size.height * 2/3
//        imageView.frame.size = CGSize(width:  contentView.frame.size.width, height: customSize)
        return imageView
    }()
    
//    private let hostImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.backgroundColor = .placeholderText
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 18
//        return imageView
//    }()

    private let titleLabel: UILabel = {
       let label = UILabel()
//        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.sizeToFit()
        label.numberOfLines = 2
        label.textColor = .white
//        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.sizeToFit()
        label.textColor = .systemBrown
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.brown.cgColor
        return label
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.sizeToFit()
        label.textColor = .white
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.yellow.cgColor
        return label
    }()

    private let memberNumberLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.sizeToFit()
        label.textColor = .white
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.purple.cgColor
        return label
    }()
    
    // MARK: - Init (custom collection view cell)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [self.boardImageView].forEach { contentView.addSubview($0) }
        contentView.clipsToBounds = true
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.cornerRadius = 6
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .systemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        boardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        labelStackView.snp.makeConstraints {
//            $0.bottom.equalTo(contentView).inset(10)
//        }
        
        cityLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(contentView).inset(10)
        }
        
        memberNumberLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(10)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
//        self.hostImageView.image = nil
        self.boardImageView.image = nil
        self.titleLabel.text = nil
        self.dateLabel.text = nil
        self.cityLabel.text = nil
        self.memberNumberLabel.text = nil
    }
    
    func configure(with board: Board) {
        DispatchQueue.global().async {
            var boardImage: UIImage?
//            var hostImage: UIImage?
            print(board.imageURL)
            board.imageURL.urlToImage { (image) in
                guard let image = image else { return }
                boardImage = image
            }
//            board.profileImgURL.urlToImage { (image) in
//                guard let image = image else {
//                    return
//                }
//                hostImage = image
//            }
            DispatchQueue.main.async() {
                self.boardImageView.image = boardImage
//                self.hostImageView.image = hostImage
                guard let changeDate = board.date.stringToDate()?.dateToStringUser() else { return } // ?.dateToString()
                self.titleLabel.text = board.title
                self.dateLabel.text = changeDate
                self.cityLabel.text = board.cityName// "Seoul"
                self.memberNumberLabel.text = "" // "\(board.currentMember) / \(board.totalMember)"
            }
        }
    }
}

