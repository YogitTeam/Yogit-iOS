//
//  FirstSetUpTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/24.
//

import UIKit

class SetUpProfileTableViewCell: UITableViewCell {

    static let identifier = "setUpProfileTableViewCell"
    
//    // name of content
//    public lazy var noticeLabel: UILabel = {
//        let label = UILabel()
////        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 14.0)
//        label.textAlignment = .left
//        label.text = "Label"
//
//        // Label frame size to fit as text of label
////        label.sizeToFit()
//        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
//
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.black.cgColor
//        return label
//    }()
//
//    // footerView
//    public lazy var noticefooterView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(rgb: 0xF5F5F5)
//        view.addSubview(noticeLabel)
//        return view
//    }()

//    // requirementExpressionView & contentNameLabel horizontal stack view
//    public lazy var profileHeaderStackView: UIView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = 4
//        stackView.alignment = .leading
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.systemBlue.cgColor
//        [self.requirementView,
//         self.contentNameLabel].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()
    
    
    private lazy var profileTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
//        textField.layer.addBorder1(arr_edge: [.bottom], color: UIColor.systemBlue, width: 1.0)
        return textField
    }()
    
//    private lazy var lineImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "Vector")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
//    // input Line view
//    private lazy var inputLineView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 6
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor.systemGray.cgColor
//        return view
//    }()
//
//    // total vertical stack view
//    lazy var infoContentStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.spacing = 10
//        [self.pprofileHeaderStackView,
//         self.inputLineView].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(profileTextField)
//        contentView.addSubview(lineImageView)
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    // MARK: - Layout
   
//    override func layoutSublayers(of layer: CALayer) {
//        profileTextField.layer.addBorder(arr_edge: [.bottom], color: UIColor.systemRed, width: 1.0)
//    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
//            make.leftMargin.equalTo(20)
//            make.top.equalTo(contentView).inset(0)
            make.leading.trailing.equalTo(contentView).inset(20)
//            make.trailing.equalTo(contentView).inset(0)
        }
        
        
//        lineImageView.snp.makeConstraints { make in
//            make.bottom.equalTo(contentView.snp.bottom).offset(0)
//            make.left.equalTo(contentView).inset(20)
//            make.right.equalTo(contentView.snp.right).inset(0)
//        }
//        profileTextField.addBorder2(withColor: UIColor(rgb: 0xF5F5F5), width: 1)
//        noticeLabel.snp.makeConstraints { make in
//            make.top.bottom.equalTo(noticefooterView).inset(6)
//            make.leading.trailing.equalTo(noticefooterView).inset(20)
//        }
//        noticefooterView.snp.makeConstraints { make in
//            make.top.bottom.equalTo(noticefooterView).inset(6)
//            make.leading.trailing.equalTo(noticefooterView).inset(20)
//        }
//        requirementView.snp.makeConstraints { make in
//            make.width.height.equalTo(6)
//            make.top.equalTo(profileHeaderStackView).inset(0)
//        }
//        contentNameLabel.snp.makeConstraints { make in
//            make.top.bottom.right.equalTo(contentExpressionView).inset(0)
//            make.left.equalTo(requirementExpressionView.snp.right).offset(10)
//
//        }
        
//        contentExpressionStackView.snp.makeConstraints { make in
//            make.height.equalTo(27)
////            make.left.right.top.equalTo(infoContentStackView).inset(0)
//        }
        
//        inputLineView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.equalTo(contentView).inset(10)
////            make.leading.trailing.top.bottom.equalToSuperview().offset(0)
//            make.height.equalTo(100)
////            make.height.equalTo(44)
////            make.bottom.left.right.equalTo(infoContentStackView).inset(0)
//        }
        
//        infoContentStackView.snp.makeConstraints { make in
////            make.height.equalTo(66)
////            make.left.right.top.bottom.equalTo(contentView)
//
//            make.top.bottom.left.right.equalTo(contentView).inset(10)
////            make.height.equalTo(1
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileTextField.text = nil
    }

    public func configure(text: String) {
        profileTextField.placeholder = text
        // uiview 설정
        // 이벤트 전환
    }
}
