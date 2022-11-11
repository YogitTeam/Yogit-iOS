//
//  FirstSetUpTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/24.
//

import UIKit

class CommonTextFieldTableViewCell: UITableViewCell {

    static let identifier = "setUpProfileTableViewCell"
    
//    private let placeholderData = ["userName", "International age", "Add conversational language", "Select gender", "Select nationaltiy"]
    
    weak var borderLayer: CALayer?  // cell bottom border
    
//    let placeholderData = ["Name", "International age", "Add conversational language", "Select gender", "Select nationaltiy"]
//
//    var placeholder: String? {
//        didSet {
//             guard let item = placeholder else { return }
//             profileTextField.placeholder = item
//        }
//    }
    
    let profileTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
        return textField
    }()
    
    let levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.isHidden = true
        label.sizeToFit()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
//        label.layer.borderColor = UIColor.systemRed.cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    let languageDeleteButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.isEnabled = false
        button.setImage(UIImage(named: "push"), for: .disabled)
        button.setImage(UIImage(named: "delete"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("SetUpProfileTableViewCell init")
        contentView.addSubview(profileTextField)
        contentView.addSubview(languageDeleteButton)
        contentView.addSubview(levelLabel)
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(levelLabel.snp.top)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(0)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
//            make.height.equalTo(10)
//            make.top.equalTo(profileTextField.snp.bottom).offset(30)
//            make.bottomMargin.equalTo(-10)
            make.bottom.equalToSuperview().inset(0)
//            make.height.equalTo(14)
        }
        
        languageDeleteButton.snp.makeConstraints { make in
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
        prepareForReuseLabel()
    }
    
    func prepareForReuseTextField() {
        self.profileTextField.text = nil
        self.profileTextField.isEnabled = false
        self.profileTextField.placeholder = nil
        self.profileTextField.inputView = nil
        self.profileTextField.inputAccessoryView = nil
    }
    
    func prepareForReuseButton() {
        self.languageDeleteButton.isEnabled = false
        self.languageDeleteButton.isHidden = true
    }
    
    func prepareForReuseLabel() {
        self.levelLabel.text = nil
        self.levelLabel.isHidden = true
    }
    
    // cell content update
    func configure(text: String?, section: Int, kind: String) {
        switch kind {
        case Kind.profile.rawValue:
            profileTextField.text = text
            switch section {
            case ProfileSectionData.name.rawValue: profileTextField.isEnabled = true
            case ProfileSectionData.age.rawValue: profileTextField.isEnabled = true
            case ProfileSectionData.languages.rawValue:
                languageDeleteButton.isHidden = false
                levelLabel.isHidden = false
                if text != nil { languageDeleteButton.isEnabled = true }
            case ProfileSectionData.gender.rawValue: profileTextField.isEnabled = true
            case ProfileSectionData.nationality.rawValue: languageDeleteButton.isHidden = false
            default: fatalError("Out of section index SetUpProfileTableVeiwCell")
            }
        default: fatalError("Out of common cell kind")
        }
    }
    
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
//        border.frame = CGRect(x: bounds.minX,
//                              y: bounds.maxX - width,
//                              width: bounds.width,
//                              height: width)
        border.frame = CGRect(x: 20, y: self.frame.size.height - width, width: self.frame.size.width - 20, height:width)
        self.layer.addSublayer(border)
        self.borderLayer = border
    }

    func removeBorder() {
        self.borderLayer?.removeFromSuperlayer()
    }
}

