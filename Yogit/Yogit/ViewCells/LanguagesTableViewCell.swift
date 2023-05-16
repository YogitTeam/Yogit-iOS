//
//  LanguagesTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/30.
//

import UIKit
import SnapKit

class LanguagesTableViewCell: UITableViewCell {

    static let identifier = "LanguagesTableViewCell"
    
    // MARK: - Property

    private let cellLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
//        label.textColor = .black
        return label
    }()
        
    lazy var cellLeftButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let imageNormal = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
        button.setImage(imageNormal, for: .normal)
        button.tintColor = .placeholderText
        button.isHidden = false
        button.isEnabled = true
        button.addTarget(self, action: #selector(self.cellLeftButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func cellLeftButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    private let cellRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellLabel.text = nil
        cellRightImageView.image = nil
    }
    
    private func configureView() {
        addSubview(cellLabel)
        addSubview(cellLeftButton)
        addSubview(cellRightImageView)
    }

    private func configureLayout() {
        cellRightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
    }
    
    public func configure(text: String, isSelected: Bool?) {
        cellLabel.text = text
        if let isSelected = isSelected {
            cellLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
            cellLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalTo(cellRightImageView.snp.leading)
            }
            if isSelected {
                cellLabel.textColor = ServiceColor.primaryColor
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
                let imageMinus = UIImage(systemName: "minus", withConfiguration: imageConfig)
                cellRightImageView.image = imageMinus?.withTintColor(ServiceColor.primaryColor, renderingMode: .alwaysOriginal)
            } else {
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .thin)
                let imagePlus = UIImage(systemName: "plus", withConfiguration: imageConfig)
                cellRightImageView.image = imagePlus?.withTintColor(.label, renderingMode: .alwaysOriginal)
            }
        } else {
            cellLeftButton.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(18)
                make.width.height.equalTo(18)
            }
            cellLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(cellLeftButton.snp.trailing).offset(8)
                make.trailing.equalTo(cellRightImageView.snp.leading)
            }
        }
    }
}
