////
////  PushNotificationTableViewCell.swift
////  Yogit
////
////  Created by Junseo Park on 2023/04/20.
////
//
import UIKit

class PushNotificationTableViewCell: UITableViewCell {
    
    static let identifier = "PushNotificationTableViewCell"
    
    private enum TimeUnit {
        case year
        case month
        case week
        case day
        case hour
        case minute
        case second
        
        func toString() -> String {
            let str: String
            switch self {
            case .year: str = "YEAR"
            case .month: str = "MONTH"
            case .week: str = "WEEK"
            case .day: str = "DAY"
            case .hour: str = "HOUR"
            case .minute: str = "MINUTE"
            case .second: str = "SECOND"
            }
            return str.localized() + " " + "AGO".localized()
        }
    }
    
    private lazy var notiContenView:  UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        [self.notiStackView].forEach { view.addSubview($0) }
        return view
    }()
    
    private lazy var notiStackView: UIView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .top
        [self.notiImageView,
         self.notiLabelStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var notiLabelStackView: UIView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        [self.notiTitleLabel,
         self.notiBodyLabel,
         self.notiTimeLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private let notiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()

    private let notiTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()

    private let notiBodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    
    private let notiTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = .systemGray
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureLayout()
    }

    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        notiTitleLabel.text = nil
        notiBodyLabel.text = nil
        notiTimeLabel.text = nil
    }
    
    private func configureView() {
        contentView.addSubview(notiContenView)
    }
    
    private func configureLayout() {
        notiImageView.snp.makeConstraints {
            $0.width.height.equalTo(36)
        }
        notiContenView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        notiStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(data: PushNotification) {
        guard let date = data.time.stringToDate() else { return }
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: Date())
        // DateComponentsFormatter를 사용하여 상대적인 시간 표현을 생성
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full

        let timeUnit: TimeUnit
        let time: Int?
        if let year = components.year, year > 0 {
            timeUnit = .year
            time = year
        } else if let month = components.month, month > 0 {
            timeUnit = .month
            time = month
        } else if let day = components.day, day > 0 {
            timeUnit = .day
            time = day
        } else if let hour = components.hour, hour > 0 {
            timeUnit = .hour
            time = hour
        } else {
            timeUnit = .second
            time = nil
        }
        DispatchQueue.main.async { [self] in
            notiImageView.image = UIImage(named: "ServiceIcon")
            notiTitleLabel.text = data.title
            notiBodyLabel.text = data.body
            let timeString: String
            if let time = time {
                timeString = "\(time) \(timeUnit.toString())"
            } else {
                timeString = timeUnit.toString()
            }
            notiTimeLabel.text = timeString
            if data.isOpened {
                contentView.backgroundColor = .systemBackground
            } else {
                contentView.backgroundColor = .systemGray6
            }
        }
    }
}
