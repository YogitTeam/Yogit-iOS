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
        view.addSubview(titleLabel)
        view.addSubview(lineView)
        view.addSubview(labelStackView)
        view.addSubview(memberImagesStackView)
        view.addSubview(memberNumberStackView)
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
//        stackView.backgroundColor = .systemBackground
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.red.cgColor
        [self.dateLabel,
         self.localityLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    
//    private lazy var hostStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = 2
//        stackView.alignment = .center
////        stackView.backgroundColor = .systemBackground
//        [hostImageView,
//         hostNameLabel].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()
    
//    private let hostNameLabel: UILabel = {
//       let label = UILabel()
////        label.textColor = .black
//        label.textAlignment = .left
//        label.font = .systemFont(ofSize: 12, weight: .semibold)
//        label.sizeToFit()
//        label.numberOfLines = 2
//        label.textColor = .white
//        label.text = "Junseo Park"
////        label.adjustsFontSizeToFitWidth = true
//        label.translatesAutoresizingMaskIntoConstraints = false
////        label.layer.borderWidth = 1
////        label.layer.borderColor = UIColor.gray.cgColor
//        return label
//    }()
//
//    private let hostImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.backgroundColor = .placeholderText
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
////        imageView.layer.borderColor = UIColor.white.cgColor
////        imageView.layer.borderWidth = 0.6
//        return imageView
//    }()

    private let titleLabel: UILabel = {
       let label = UILabel()
//        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.sizeToFit()
        label.numberOfLines = 2
        label.textColor = .white
//        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()
    
    private let boardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .placeholderText
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.addSubview(hostImageView)
//        imageView.addSubview(hostNameLabel)
//        imageView.tintColor = .black.withAlphaComponent(0.7)
//        imageView.layer.cornerRadius = 6
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.green.cgColor
//        imageView.isHidden = true
//        let customSize: CGFloat = contentView.frame.size.height * 2/3
//        imageView.frame.size = CGSize(width:  contentView.frame.size.width, height: customSize)
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.sizeToFit()
        label.textColor = .white//.systemBrown
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.brown.cgColor
        return label
    }()

    private let localityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.yellow.cgColor
        return label
    }()
    
//    private lazy var memberStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = 4
//        stackView.alignment = .center
//        stackView.backgroundColor = .clear
////        stackView.layer.borderWidth = 1
////        stackView.layer.borderColor = UIColor.red.cgColor
//        [memberNumberStackView,
//         memberImagesStackView].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()
    
    private let memberImagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = -4
        stackView.alignment = .center
        stackView.clipsToBounds = true
//        stackView.distribution = .fillProportionally//.fillEqually
        for i in 0..<6 {
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
            imageView.clipsToBounds = true
//            imageView.backgroundColor = .placeholderText
//            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
            imageView.layer.cornerRadius = 12
            imageView.contentMode = .scaleAspectFill
        
//            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 0.1
//            imageView.image = UIImage(named: "user\(i+1)")
            stackView.addArrangedSubview(imageView)
            
        }
        for i in 0..<6 {
            stackView.bringSubviewToFront(stackView.arrangedSubviews[5-i])
        }
        return stackView
    }()
    
    private lazy var memberNumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.backgroundColor = .clear
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.red.cgColor
        [memberNumberImageView,
         memberNumberLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let memberNumberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "MemberNumber")?.withTintColor(.white, renderingMode: .alwaysOriginal)
//        imageView.tintColor = .white
//        imageView.layer.cornerRadius = 6
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.green.cgColor
//        imageView.isHidden = true
//        let customSize: CGFloat = contentView.frame.size.height * 2/3
//        imageView.frame.size = CGSize(width:  contentView.frame.size.width, height: customSize)
        return imageView
    }()
    
    private let memberNumberLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()
    
//    private var memberImageViews: [UIImageView] = {
//        let imageViews = [UIImageView](repeating: UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24))), count: 6)
//        imageViews.forEach {
//            $0.clipsToBounds = true
//            $0.layer.borderWidth = 1
//            $0.layer.borderColor = UIColor.clear.cgColor
//            $0.contentMode = .scaleAspectFill
//        }
////        imageViews.clipsToBounds = true
////        imageViews.backgroundColor = .placeholderText
////        imageViews.translatesAutoresizingMaskIntoConstraints = false
////        imageViews.contentMode = .scaleAspectFill
////        imageView.layer.borderColor = UIColor.white.cgColor
////        imageView.layer.borderWidth = 0.6
//        return imageViews
//    }()

    
    // MARK: - Init (custom collection view cell)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [self.boardImageView,
         self.backView].forEach { contentView.addSubview($0) }
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        
//        contentView.backgroundColor = .systemBackground
        
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        contentView.layer.shadowRadius = 3
//        contentView.layer.shadowOpacity = 0.25
//        contentView.layer.cornerRadius = 6
//        contentView.layer.masksToBounds = true
//        layer.cornerRadius = 6
//        contentView.clipsToBounds = true
//        
//        selectedCell?.backView.layer.shadowColor = ServiceColor.primaryColor.cgColor
//        selectedCell?.backView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        selectedCell?.backView.layer.shadowRadius = 3
//        selectedCell?.backView.layer.shadowOpacity = 0.25
        
