//
//  BoardCategoryTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/01.
//

import UIKit

class BoardOptionsTableViewCell: UITableViewCell {

    static let identifier = "BoardCategoryTableViewCelll"
    
    
    weak var borderLayer: CALayer?  // cell bottom border
    
    // commonTextField
    let commonTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
        textField.leftView = nil
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
        return textField
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.isEnabled = false
        button.setImage(UIImage(named: "push")?.withRenderingMode(.alwaysTemplate), for: .disabled)
        button.setImage(UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .placeholderText
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("SetUpProfileTableViewCell init")
        contentView.addSubview(commonTextField)
        contentView.addSubview(rightButton)
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
        
        commonTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
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
        self.removeBorder() // remove bottom border
        prepareForReuseTextField()
        prepareForReuseButton()
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
    
    
    // cell content update
    func configure(text: String?, image: UIImage?, section: Int, kind: Kind) {
        commonTextField.text = text
        commonTextField.addLeftImage(image: image)
        switch section {
        case BoardSelectDetailSectionData.numberOfMember.rawValue: commonTextField.isEnabled = true
        case BoardSelectDetailSectionData.dateTime.rawValue: commonTextField.isEnabled = true
        case BoardSelectDetailSectionData.location.rawValue: commonTextField.addrightimage(image: UIImage(named: "push"))
        case BoardSelectDetailSectionData.locationDetail.rawValue: commonTextField.isEnabled = true
        default: fatalError("Out of section index cell of GatheringBoardSelectDetailViewController")
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

