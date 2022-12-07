////
////  ClipBoardTableViewCell.swift
////  Yogit
////
////  Created by Junseo Park on 2022/12/07.
////
//
//import UIKit
//
//class ClipBoardTableViewCell: UITableViewCell {
//    static let identifier = "ClipBoardTableViewCell"
////    let chatLabel: UILabel = {
////        let label = UILabel()
////        label.font = .systemFont(ofSize: 14, weight: .regular)
////        label.sizeToFit()
//////        label.textColor = .black
////        return label
////    }()
//    
//    private var userId: Int64?
//    
//    private lazy var chatView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemGray
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 6
//        view.addSubview(chatLabel)
//        return
//    }()
//    
//    private let chatLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
//        label.numberOfLines = 0
//        label.sizeToFit()
//        label.textColor = .white
////        label.layer.masksToBounds = true
////        label.backgroundColor = .systemGray
////        label.layer.cornerRadius = 6
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
//    
//    
//    private let userImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 6
//        return imageView
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        addSubview(chatView)
//        addSubview(userImageView)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
////    override func layoutSubviews() {
////        super.layoutSubviews()
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
////    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        chatLabel.text = nil
//        userImageView.image = nil
////        cellLabel.font = .systemFont(ofSize: 14, weight: .regular)
//    }
//
//    func configure(userId: Int64, isMe: Bool, imageUrl: String, coment: String, updateDate: String) {
//        var userImage: UIImage?
//        DispatchQueue.global().async {
//            imageUrl.urlToImage { (image) in
//                guard let image = image else { return }
//                userImage = image
//            }
//        }
//        self.userId = userId
//        self.userImageView.image = userImage
//        self.chatLabel.text = coment
//        if isMe {
//            userImageView.snp.makeConstraints { make in
//                make.top.equalToSuperview().inset(10)
//                make.leading.equalToSuperview().inset(20)
//                make.width.height.equalTo(36)
//            }
//            chatView.snp.makeConstraints { make in
//                make.top.equalTo(userImageView.snp.bottom).offset(-4)
//                make.leading.equalTo(userImageView.snp.trailing).offset(4)
//                make.trailing.equalToSuperview().inset(20)
//                make.width.height.equalTo(chatLabel).inset(-6)
//            }
//            userImageView.isHidden = false
//        } else {
//            userImageView.snp.makeConstraints { make in
//                make.top.equalToSuperview().inset(10)
//                make.trailing.equalTo(chatView.snp.leading)
//                make.width.height.equalTo(36)
//            }
//            chatView.snp.makeConstraints { make in
//                make.top.equalTo(userImageView.snp.bottom).offset(-4)
////                make.leading.equalTo(userImageView.snp.trailing).offset(4)
//                make.trailing.equalToSuperview().inset(20)
//                make.width.height.equalTo(chatLabel).inset(-6)
//            }
//            userImageView.isHidden = true
//        }
//    }
//}
