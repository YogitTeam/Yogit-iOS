//
//  MyTextViewTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/15.
//

import UIKit

class MyTextView: UIView {
    static let identifier = "MyTextViewTableViewCell"
    

    let myTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemBackground
        textView.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.placeholderText.cgColor
        textView.layer.cornerRadius = 8
        textView.textColor = .placeholderText
        textView.textContainerInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return textView
    }()
    
    let textCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("MyTextViewTableViewCell init")
        addSubview(myTextView)
        addSubview(textCountLabel)
        configureViewComponent()
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        print("MyTextViewTableViewCell init")
//        contentView.addSubview(myTextView)
//        contentView.addSubview(textCountLabel)
//        configureViewComponent()
//    }
//
    private func configureViewComponent() {
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(myTextView.snp.bottom).offset(4)
        }

//        subLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(20)
//            make.bottom.equalToSuperview().inset(0)
//        }
//        rightButton.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.width.equalTo(44)
//            make.trailing.equalToSuperview().inset(20)
//        }
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        print("MyTextViewTableViewCell")
//        myTextView.text = nil
//    }

//    // cell content update
//    func configure(text: String?, section: Int) {
//
//    }
}
