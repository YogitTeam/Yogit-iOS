//
//  SmallGatheringBoardTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/06.
//

import UIKit
import CoreLocation

class SmallGatheringBoardTableViewCell: UITableViewCell {

    static let identifier = "SmallGatheringBoardTableViewCell"
    
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
    
//    private lazy var memberContentView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black.withAlphaComponent(0.3)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(memberStackView)
//        return view
//    }()
        
    private lazy var memberStackView: UIStackView = {
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
        imageView.image = UIImage(named: "MemberNumber")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
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
        label.textColor = .systemGray //.white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()
    
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.backgroundColor = .systemBackground
        [userStackView,
         labelStackView,
         boardImageView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    
//    private lazy var leftStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = 10
//        stackView.alignment = .center
//        stackView.backgroundColor = .systemBackground
//        [hostImageView,
//         labelStackView].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()
    
//    private lazy var leftStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.spacing = 2
//        stackView.alignment = .leading
////        stackView.layer.borderWidth = 1
////        stackView.layer.borderColor = UIColor.red.cgColor
//        [topLeftStackView, tagsLabel].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .leading
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.red.cgColor
        [titleLabel,
         dateStackView,
         localityStackView,
         tagsStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.red.cgColor
        [hostImageView,
        memberStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var boardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .placeholderText
        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.addSubview(memberContentView)
//        imageView.layer.cornerRadius = 6
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.green.cgColor
//        imageView.isHidden = true
//        let customSize: CGFloat = contentView.frame.size.height * 2/3
//        imageView.frame.size = CGSize(width:  contentView.frame.size.width, height: customSize)
        return imageView
    }()
    
    private let hostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .placeholderText
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let titleLabel: UILabel = {
       let label = UILabel()
//        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 2
//        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.gray.cgColor
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.backgroundColor = .systemBackground
        [dateImageView,
         dateLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let dateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Date")?.withTintColor(.systemBrown, renderingMode: .alwaysOriginal) // darkGray
//        imageView.backgroundColor = .placeholderText
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.red.cgColor
//        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBrown//.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.sizeToFit()
//        label.textColor = .systemBrown
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.brown.cgColor
        return label
    }()
    
    private lazy var localityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.backgroundColor = .systemBackground
        [localityImageView,
         localityLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let localityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Place")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
//        imageView.backgroundColor = .placeholderText
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let localityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray//.darkGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.sizeToFit()
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.yellow.cgColor
        return label
    }()
    
    private lazy var tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .top
        stackView.backgroundColor = .systemBackground
        [tagsImageView,
         tagsLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let tagsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Tag")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
//        imageView.backgroundColor = .placeholderText
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.red.cgColor
//        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray //.systemBrown //.systemYellow// ServiceColor.primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.sizeToFit()
        label.numberOfLines = 2
//        label.backgroundColor = .systemGray
//        label.layer.cornerRadius = 4
        
//        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.purple.cgColor
        return label
    }()
    
    // MARK: - Init (custom collection view cell)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [contentStackView].forEach { contentView.addSubview($0) } // self.boardImageView
//        contentView.clipsToBounds = true
//        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
//        contentView.layer.shadowOpacity = 0.5
////        contentView.layer.borderColor = UIColor.black.cgColor
////        contentView.layer.borderWidth = 1
//        contentView.backgroundColor = .systemBackground
        
        
        
        
//        contentView.layer.cornerRadius = contentView.frame.width / 10
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        contentView.layer.shadowOpacity = 0.2
//        contentView.layer.shadowRadius = 2.0
//        contentView.layer.masksToBounds = false
//        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
//        contentView.layer.shouldRasterize = true
//        contentView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        leftStackView.snp.makeConstraints {
        //            $0.centerY.equalToSuperview()
        //            $0.leading.equalToSuperview().inset(20)
        ////            $0.top.greaterThanOrEqualToSuperview().inset(10)
        ////            $0.bottom.lessThanOrEqualToSuperview().inset(10)
        ////            $0.trailing.equalTo(boardImageView.snp.leading).offset(-10)
        //        }
        
        localityImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
        }
        
        dateImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
        }
        
        hostImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        tagsImageView.snp.makeConstraints {
            $0.width.height.equalTo(13)
        }
        
        hostImageView.layer.cornerRadius = hostImageView.frame.size.width / 2
        
//        localityLabel.snp.makeConstraints {
//            $0.trailing.equalTo(contentView)
//        }
//
//        memberNumberLabel.snp.makeConstraints {
//            $0.trailing.equalTo(contentView)
//        }
//
//        dateLabel.snp.makeConstraints {
//            $0.trailing.equalTo(contentView)
//        }
//
//        titleLabel.snp.makeConstraints {
//            $0.trailing.equalTo(contentView)
//        }
        
        
        boardImageView.snp.makeConstraints {
//            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(110)
            $0.centerY.equalToSuperview()
//            $0.top.bottom.equalToSuperview().inset(10)
//            $0.bottom.equalToSuperview().inset(10)
        }
        
        boardImageView.layer.cornerRadius = boardImageView.frame.size.width / 12
        
        memberNumberImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
        }
            
//        memberStackView.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }

//        memberContentView.snp.makeConstraints {
////            $0.top.trailing.equalToSuperview().inset(6)
//            $0.height.equalTo(memberStackView).inset(-1)
//            $0.width.equalTo(memberStackView).inset(-4)
//        }
//
//        memberContentView.layer.cornerRadius = memberContentView.frame.size.width / 6
        
        contentStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        hostImageView.image = nil
        boardImageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        localityLabel.text = nil
        tagsLabel.text = nil
    }
    
    func forwardGeocoding(address: String, completion: @escaping (String, String) -> Void) {
        print("forwardGeocoding locality", address)
        let geocoder = CLGeocoder()
//        let locale = Locale(identifier: "en_US")
        guard let identifier = Locale.preferredLanguages.first else { return }// en-KR
        let region = Locale.current.region?.identifier // KR
        let locale = Locale(identifier: identifier)

        // 주소 다됨 (country, locality, "KR" >> South Korea)
        geocoder.geocodeAddressString(address, in: nil, preferredLocale: locale, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Failed to geocodeAddressString location")
                return
            }

            guard let pm = placemarks?.last else { return }
            guard let locality = pm.locality else { return }
            guard let countryCodeName = pm.country else { return }
            print("forwardGeocoding locality and county", locality, countryCodeName)
            completion(locality, countryCodeName)
        })
    }

    
    func configure(with board: Board) {
        boardImageView.setImage(with: board.imageURL)
        hostImageView.setImage(with: board.profileImgUrls.first ?? "")
        if board.boardID % 2 == 0 {
            titleLabel.text = "홍대 영어 회화 모임" // board.title
            tagsLabel.text = "영어 초보자 환영"
        } else {
            titleLabel.text = board.title + "ㅇㄹㅁㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㄹㅁㄴ"
            tagsLabel.text = "영어 초보자 환영, 편안한 모임, 영어 초보자 환영, 편안한 모임"
        }
        dateLabel.text = board.date.stringToDate()?.dateToStringUser()
        forwardGeocoding(address: board.cityName) { (locality, countryCodeName) in
            self.localityLabel.text = locality
        }
        memberNumberLabel.text = "\(board.currentMember)/\(board.totalMember)"
    }
}

