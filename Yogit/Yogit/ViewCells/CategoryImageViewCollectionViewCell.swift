//
//  CategoryImageViewCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/06.
//

import UIKit

class CategoryImageViewCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryImageViewCollectionViewCell"
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        [backView, titleLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.backgroundColor = .systemGray6 //.systemBackground
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray6.cgColor
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.sizeToFit()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    private func configureView() {
        contentView.addSubview(contentStackView)
    }
    
    private func configureLayout() {
        contentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
        backView.snp.makeConstraints {
            $0.width.height.equalTo(imageView.snp.width).inset(-8)
        }
        backView.layoutIfNeeded()
        backView.layer.cornerRadius = backView.frame.size.width/2
    }

    func configure(at: Int) {
        guard let categoryString = CategoryId(rawValue: at + 1)?.toString() else { return }
        imageView.image = UIImage(named: categoryString)?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = categoryString.localized()
    }
}

