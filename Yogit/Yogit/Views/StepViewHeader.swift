//
//  MyBoardView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/10.
//

import UIKit

class StepHeaderView: UIView {
    
    static let identifier = "StepHeaderView"
    
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = ServiceColor.primaryColor
        view.trackTintColor = .placeholderText
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .s
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.semibold)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    init(frame: CGRect, step: Float) {
        super.init(frame: frame)
        addSubview(progressView)
        addSubview(titleLabel)
        initProgress(step: step)
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
////        addSubview(stateDefaultView)
//        progressView.progress = step
//        addSubview(progressView)
//        addSubview(titleLabel)
//    }
    
    override func layoutSubviews() {
        progressView.snp.makeConstraints {
            $0.height.equalTo(5)
            $0.leading.trailing.equalToSuperview().inset(100)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initProgress(step: Float) {
        progressView.progress = step * (1 / 3)
    }
    
    public func fillProgress(step: Float) {
        DispatchQueue.main.async(qos: .userInitiated) { [weak self] in
            self?.progressView.setProgress(step * (1 / 3), animated: true)
        }
    }
}
