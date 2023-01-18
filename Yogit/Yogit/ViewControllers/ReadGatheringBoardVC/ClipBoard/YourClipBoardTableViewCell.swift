//
//  ClipBoardTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/07.
//

import UIKit

class YourClipBoardTableViewCell: UITableViewCell {
    static let identifier = "YourClipBoardTableViewCell"
    
    private var userId: Int64?
    
    private lazy var chatView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray // my: systemGray, you: blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
//        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
//        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .placeholderText
        imageView.layer.borderColor = UIColor.placeholderText.cgColor
        imageView.layer.borderWidth = 0.3
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(chatView)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(44)
        }
        userImageView.layer.cornerRadius = 22
        chatView.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.top).offset(22)
            $0.leading.equalTo(userImageView.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview().inset(50).priority(.high)
            $0.bottom.equalToSuperview().inset(10).priority(.high)
        }
        chatLabel.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userId = nil
        chatLabel.text = nil
        userImageView.image = nil
//        cellLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }

    func configure(userId: Int64, imageUrl: String, coment: String, updateDate: String) {
        self.userId = userId
        self.chatLabel.text = coment
        DispatchQueue.global().async {
            imageUrl.urlToImage { (image) in
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.userImageView.image = image
                }
            }
        }
    }
}

