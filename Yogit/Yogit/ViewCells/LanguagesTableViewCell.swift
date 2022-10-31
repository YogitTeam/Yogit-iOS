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
    
    let tableLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(tableLabel)
    }
//
//    override required init?(coder: NSCoder) {
//        super.init(coder: NSError())
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
        }
        print("layout")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
//    func configureUI() {
////        addSubview(tableLabel)
//        
//        tableLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.leading.equalTo(20)
//        }
//        
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tableLabel.textColor = .black
    }

    public func configure(color: UIColor) {
        tableLabel.textColor = color

//        addSubview(tableLabel)

//        tableLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.leading.equalTo(20)
//        }
    }

}
