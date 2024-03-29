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
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        textView.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.layer.cornerRadius = 8
//        textView.tintColor = .label
        textView.textColor = .placeholderText
        textView.textContainerInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return textView
    }()
    
    let textCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .placeholderText
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponent()
        configureLayout()
    }
    
    private func configureViewComponent() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(myTextView)
        addSubview(textCountLabel)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    private func configureLayout() {
        myTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(myTextView.snp.bottom).offset(4)
        }
    }
}
