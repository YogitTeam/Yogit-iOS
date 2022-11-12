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
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellLabel)
        addSubview(cellImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        cellImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(20)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellLabel.text = nil
        cellImageView.image = nil
//        cellLabel.font = .systemFont(ofSize: 14, weight: .regular)
    }

    public func configure(text: String, isSelected: Bool?) {
        cellLabel.text = text
        guard let isSelected = isSelected else {
            return
        }
        cellLabel.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        if isSelected {
            cellLabel.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
            cellImageView.image = UIImage(named: "reduce")
        } else {
            cellImageView.image = UIImage(named: "expand")
        }
    }
}
