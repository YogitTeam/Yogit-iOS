////
////  JoinListTableViewCell.swift
////  Yogit
////
////  Created by Junseo Park on 2023/02/02.
////
//
//import UIKit
//import SnapKit
//
//class JoinListTableViewCell: UITableViewCell {
//
//    static let identifier = "JoinListTableViewCell"
//    
//    // MARK: - Property
//
//    private let cellLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 14, weight: .regular)
////        label.textColor = .black
//        return label
//    }()
//    
//    private let cellLeftImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    
////    private let cellRightButton: UIImageView = {
////        let imageView = UIImageView()
////        imageView.translatesAutoresizingMaskIntoConstraints = false
////        imageView.clipsToBounds = true
////        return imageView
////    }()
////
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        addSubview(cellLabel)
//        addSubview(cellLeftImageView)
////        addSubview(cellRightButton)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        cellLeftImageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview().inset(20)
//            make.width.height.equalTo(20)
//        }
//        cellLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalTo(cellLeftImageView.snp.trailing).offset(20)
//            make.trailing.equalTo(cellRightImageView.snp.leading).offset(20)
//        }
//        cellRightImageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.trailing.equalToSuperview().inset(20)
//            make.width.height.equalTo(20)
//        }
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        cellLabel.text = nil
//        cellLeftImageView.image = nil
//        cellRightImageView.image = nil
////        cellLabel.font = .systemFont(ofSize: 14, weight: .regular)
//    }
//
//    public func configure(text: String, isSelected: Bool?) {
//        cellLabel.text = text
////        guard let isSelected = isSelected else {
////            cellLeftImageView.snp.makeConstraints { make in
////                make.centerY.equalToSuperview()
////                make.leading.equalToSuperview().inset(20)
////                make.width.height.equalTo(20)
////            }
////            cellLeftImageView.image = UIImage(named: "expand")?.withTintColor(.label, renderingMode: .alwaysOriginal)
////            return
////        }
//        
//    
//        
//        if let isSelected = isSelected {
//            cellLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
//            cellLabel.snp.makeConstraints { make in
//                make.centerY.equalToSuperview()
//                make.leading.equalToSuperview().offset(20)
//                make.trailing.equalTo(cellRightImageView.snp.leading)
//            }
//            if isSelected {
//                cellLabel.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//                cellRightImageView.image = UIImage(named: "reduce")?.withTintColor(UIColor(rgb: 0x3232FF, alpha: 1.0), renderingMode: .alwaysOriginal)
//            } else {
//                cellRightImageView.image = UIImage(named: "expand")?.withTintColor(.label, renderingMode: .alwaysOriginal)
//            }
//        } else {
//            cellLeftImageView.snp.makeConstraints { make in
//                make.centerY.equalToSuperview()
//                make.leading.equalToSuperview().inset(18)
//                make.width.height.equalTo(18)
//            }
//            cellLabel.snp.makeConstraints { make in
//                make.centerY.equalToSuperview()
//                make.leading.equalTo(cellLeftImageView.snp.trailing).offset(8)
//                make.trailing.equalTo(cellRightImageView.snp.leading)
//            }
//            cellLeftImageView.image = UIImage(named: "languageLevel")?.withTintColor(.label, renderingMode: .alwaysOriginal)
//        }
//        
////        cellLabel.snp.makeConstraints { make in
////            make.centerY.equalToSuperview()
////            make.leading.equalToSuperview().offset(20)
////        }
////        cellLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
////        if isSelected {
////            cellLabel.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
////            cellRightImageView.image = UIImage(named: "reduce")?.withTintColor(UIColor(rgb: 0x3232FF, alpha: 1.0), renderingMode: .alwaysOriginal)
//////            if leftImage {
//////                cellLeftImageView.image = UIImage(named: "expand")?.withTintColor(.label, renderingMode: .alwaysOriginal)
//////            }
////        } else {
////            cellRightImageView.image = UIImage(named: "expand")?.withTintColor(.label, renderingMode: .alwaysOriginal)
////        }
//    }
//}
