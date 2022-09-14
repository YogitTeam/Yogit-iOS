//
//  UserDetailTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/12.
//

import UIKit

//class UserDetailTableViewCell: UITableViewCell {
//
//    static let identifier = "CollectionTableViewCell"
//    
//    weak var delegate: CollectionTableViewCellDelegate?
//
//    private var viewModels: [TileCollectionCellViewModel] = []
//    
//    private let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    
//        collectionView.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewCell.identifier)
//        collectionView.backgroundColor = .systemBackground
//        
//        return collectionView
//    }()
//    
//    // MARK: - Init (for custom table view cell)
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .systemBackground
//        contentView.addSubview(collectionView)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//    
//    required init?(coder: NSCoder) {
//         fatalError()
//    }
//     
//    // MARK: - Layout
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        collectionView.frame = contentView.bounds
//        collectionView.showsHorizontalScrollIndicator = false
//    }
//    
//    // MARK: - Collection view
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileCollectionViewCell.identifier, for: indexPath) as? TileCollectionViewCell else    {
//            fatalError()
//        }
//        cell.configure(with: viewModels[indexPath.row])
//        return cell
//    }
//    
//    func configure(with viewModel: CollectionTableViewCellViewModel) {
//        self.viewModels = viewModel.viewModels
//        collectionView.reloadData()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size: CGFloat = contentView.frame.size.width/2.5
//        return CGSize(width: size, height: size)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        let viewModel = viewModels[indexPath.row]
//        delegate?.collectionTableViewTapItem(with: viewModel)
//    }
//
////    override func awakeFromNib() {
////        super.awakeFromNib()
////        // Initialization code
////    }
////
////    override func setSelected(_ selected: Bool, animated: Bool) {
////        super.setSelected(selected, animated: animated)
////
////        // Configure the view for the selected state
////    }
//
//}
