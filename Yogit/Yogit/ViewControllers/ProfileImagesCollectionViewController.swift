//
//  ProfileImagesViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/13.
//

import UIKit
import SnapKit

protocol ImagesProtocol {
    func imagesSend(profileImage: UIImage?)
}

class ProfileImagesCollectionViewController: UIViewController, UICollectionViewDelegate {

    private let picker = UIImagePickerController()
    
    var delegate: ImagesProtocol?

    private var images: [UIImage] = [] {
        didSet(oldVal){
            imagesCollectionView.reloadData()
            print("reload")
        }
    }
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        label.text = "Show your global friends pictures of your face and pictures that show you well"
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()

    private let imagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: ProfileImagesCollectionViewController.generateLayout()
          )
        collectionView.register(ProfileImagesCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImagesCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.saveButtonTapped(_:))))
        return button
    }()
    
    override func viewDidLoad() {
        view.addSubview(noticeLabel)
        view.addSubview(imagesCollectionView)
        view.addSubview(saveButton)
        configureViewComponent()
        picker.delegate = self
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        imagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(noticeLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(15)
        }
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(30)
            make.height.equalTo(50)
        }
    }
    
    private func configureViewComponent() {
        self.navigationItem.title = "Profile Photos"
        view.backgroundColor = .systemBackground
    }
    
    static func generateLayout() -> UICollectionViewLayout {
        
        // First type: Main with pair
        let mainItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(2/3),
            heightDimension: .fractionalHeight(1.0)))

        // 1
        mainItem.contentInsets = NSDirectionalEdgeInsets(
          top: 5,
          leading: 5,
          bottom: 5,
          trailing: 5)

        // 2, 3
        let pairItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)))

        pairItem.contentInsets = NSDirectionalEdgeInsets(
          top: 5,
          leading: 5,
          bottom: 5,
          trailing: 5)

        // 2, 3 group
        let trailingGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)),
          subitem: pairItem,
          count: 2)

        // 1, 2, 3 group
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3)),
          subitems: [mainItem, trailingGroup])
        
        // Second type. Triplet
        let tripletItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)))

        // 4, 5, 6
        tripletItem.contentInsets = NSDirectionalEdgeInsets(
          top: 5,
          leading: 5,
          bottom: 5,
          trailing: 5)
        
        // 4, 5, 6 group
        let tripletGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/3)),
          subitems: [tripletItem, tripletItem, tripletItem])
        
        // total group
        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)),
          subitems: [
            mainWithPairGroup,
            tripletGroup,
          ]
        )

        let section = NSCollectionLayoutSection(group: nestedGroup) // 0,1 section
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .black
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        
        if indexPath.row < images.count {
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in self.deleteImage(indexPath.row)}
            alert.addAction(delete)
            alert.addAction(cancel)
        } else {
            let library = UIAlertAction(title: "Upload photo", style: .default) { (action) in self.openLibrary()}
            let camera = UIAlertAction(title: "Take photo", style: .default) { (action) in self.openCamera()}
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped(_ sender: UITapGestureRecognizer) {
        delegate?.imagesSend(profileImage: self.images.first)
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileImagesCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImagesCollectionViewCell.identifier, for: indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  ProfileImagesCollectionViewCell.identifier, for: indexPath) as? ProfileImagesCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row < images.count {
            cell.configure(image: images[indexPath.row], sequence: "\(indexPath.row + 1)")
        } else {
            cell.configure(image: UIImage(named: "imageNULL"), sequence: "\(indexPath.row + 1)")
        }
        return cell
    }
}

extension ProfileImagesCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }

    func openCamera() {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }

    func deleteImage(_ index: Int) {
        images.remove(at: index)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // action 각기 다르게
        if let img = info[UIImagePickerController.InfoKey.originalImage] {
            print("image pick")
            if let image = img as? UIImage {
                images.append(image)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

