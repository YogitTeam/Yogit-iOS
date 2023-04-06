//
//  MyHeaderView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/02.
//

import UIKit

class MyHeaderView: UIView {

    static let identifier = "MyHeaderView"
    
    let requirementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ServiceColor.primaryColor
        view.layer.cornerRadius = 3
        return view
    }()
    
    let contentNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(requirementView)
        addSubview(contentNameLabel)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        requirementView.snp.makeConstraints { make in
            make.width.height.equalTo(6)
            make.top.equalToSuperview().inset(0)
            make.leading.equalToSuperview()
        }

        contentNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(requirementView.snp.trailing).offset(4)
            make.top.equalToSuperview().inset(0)
            make.height.equalTo(22)
        }
    }

}
