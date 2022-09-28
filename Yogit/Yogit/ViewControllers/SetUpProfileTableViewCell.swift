//
//  FirstSetUpTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/24.
//

import UIKit

class SetUpProfileTableViewCell: UITableViewCell {

    static let identifier = "setUpProfileTableViewCell"
    
    // blue point
    lazy var requirementExpressionView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.sizeToFit()
        
        return view
    }()
    
    // name of content
    lazy var contentNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.text = "Label"
        
        // Label frame size to fit as text of label
        label.sizeToFit()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    // requirementExpressionView & contentNameLabel horizontal stack view
    lazy var contentExpressionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        [self.requirementExpressionView,
         self.contentNameLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    // input Line view
    lazy var inputLineView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    // total vertical stack view
    lazy var infoContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        [self.contentExpressionStackView,
         self.inputLineView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(infoContentStackView)
    }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not implement")
    }
     
    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        requirementExpressionView.snp.makeConstraints { make in
            make.width.height.equalTo(6)
//            make.top.equalTo(contentExpressionStackView.snp.top).inset(0)
        }
        
        contentExpressionStackView.snp.makeConstraints { make in
            make.height.equalTo(27)
        }
        
        inputLineView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        infoContentStackView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(20)
            make.top.bottom.equalTo(contentView).inset(10)
//            make.top.bottom.equalTo(infoTableView).inset(0)
//            make.bottom.equalTo(view.snp.bottom).inset(100)
        }
//        let w = infoContentStackView.bounds.size.width
        
//
//        collectionView.frame = contentView.bounds
//        collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentNameLabel.text = nil
    }
    
    public func configure(text: String) {
        contentNameLabel.text = text
    }
}
