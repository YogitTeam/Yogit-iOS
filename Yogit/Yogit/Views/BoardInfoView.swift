//
//  BoardInfoView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/04.
//

import UIKit
import SnapKit
import SkeletonView

class BoardInfoView: UIView {
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
//        imageView.isSkeletonable = true
        return imageView
    }()
    
    let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
//        imageView.isSkeletonable = true
        return imageView
    }()
    
    
    // name of content
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        
        // Label frame size to fit as text of label
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    let subInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    public lazy var labelVerticalStackView: UIView = {
       let stackView = UIStackView()
       stackView.translatesAutoresizingMaskIntoConstraints = false
       stackView.axis = .vertical
       stackView.spacing = 2
       stackView.alignment = .leading
//        stackView.isSkeletonable = true
       [self.infoLabel,
        self.subInfoLabel].forEach { stackView.addArrangedSubview($0) }
       return stackView
   }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftImageView)
        view.addSubview(labelVerticalStackView)
        view.addSubview(rightImageView)
        view.isSkeletonable = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        isSkeletonable = true
        addSubview(contentView)
//        addSubview(leftImageView)
//        addSubview(labelVerticalStackView)
//        addSubview(rightImageView)
    }
    
    private func configureViewComponent() {
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
        }
        leftImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.width.equalTo(22)
            make.centerY.equalToSuperview()
        }
        labelVerticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(4)
            make.trailing.equalTo(rightImageView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
//        infoLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(rightImageView.snp.leading)
//        }
//
//        subInfoLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(rightImageView.snp.leading)
//        }
        
        rightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(0)
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
        }
    }

}

//extension BoardInfoView {
//    func addToViewBottomBorderWithColor(color: UIColor, width: CGFloat) {
//        self.layoutIfNeeded()
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
//        self.layer.addSublayer(border)
//    }
//}
