//
//  MyBoardView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/10.
//

import UIKit

class StepHeaderView: UIView {
    
    static let identifier = "StepHeaderView"
    
    var step: CGFloat = 0.0
    
//    lazy var contentView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        view.addSubview(stateDefaultView)
//        view.addSubview(titleLabel)
//        return view
//    }()

    lazy var stateDefaultView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .placeholderText
        view.layer.cornerRadius = 3
        view.addSubview(stateStepView)
        return view
    }()
    
    let stateStepView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        view.layer.cornerRadius = 3
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
//    init(frame: CGRect, step: CGFloat) {
//        super.init(frame: frame)
//        self.step = step
////        addSubview(contentView)
//        addSubview(stateDefaultView)
//        addSubview(titleLabel)
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stateDefaultView)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        stateDefaultView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.leading.trailing.equalToSuperview().inset(140)
        }
        stateStepView.snp.makeConstraints { make in
            make.leading.top.bottom.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(step * (1 / 3))
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stateDefaultView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
