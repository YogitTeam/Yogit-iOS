//
//  FirstSetUpTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/24.
//

import UIKit

class SetProfileTableViewCell: UITableViewCell {

    static let identifier = "SetProfileTableViewCell"
    
    weak var borderLayer: CALayer?  // cell bottom border
    
    lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.red.cgColor
        [commonTextField,
         subLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    // commonTextField
    let commonTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
        textField.leftView = nil
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.black.cgColor
        return textField
    }()
    

    let subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.isHidden = true
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderColor = UIColor.systemBlue.cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.isEnabled = false
        button.setImage(UIImage(named: "push")?.withRenderingMode(.alwaysTemplate), for: .disabled)
        button.setImage(UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .placeholderText
//        button.layer.borderColor = UIColor.systemYellow.cgColor
//        button.layer.borderWidth = 1
        return button
    }()
    


    // 국기 Textfield leftView에 넣는다.
//    private let leftImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = nil
////        imageView.contentMode =
//        imageView.isHidden = true
////        imageView.sizeToFit()
//        return imageView
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("SetUpProfileTableViewCell init")
        contentView.addSubview(textStackView)
//        contentView.addSubview(commonTextField)
        contentView.addSubview(rightButton)
//        contentView.addSubview(subLabel)
        configureViewComponent()
//        contentView.addSubview(leftImageView)
    }
    
    private func configureViewComponent() {
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        textStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(4)
        }
        
        commonTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview() // .inset(20)
            make.trailing.equalToSuperview() // .inset(20)
        }
        rightButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(44)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("PrepareForReuse SetUpProfileTableViewCell")
        removeBorder() // remove bottom border
        prepareForReuseTextField()
        prepareForReuseButton()
        prepareForReuseLabel()
    }
    
    func prepareForReuseTextField() {
        self.commonTextField.text = nil
        self.commonTextField.isEnabled = false
        self.commonTextField.placeholder = nil
        self.commonTextField.inputView = nil
        self.commonTextField.inputAccessoryView = nil
        self.commonTextField.leftView = nil
        self.commonTextField.tintColor = .clear
    }
    
    func prepareForReuseButton() {
        self.rightButton.isEnabled = false
        self.rightButton.isHidden = true
    }
    
    func prepareForReuseLabel() {
        self.subLabel.text = nil
        self.subLabel.isHidden = true
    }
    
    // cell content update
    func configure(text: String?, image: UIImage?, section: Int) {
        commonTextField.text = text
        switch section {
        case ProfileSectionData.name.rawValue:
            commonTextField.isEnabled = true
            commonTextField.tintColor = UIColor(rgb: 0x3246FF, alpha: 1.0)
        case ProfileSectionData.age.rawValue:
            commonTextField.isEnabled = true
        case ProfileSectionData.languages.rawValue:
            rightButton.isHidden = false
            subLabel.isHidden = false
            subLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
            if text != nil { rightButton.isEnabled = true }
        case ProfileSectionData.gender.rawValue: commonTextField.isEnabled = true
        case ProfileSectionData.nationality.rawValue:
            rightButton.isHidden = false
            commonTextField.addLeftImage(image: image)
        default: fatalError("Out of section index SetUpProfileTableVeiwCell")
        }
    }
    
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
//        border.frame = CGRect(x: bounds.minX,
//                              y: bounds.maxX - width,
//                              width: bounds.width,
//                              height: width)
        border.frame = CGRect(x: 20, y: self.frame.size.height - width, width: self.frame.size.width - 40, height:width)
        self.layer.addSublayer(border)
        self.borderLayer = border
    }

    func removeBorder() {
        self.borderLayer?.removeFromSuperlayer()
    }
}