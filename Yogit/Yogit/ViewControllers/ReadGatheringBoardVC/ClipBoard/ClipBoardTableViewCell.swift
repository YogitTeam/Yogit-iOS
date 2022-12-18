//
//  ClipBoardTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/07.
//

import UIKit

class ClipBoardTableViewCell: UITableViewCell {
    static let identifier = "ClipBoardTableViewCell"
    
    private var userId: Int64?
    
    private lazy var chatView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray // my: systemGray, you: blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.addSubview(chatLabel)
        return view
    }()
    
    private let chatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.sizeToFit()
//        label.textColor = .white
//        label.layer.masksToBounds = true
//        label.backgroundColor = .systemGray
//        label.layer.cornerRadius = 6
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .placeholderText
        imageView.layer.borderColor = UIColor.placeholderText.cgColor
        imageView.layer.borderWidth = 0.3
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(chatView)
        contentView.addSubview(userImageView)
//        contentView.addSubview(chatLabel)
        configureViewComponent()
    }
    
    private func configureViewComponent() {
        contentView.backgroundColor = .systemBackground
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        userImageView.snp.makeConstraints { make in
////            make.top.equalToSuperview().inset(10)
////            make.leading.equalToSuperview().inset(20)
////            make.width.height.equalTo(36)
////        }
////        chatView.snp.makeConstraints { make in
////            make.top.equalTo(userImageView.snp.bottom).offset(-4)
////            make.leading.equalTo(userImageView.snp.trailing).offset(4)
////            make.width.height.equalTo(chatLabel).inset(-6)
////        }
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userId = nil
        chatLabel.text = nil
        userImageView.image = nil
//        cellLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }

    func configure(userId: Int64, isMe: Bool, imageUrl: String, coment: String, updateDate: String) {
        self.userId = userId
        self.chatLabel.text = coment
        chatLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
            $0.top.bottom.leading.trailing.equalToSuperview().inset(10)
        }
        if isMe {
            chatView.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0).withAlphaComponent(0.9)
            self.userImageView.image = nil
            chatView.snp.makeConstraints {
                $0.top.bottom.trailing.equalToSuperview().inset(10)
                $0.leading.equalTo(chatLabel.snp.leading).inset(-10)
                $0.leading.greaterThanOrEqualToSuperview().inset(50)
            }
        } else {
            chatView.backgroundColor = .systemGray2.withAlphaComponent(0.9)
            userImageView.image = UIImage(named: "user1")!
            userImageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(10)
                $0.leading.equalToSuperview().inset(20)
                $0.width.height.equalTo(44)
            }
            userImageView.layer.cornerRadius = 22
            chatView.snp.makeConstraints {
                $0.top.equalTo(userImageView.snp.bottom).offset(-22)
                $0.leading.equalTo(userImageView.snp.trailing).offset(4)
                $0.trailing.equalTo(chatLabel.snp.trailing).inset(-10)
                $0.trailing.lessThanOrEqualToSuperview().inset(50)
                $0.bottom.equalToSuperview().inset(10)
            }
        }

    }
}

