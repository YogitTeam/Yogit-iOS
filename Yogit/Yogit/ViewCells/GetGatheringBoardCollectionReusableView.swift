//
//  GetGatheringBoardCollectionReusableView.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/06.
//

import UIKit

class GetGatheringBoardCollectionReusableView: UICollectionReusableView {
    static let identifier = "GetGatheringBoardCollectionReusableView"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
