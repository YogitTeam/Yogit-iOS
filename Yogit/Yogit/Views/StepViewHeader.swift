//
//  MyBoardView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/10.
//

import UIKit

class StepHeaderView: UIView {
    
    static let identifier = "StepHeaderView"
    
//    let step: CGFloat?
    var step: Float = 0.0
    
//    lazy var contentView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        view.addSubview(stateDefaultView)
//        view.addSubview(titleLabel)
//        return view
//    }()
    
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = ServiceColor.primaryColor
        view.trackTintColor = .placeholderText
        return view
    }()

//    lazy var stateDefaultView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .placeholderText
//        view.layer.cornerRadius = 3
//        view.addSubview(stateStepView)
//        return view
//    }()
//
//    let stateStepView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        view.layer.cornerRadius = 3
//        return view
//    }()

    let titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .s
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.semibold)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
//    
//    init(frame: CGRect, step: CGFloat) {
//        super.init(frame: frame)
//        self.step = step
////        addSubview(contentView)
//        addSubview(stateDefaultView)
//        addSubview(titleLabel)
//    }
//    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(stateDefaultView)
        addSubview(progressView)
        addSubview(titleLabel)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        progressView.snp.makeConstraints {
            $0.height.equalTo(5)
            $0.leading.trailing.equalToSuperview().inset(100)
        }
//        stateDefaultView.snp.makeConstraints { make in
////            make.top.equalToSuperview().inset(4)
//            make.height.equalTo(5)
//            make.leading.trailing.equalToSuperview().inset(100)
//        }
//        stateStepView.snp.makeConstraints { make in
//            make.leading.top.bottom.height.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(step * (1 / 3))
//        }
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(stateDefaultView.snp.bottom).offset(30)
//            make.leading.trailing.equalToSuperview().inset(10)
//        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        progressView.layoutIfNeeded()
        progressView.setProgress(step * (1 / 3), animated: true)
    }
}
