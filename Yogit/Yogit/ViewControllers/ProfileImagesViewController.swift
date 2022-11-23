//
//  ProfileImagesViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/13.
//

import UIKit
import SnapKit
import Alamofire

protocol ImagesProtocol: AnyObject {
    func imagesSend(profileImage: UIImage?)
}

class ProfileImagesViewController: UIViewController {

    private let imagePicker = UIImagePickerController()
    
    weak var delegate: ImagesProtocol?

    private var images: [UIImage] = [] {
        didSet(oldVal){
            DispatchQueue.main.async {
                self.imagesCollectionView.reloadData()
                if self.images.count > 0 {
                    self.saveButton.isEnabled = true
                    self.saveButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
                } else {
                    self.saveButton.isEnabled = false
                    self.saveButton.backgroundColor = .placeholderText
                }
            }
            print("Profile images reloaded")
        }
    }
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight.medium)
//        label.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        label.text = "Please show people a picture of your face and a picture that shows you well."
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    private let imagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: createCollectionViewLayout()
          )
        collectionView.register(MyImagesCollectionViewCell.self, forCellWithReuseIdentifier: MyImagesCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.backgroundColor = .placeholderText
        button.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileImages(userId: 1)
        //        { (userProfileImages) in
        //            guard let userProfileImages = userProfileImages else { print("userProfileImages")
        //                return
        //            }
        //            print(userProfileImages)
        //            print("imageUrls \(imageUrls)")
        //            guard let imageUrls = userProfileImages.imageUrls else { print("imageUrls")
        //                return
        //            }
        //            if userProfileImages?.imageUrls == nil { userProfileImages?.imageUrls = []}
        //            for imageUrl in userProfileImages?.imageUrls {
//                        guard let url = URL(string: imageUrl) else {
//                            print("imageUrl url")
//                            return
//                        }
//                        guard let data = try? Data(contentsOf: url) else {
//                            print("imageUrl data")
//                            return
//                        }
//                        guard let image = UIImage(data: data) else {
//                            print("imageUrl image")
//                            return
//                        }
//                        self.images.append(image)
        //            }
        //            self.imagesCollectionView.reloadData()
//    }
        view.addSubview(noticeLabel)
        view.addSubview(imagesCollectionView)
        view.addSubview(saveButton)
        configureViewComponent()
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagePicker.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("profileimagecollectionview viewDidLayoutSubviews")
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
    
    
    func getProfileImages(userId: Int64) {
        AF.request(API.BASE_URL + "users/image/\(userId)",
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<500)
            .responseData { response in
            switch response.result {
            case .success:
                guard let data = response.value else { return }
                debugPrint(response)
                do{
                    let decodedData = try JSONDecoder().decode(APIResponse<UserProfileImages>.self, from: data)
                    guard let imageUrls = decodedData.data?.imageUrls else { return }
                    DispatchQueue.global().async {
                        for imageUrl in imageUrls {
                            guard let url = URL(string: imageUrl) else { return }
                            guard let data = try? Data(contentsOf: url) else { return }
                            guard let image = UIImage(data: data) else { return }
                            self.images.append(image)
                        }
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
//        let url = "https://yogit.world/users/image"

        guard let profileImage = images.first else { return }
    
        let parameters: [String: Int64] = [
            "userId": 1
        ]
        
        for image in self.images {
            print(image)
        }
        // 이미지 get 요청 후 데이터 있으면 post, 없으면 put
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                multipartFormData.append(Data(String(value).utf8), withName: key)
            }
            multipartFormData.append(profileImage.toFile(format: .jpeg(0.5))!, withName: "profileImage", fileName: "profileImage.jpeg", mimeType: "profileImage/jpeg")
            for image in self.images {
                multipartFormData.append(image.toFile(format: .jpeg(0.5))!, withName: "images", fileName: "images.jpeg", mimeType: "images/jpeg")
            }
        }, to: API.BASE_URL + "users/image", method: .post)
        .validate(statusCode: 200..<500)
        .responseData { response in
            switch response.result {
            case .success:
                debugPrint(response)
                self.delegate?.imagesSend(profileImage: self.images.first)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case let .failure(error):
                print(error)
            }
        }
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

extension ProfileImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.label
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
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ProfileImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyImagesCollectionViewCell.identifier, for: indexPath)
        print("ProfileImages indexpath update \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  MyImagesCollectionViewCell.identifier, for: indexPath) as? MyImagesCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row < images.count {
            cell.configure(image: images[indexPath.row], sequence: indexPath.row + 1, kind: Kind.profile)
        } else {
            cell.configure(image: UIImage(named: "imageNULL")?.withRenderingMode(.alwaysTemplate), sequence: indexPath.row + 1, kind: Kind.profile)
        }
        return cell
    }
}

extension ProfileImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary() {
        imagePicker.sourceType = .photoLibrary
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }

    func openCamera() {
        imagePicker.sourceType = .camera
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
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
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension ProfileImagesViewController {
    fileprivate static func createCollectionViewLayout() -> UICollectionViewLayout  {
        print("generate LayoutSubviews")
        let layout = UICollectionViewCompositionalLayout {
            // 만들게 되면 튜플 (키: 값, 키: 값) 의 묶음으로 들어옴 반환 하는 것은 NSCollectionLayoutSection 콜렉션 레이아웃 섹션을 반환해야함
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
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
            let pairGroup = NSCollectionLayoutGroup.vertical(
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
                subitems: [mainItem, pairGroup])
            
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
            let containerGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(1.0)),
                subitems: [
                    mainWithPairGroup,
                    tripletGroup,
                ]
            )
            
            let section = NSCollectionLayoutSection(group: containerGroup) // 0,1 section
            return section
        }
        return layout
    }
}