//        contentView.layer.masksToBounds = true
        
//        self.hostImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        self.hostImageView.layer.shadowRadius = 3
//        self.hostImageView.layer.shadowOpacity = 0.25
//
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 1
//        contentView.backgroundColor = .systemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        boardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.top.leading.trailing.equalToSuperview()
//            $0.height.equalTo(contentView.frame.width*3/4)
        }
        
//        backView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalTo(lineView.snp.top).offset(-4)
        }
        lineView.snp.makeConstraints {
            $0.height.equalTo(0.6)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(labelStackView.snp.top).offset(-4)
        }
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
////            $0.top.equalTo(boardImageView.snp.bottom)
//            $0.top.equalTo(labelStackView.snp.top).offset(-10)
//            $0.leading.trailing.bottom.equalToSuperview()
        }
        labelStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalTo(memberImagesStackView.snp.top).offset(-2)
        }
        memberNumberStackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
        }
        memberNumberImageView.snp.makeConstraints {
            $0.width.height.equalTo(12)
        }
//        memberStackView.snp.makeConstraints {
////            $0.height.equalTo(24)
//            $0.leading.bottom.equalToSuperview().inset(10)
//            $0.trailing.lessThanOrEqualToSuperview().inset(10)
//        }
        memberImagesStackView.snp.makeConstraints {
//            $0.height.equalTo(24)
            $0.leading.bottom.equalToSuperview().inset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(8)
        }
        
//        hostImageView.snp.makeConstraints {
////            $0.top.leading.equalToSuperview().inset(10)
//            $0.width.height.equalTo(24)
////            $0.leading.equalToSuperview().inset(10)
////            $0.bottom.equalToSuperview().inset(10)
////            $0.bottom.equalTo(labelStackView.snp.top).offset(-10)
//        }
//        hostNameLabel.snp.makeConstraints {
//            $0.leading.equalTo(hostImageView.snp.trailing).offset(6)
//            $0.top.equalToSuperview().inset(12)
//        }
//        hostImageView.layoutIfNeeded()
//        hostImageView.layer.cornerRadius = hostImageView.frame.width/2
        
//        localityLabel.snp.makeConstraints {
//            $0.leading.trailing.bottom.equalTo(contentView).inset(10)
//        }
//
//        memberNumberLabel.snp.makeConstraints {
//            $0.leading.trailing.equalTo(contentView).inset(10)
//        }
//
//        dateLabel.snp.makeConstraints {
//            $0.leading.trailing.equalTo(contentView).inset(10)
//        }
//
//        titleLabel.snp.makeConstraints {
//            $0.leading.trailing.equalTo(contentView).inset(10)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
//        self.hostImageView.image = nil

        self.boardImageView.image = nil
        self.titleLabel.text = nil
        self.dateLabel.text = nil
        self.localityLabel.text = nil
        self.memberNumberLabel.text = nil
    }
    
    func configure(with board: Board) {
        Task {
            let memberImageUrls = [String](repeating: board.profileImgURL, count: 6)
            await withTaskGroup(of: (Void).self) { taskGroup in
                for i in 0..<6{
                    taskGroup.addTask {
                        await self.boardImageView.setImage(with: board.imageURL)
                        if let imageView = await self.memberImagesStackView.arrangedSubviews[i] as? UIImageView {
                            if i >= memberImageUrls.count {
                                await imageView.setImage(with: "")
                                await MainActor.run {
                                    imageView.layer.borderColor = UIColor.clear.cgColor
                                }
                            } else {
                                await imageView.setImage(with: memberImageUrls[i])
                                await MainActor.run {
                                    imageView.layer.borderColor = UIColor.white.cgColor
                                }
                            }
                        }
                    }
                }
            }
            guard let changeDate = board.date.stringToDate()?.dateToStringUser() else { return } // ?.dateToString()
            await MainActor.run {
                self.titleLabel.text = board.title
                self.dateLabel.text = changeDate
                self.localityLabel.text = board.cityName// "Seoul"
                self.memberNumberLabel.text = "\(board.currentMember)/\(board.totalMember)"
            }
        }
    }
}
              
