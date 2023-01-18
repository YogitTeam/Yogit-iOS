//
//  MyMyClipBoardTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/22.
//

import UIKit

class MyClipBoardTableViewCell: UITableViewCell {
    static let identifier = "MyClipBoardTableViewCell"
    
    private lazy var chatView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray // my: systemGray, you: blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.addSubview(chatLabel)
        view.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0).withAlphaComponent(0.85)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(chatView)
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
        chatLabel.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview().inset(10)
        }
        chatView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview().inset(10)
            $0.leading.greaterThanOrEqualToSuperview().inset(50).priority(.high)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chatLabel.text = nil
    }

    func configure(coment: String, updateDate: String) {
        self.chatLabel.text = coment
    }
}

