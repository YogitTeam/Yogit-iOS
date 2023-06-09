//
//  GatheringGatheringThumbnailCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/19.
//

import UIKit
import SkeletonView
import CoreLocation

class GatheringBoardThumbnailCollectionViewCell: UICollectionViewCell {
    static let identifier = "GatheringThumbnailCollectionViewCell"
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(lineView)
        view.addSubview(bottomStackView)
        view.addSubview(memberNumberStackView)
        view.backgroundColor = .black.withAlphaComponent(0.1)
        view.isSkeletonable = true
        return view
    }()
    
    private let blurView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white.withAlphaComponent(0.45)
        view.isHidden = true
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.isSkeletonable = true
        [self.dateLabel,
         self.localityLabel,
         self.memberImagesStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private let dateformatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        if let localeIdentifier = Locale.preferredLanguages.first {
            dateFormatter.locale = Locale(identifier: localeIdentifier)
        }
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter
    }()
    


    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.sizeToFit()
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        return label
    }()
    
    private let boardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isSkeletonable = true
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.sizeToFit()
        label.textColor = .white//.systemBrown
        label.numberOfLines = 1
        return label
    }()

    private let localityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private let memberImagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = -4
        stackView.alignment = .center
        stackView.clipsToBounds = true
        stackView.isSkeletonable = true
//        stackView.distribution = .fillProportionally//.fillEqually
        for i in 0..<6 {
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 24, height: 24)))
            imageView.clipsToBounds = true
            imageView.image = nil
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
            imageView.layer.cornerRadius = 12
            imageView.contentMode = .scaleAspectFill
            imageView.layer.borderColor = UIColor.clear.cgColor
            imageView.layer.borderWidth = 0.1
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
        stackView.isSkeletonable = true
        [memberNumberImageView,
         memberNumberLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let memberNumberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "MemberNumber")?.withTintColor(.white, renderingMode: .alwaysOriginal)
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
        return label
    }()

    
    // MARK: - Init (custom collection view cell)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        configureView()
        configureLayout()
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
    }
    
    private func configureView() {
        [boardImageView,
         backView,
         blurView].forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        boardImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalTo(lineView.snp.top).offset(-4)
        }
        lineView.snp.makeConstraints {
            $0.height.equalTo(0.6)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomStackView.snp.top).offset(-4)
        }
        dateLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        localityLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bottomStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(8)
        }
        memberNumberStackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
        }
        memberNumberImageView.snp.makeConstraints {
            $0.width.height.equalTo(12)
        }
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        boardImageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        localityLabel.text = nil
        memberNumberLabel.text = nil
        backView.backgroundColor = .black.withAlphaComponent(0.1)
        lineView.isHidden = true
        blurView.isHidden = true
    }
    
    func forwardGeocoding(address: String, completion: @escaping (String, String) -> Void) {
        let geocoder = CLGeocoder()
        guard let identifier = Locale.preferredLanguages.first else { return }// en-KR
        let locale = Locale(identifier: identifier)

        // 주소 다됨 (country, locality, "KR" >> South Korea)
        geocoder.geocodeAddressString(address, in: nil, preferredLocale: locale, completionHandler: { (placemarks, error) in
            if error != nil { return }

            guard let pm = placemarks?.last else { return }
            guard let locality = pm.locality else { return }
            guard let countryCodeName = pm.country else { return }
            
            completion(locality, countryCodeName)
        })
    }
    
    func configure(with board: Board) async {
        let memberImageUrls = board.profileImgUrls
        boardImageView.setImage(with: board.imageURL)
        await withTaskGroup(of: (Void).self) { taskGroup in
            for i in 0..<6 {
                taskGroup.addTask {
                    if let imageView = await self.memberImagesStackView.arrangedSubviews[i] as? UIImageView {
                        if i >= memberImageUrls.count {
                            await MainActor.run {
                                imageView.image = nil
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
        guard let boardDate = board.date.stringToDate() else { return }
        guard let currentDate = Date().dateToStringUTC().stringToDate() else { return }
        let timeInterval = boardDate.timeIntervalSince(currentDate)
        let showToDate = boardDate.dateAndMonthFormatter()
        if timeInterval < 0 {
            blurView.isHidden = false
        }
        await MainActor.run {
            backView.backgroundColor = .black.withAlphaComponent(0.25)
            lineView.isHidden = false
            titleLabel.text = board.title
            dateLabel.text = showToDate
            forwardGeocoding(address: board.cityName) { [weak self] (cityName, countryName) in
                self?.localityLabel.text = cityName
            }
            memberNumberLabel.text = "\(board.currentMember)/\(board.totalMember)"
        }
    }
}
              
