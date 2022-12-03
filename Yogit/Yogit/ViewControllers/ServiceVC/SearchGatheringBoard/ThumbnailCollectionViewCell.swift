//
//  ThumbnailCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import UIKit

import UIKit
import SnapKit

//struct ThumbnailCollectionCellViewModel {
//    let name: String
//    let backgroundColor: UIColor
//}

class ThumbnailCollectionViewCell: UICollectionViewCell {
    static let identifier = "ThumbnailCollectionViewCell"
    
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
//
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .top
        stackView.backgroundColor = .systemBackground
        [self.hostImageView,
         self.labelStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.red.cgColor
        [self.titleLabel,
         self.cityLabel,
         self.dateLabel,
         self.memberNumberLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var boardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 6
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.green.cgColor
//        imageView.isHidden = true
//        let customSize: CGFloat = contentView.frame.size.height * 2/3
//        imageView.frame.size = CGSize(width:  contentView.frame.size.width, height: customSize)
        return imageView
    }()
    
    private lazy var hostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .placeholderText
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let titleLabel: UILabel = {
       let label = UILabel()
//        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 2
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
        [self.bottomStackView, self.boardImageView].forEach { contentView.addSubview($0) }
//        contentView.addSubview(thumbnailContentView)
        contentView.clipsToBounds = true
//        contentView.layer.cornerRadius = 10
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowOpacity = 0.5
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .systemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        boardImageView.frame = contentView.bounds
        boardImageView.snp.makeConstraints {
//            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(contentView.frame.size.width)
            $0.height.equalTo(contentView.frame.size.width*2/3)
//            $0.bottom.equalTo(bottomContentView.snp.top)
            
        }
        
        boardImageView.layer.cornerRadius = contentView.frame.size.width / 18
    
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(boardImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        hostImageView.snp.makeConstraints {
            $0.width.height.equalTo(contentView.frame.size.width / 5.5)
            $0.leading.equalTo(contentView)
        }
        
        hostImageView.layer.cornerRadius = contentView.frame.size.width / 11
        
        cityLabel.snp.makeConstraints {
            $0.trailing.equalTo(contentView)
        }
        
        memberNumberLabel.snp.makeConstraints {
            $0.trailing.equalTo(contentView)
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.trailing.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    func configure(with viewModels: ThumbnailCollectionCellViewModel) {
//        contentView.backgroundColor = viewModels.backgroundColor
//        label.text = viewModels.name
//    }
    
    func configure(with board: Board) {
        DispatchQueue.global().async {
            var boardImage: UIImage?
            var hostImage: UIImage?
            print(board.imageURL)
            board.imageURL.urlToImage { (image) in
                guard let image = image else { return }
                boardImage = image
            }
            board.profileImgURL.urlToImage { (image) in
                guard let image = image else { return }
                hostImage = image
            }
            DispatchQueue.main.async {
                guard let changeDate = board.date.stringToDate()?.dateToString() else { return }
                self.boardImageView.image = boardImage
                self.hostImageView.image = hostImage
                self.titleLabel.text = board.title
                self.dateLabel.text = changeDate
                self.cityLabel.text = "Seoul"
                self.memberNumberLabel.text = "3/10"
            }
        }
    }
}

