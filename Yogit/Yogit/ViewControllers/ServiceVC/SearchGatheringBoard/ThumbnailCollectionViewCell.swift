//
//  ThumbnailCollectionViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import UIKit

import UIKit

struct ThumbnailCollectionCellViewModel {
    let name: String
    let backgroundColor: UIColor
}

class ThumbnailCollectionViewCell: UICollectionViewCell {
    static let identifier = "ThumbnailCollectionViewCell"
    
    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    // MARK: - Init (custom collection view cell)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        contentView.layer.shadowOpacity = 0.5
//
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with viewModels: ThumbnailCollectionCellViewModel) {
        contentView.backgroundColor = viewModels.backgroundColor
        label.text = viewModels.name
    }
    
}
