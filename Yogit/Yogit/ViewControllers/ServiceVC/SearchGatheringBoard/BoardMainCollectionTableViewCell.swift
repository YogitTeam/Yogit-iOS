//
//  BoardMainCollectionTableViewCell.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import UIKit

// MARK: - Collection view inside table view cell

//struct BoardMainCollectionTableViewCellViewModel {
//    let viewModels: [ThumbnailCollectionCellViewModel]
//}

struct BoardMainCollectionTableViewCellViewModel {
//    let viewModels: [ThumbnailCollectionCellViewModel]
    let boards: [Board]
}

//protocol BoardMainCollectionTableViewCellDelegate: AnyObject {
//    func collectionTableViewTapIteom(with viewModel: ThumbnailCollectionCellViewModel)
//}

protocol BoardMainCollectionTableViewCellDelegate: AnyObject {
    func collectionTableViewTapItem(with board: Board)
}

class BoardMainCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static let identifier = "BoardMainCollectionTableViewCell"
    
    weak var delegate: BoardMainCollectionTableViewCellDelegate?

//    private var viewModels: [ThumbnailCollectionCellViewModel] = []
    
    private var boards: [Board] = []
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.text = "Dfdfdfdf"
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.layer.borderColor = UIColor.systemYellow.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumbnailCollectionViewCell.identifier)
        
//        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        collectionView.backgroundColor = .systemBackground
        
        return collectionView
    }()
    
    // MARK: - Init (for custom table view cell)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(headerLabel)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
         fatalError()
    }
     
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(4)
        }
//        collectionView.frame = contentView.bounds
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModels.count
        return boards.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.identifier, for: indexPath) as? ThumbnailCollectionViewCell else    {
//            fatalError()
//        }
//        cell.configure(with: viewModels[indexPath.row])
//        let categoryId = CategoryId(rawValue: indexPath.row + 1)
//        headerLabel.text = categoryId?.toString()
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.identifier, for: indexPath) as? ThumbnailCollectionViewCell else    {
            fatalError()
        }
        cell.configure(with: boards[indexPath.row])
        return cell
    }
    
//    func configure(with viewModel: BoardMainCollectionTableViewCellViewModel) {
//        self.viewModels = viewModel.viewModels
//        collectionView.reloadData()
//    }
    
    func configure(with boardsInCategory: [Board]) {
        self.boards = boardsInCategory
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = contentView.frame.size.width/1.5
        let height: CGFloat = contentView.frame.size.width/1.5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
//        let viewModel = viewModels[indexPath.row]
        let board = boards[indexPath.row]
        delegate?.collectionTableViewTapItem(with: board)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView {
//                return header
//            }
//        }
//        return UICollectionReusableView()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height/10)
//    }
}
