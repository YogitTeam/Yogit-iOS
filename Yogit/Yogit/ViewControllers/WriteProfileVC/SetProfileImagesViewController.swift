//
//  SetProfileImagesViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/13.
//

import UIKit
import SnapKit
import Alamofire
import BSImagePicker
import Photos
import Kingfisher

// 첫번째 사진(프로필) >> 프레임 정사각형 크기 편집(profileimage) - 리사이즈, images 에는 원본 업로드 >> 압축해서 압럳,
// 검색, 수정, 업로드 나눔
// 삭제시 인덱스 전송 >> patch
// 사진 추가시, 추가 시작 인덱스 저장 >> 추가 시작 인덱스부터 끝까지만 post

protocol ImagesProtocol: AnyObject {
    func imagesSend(profileImage: UIImage)
}

class SetProfileImagesViewController: UIViewController {
    // 이미지 빈값 넣어줌
    // 삭제 이미지 빈값 넣어줌
    weak var delegate: ImagesProtocol?
    
    private var userImagesData = UserImagesData()
//    private var newImagesIdx: Int = 0 // 기존 이미지 개수 저장, 삭제한 이미지 개수저장 >> 기존이미지(3개) - 삭제한 이미지(2개) >> post(patch) req: 1번 인덱스 부터 끝지점
    
    // upload할 이미지
//    private var uploadImages: [UIImage]? {
//        get {
//            return userImages.uploadImages
//        }
//        set(newValue) {
//            userImages.uploadImages = newValue
//            DispatchQueue.main.async {
//                self.imagesCollectionView.reloadData()
//                if self.userImages.uploadImages?.count ?? 0 > 0 {
//                    self.saveButton.isEnabled = true
//                    self.saveButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//                } else {
//                    self.saveButton.isEnabled = false
//                    self.saveButton.backgroundColor = .placeholderText
//                }
//            }
//            print("Profile images reloaded")
//        }
//    }

//    private var userImages: [UIImage] = [] {
//        didSet(oldVal){
//            DispatchQueue.main.async {
//                self.imagesCollectionView.reloadData()
//                if self.userImages.count > 0 {
//                    self.saveButton.isEnabled = true
//                    self.saveButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//                } else {
//                    self.saveButton.isEnabled = false
//                    self.saveButton.backgroundColor = .placeholderText
//                }
//            }
//            print("Profile images reloaded")
//        }
//    }
    
//    private var deleteUserImageIds: [Int64] = []
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        return button
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
//        label.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        label.text = "Please show people a picture of your face and  shows you well."
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
    
//    private lazy var saveButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Done", for: .normal)
//        button.tintColor = .white
//        button.layer.cornerRadius = 8
//        button.isEnabled = false
//        button.backgroundColor = .placeholderText
//        button.addTarget(self, action: #selector(self.saveButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noticeLabel)
        view.addSubview(imagesCollectionView)
//        view.addSubview(saveButton)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        getUserImages()
        configureViewComponent()
//        configureDeleteCount()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        imagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(noticeLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(15)
        }
//        saveButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalTo(view.snp.bottom).inset(30)
//            make.height.equalTo(50)
//        }
    }
    
    private func configureViewComponent() {
        self.navigationItem.title = "Profile Photos"
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = self.rightButton
    }
    
    private func configureDeleteCount() {
//        userImagesData.newImagesIdx = userImagesData.uploadImages.count // 패치한후 개수 카운팅
//        newImagesIdx = uploadImages?.count ?? 0 // userImages.count // 기존 이미지 개수
    }

    private func getUserImages() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        let getUserImages = GetUserImages(refreshToken: userItem.refresh_token, userId: userItem.userId)
        let urlConvertible = ProfileRouter.downLoadImages(parameter: getUserImages)
        if let parameters = urlConvertible.toDictionary {
            print("getUserImages parameters", parameters)
            AlamofireManager.shared.session.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(Data("\(value)".utf8), withName: key)
                }
            }, to: urlConvertible, method: urlConvertible.method).validate(statusCode: 200..<501).responseDecodable(of: APIResponse<FetchedUserImages>.self) { [self] response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        print("Success - Download User Images")
                        guard let data = value.data else {
                            print("data error")
                            return
                        }
                        let imageUrls = data.imageUrls
//                        var userImages = [UIImage]()
//                        let profileUrl = data.profileImageUrl
                        print(progressTime {
//                             0.0019310712814331055 (async let 5개) 0.0017060041427612305 0.0016030073165893555
//                             0.0015599727630615234 (withTaskGroup) 0.0017729997634887695 0.0015230178833007812
//                             0.0019550323486328125 (for문 작업) 0.0018080472946166992
                            Task(priority: .high) {
                                let userImages = await withTaskGroup(of: (UIImage, Int).self, returning: [UIImage].self, body: { taskGroup in
                                    for i in 0..<imageUrls.count {
                                        taskGroup.addTask {
                                            await (imageUrls[i].urlToImage()!, i)
                                        }
                                    }
                                    var childTaskResult = [UIImage?](repeating: nil, count: imageUrls.count)
                                    for await result in taskGroup {
                                        childTaskResult[result.1] = result.0
                                    }
                                    return childTaskResult as! [UIImage]
                               })

//                                async let image1 = imageUrls[0].urlToImage()!
//                                async let image2 = imageUrls[1].urlToImage()!
//                                async let image3 = imageUrls[2].urlToImage()!
//                                async let image4 = imageUrls[3].urlToImage()!
//                                async let image5 = imageUrls[4].urlToImage()!
//                                async let image6 = imageUrls[5].urlToImage()!
//                                userImages = await [image1, image2, image3, image4, image5, image6]

//                                for imageUrl in imageUrls {
//                                    let image = await imageUrl.urlToImage()!
//                                    userImages.append(image)
//                                }

                                self.userImagesData.imageIds = data.userImageIds
                                self.userImagesData.newImagesIdx = userImages.count
                                await MainActor.run {
                                    self.userImagesData.uploadImages = userImages
                                    self.imagesCollectionView.reloadData()
                                }
                            }
                            
                        })
                    }
                case let .failure(error):
                    print("SetProfileImagesVC - downLoad response result Not return", error)
                }
            }
        }
        
        
        
//        print("refershtoken \(userItem.refresh_token)")
//        let parameters = ["refreshToken": userItem.refresh_token]
//        AF.request(API.BASE_URL + "users/image/\(userItem.userId)",
//                   method: .get,
//                   parameters: parameters,
//                   encoding: JSONEncoding.default) // JSONEncoding.default
//            .validate(statusCode: 200..<500)
//            .responseData { response in
//            switch response.result {
//            case .success:
//                guard let data = response.value else { return }
//                debugPrint(response)
//                do{
//                    let decodedData = try JSONDecoder().decode(APIResponse<FetchedUserImages>.self, from: data)
//                    print(decodedData)
//                    DispatchQueue.global().async {
//                        guard let imageUrls = decodedData.data?.imageUrls else {
//                            print("imageUrls null")
//                            return
//                        }
//                        var getImages: [UIImage] = []
//                        print("get imageUrls \(imageUrls)")
//                        for imageUrl in imageUrls {
//                            imageUrl.urlToImage { (image) in
//                                guard let image = image else { return }
//                                getImages.append(image)
//                            }
////                            guard let url = URL(string: imageUrl) else { return }
////                            guard let data = try? Data(contentsOf: url) else { return }
////                            guard let image = UIImage(data: data) else { return }
////                            images.append(image)
////                            print("get image \(image)")
//                        }
//                        self.userImages = getImages
//                    }
//                }
//                catch{
//                    print(error.localizedDescription)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        guard let resizedProfileImage = userImagesData.uploadImages.first else {
            print("Not has all value")
            let alert = UIAlertController(title: "Can't save photos", message: "Please upload at least one photo", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            return
        }
        userImagesData.uploadProfileImage = resizedProfileImage
        
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        print("userImagesData", userImagesData)
        let patchUserImages = PatchUserImages(userId: userItem.userId, refreshToken: userItem.refresh_token, deleteUserImageIds: userImagesData.deleteUserImageIds, uploadImages: userImagesData.uploadImages, uploadProfileImage: resizedProfileImage)
        let urlConvertible = ProfileRouter.uploadImages(parameter: patchUserImages)
        if let parameters = urlConvertible.toDictionary {
            print("Upload parameters", parameters)
            AlamofireManager.shared.session.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let arrayValue = value as? [Any]  {
                        if let images = arrayValue as? [UIImage] {
                            let stIdx = self.userImagesData.newImagesIdx
                            for i in stIdx..<images.count {
                                multipartFormData.append(images[i].toFile(format: .jpeg(0.3))!, withName: key, fileName: key + ".jpeg", mimeType: key + "/jpeg")
                            }
                        } else {
                            for element in arrayValue {
                                multipartFormData.append(Data("\(element)".utf8), withName: key)
                            }
                        }
                    } else {
                        if let image = value as? UIImage {
                            multipartFormData.append(image.toFile(format: .jpeg(0.3))!, withName: key, fileName: key + ".jpeg", mimeType: key + "/jpeg")
                        } else {
                            multipartFormData.append(Data("\(value)".utf8), withName: key)
                        }
                    }
                }
            }, to: urlConvertible, method: urlConvertible.method).validate(statusCode: 200..<501).responseDecodable(of: APIResponse<FetchedUserImages>.self) { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        print("Success - Upload User Images")
                        guard let profileImage = self.userImagesData.uploadProfileImage else { return }
                        self.delegate?.imagesSend(profileImage: profileImage)
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                case let .failure(error):
                    print("SetProfileImagesVC - upload response result Not return", error)
                }
            }
        }
    }
    
//    @objc func saveButtonTapped(_ sender: UIButton) {
//        guard let profileImage = userImages.first?.resize(targetSize: CGSize(width: view.frame.size.width, height: view.frame.size.width)) else { return }
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        let parameters: [String: Int64] = [
//            "userId": userItem.userId
//        ]
//
//        // 이미지 get 요청 후 데이터 있으면 post, 없으면 put
//        AF.upload(multipartFormData: { multipartFormData in
//            for (key, value) in parameters {
//                multipartFormData.append(Data(String(value).utf8), withName: key)
//            }
//            multipartFormData.append(profileImage.toFile(format: .jpeg(0.3))!, withName: "profileImage", fileName: "profileImage.jpeg", mimeType: "profileImage/jpeg")
//            for image in self.userImages {
//                multipartFormData.append(image.toFile(format: .jpeg(0.3))!, withName: "images", fileName: "images.jpeg", mimeType: "images/jpeg")
//            }
//        }, to: API.BASE_URL + "users/image", method: .post)
//        .validate(statusCode: 200..<500)
//        .responseData { response in
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                self.delegate?.imagesSend(profileImage: self.userImages.first)
//                DispatchQueue.main.async {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SetProfileImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.label
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        if indexPath.row < userImagesData.uploadImages.count {
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in self.deleteImage(indexPath.row)}
            alert.addAction(delete)
            alert.addAction(cancel)
        } else {
            let library = UIAlertAction(title: "Upload photo", style: .default) { (action) in self.openLibrary() }
            let camera = UIAlertAction(title: "Take photo", style: .default) { (action) in self.openCamera() }
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SetProfileImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("ProfileImages indexpath update \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  MyImagesCollectionViewCell.identifier, for: indexPath) as? MyImagesCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row < userImagesData.downloadImages.count {
            cell.configureDownload(imageString: userImagesData.downloadImages[indexPath.row], sequence: indexPath.row + 1, kind: Kind.profile)
        } else if indexPath.row < userImagesData.uploadImages.count {
            cell.configureUpload(image: userImagesData.uploadImages[indexPath.row], imageId: nil, sequence: indexPath.row + 1, kind: Kind.profile)
        } else {
            cell.configure(image: UIImage(named: "imageNULL")?.withRenderingMode(.alwaysTemplate), imageId: nil, sequence: indexPath.row + 1, kind: Kind.profile)
        }
        return cell
        
        
//        if indexPath.row < userImagesData.uploadImages.count { // userImages.count
//            // imageId 필요없음 향후 삭제
//            cell.configure(image: userImagesData.uploadImages[indexPath.row], imageId: nil, sequence: indexPath.row + 1, kind: Kind.profile)
//        } else {
//            cell.configure(image: UIImage(named: "imageNULL")?.withRenderingMode(.alwaysTemplate), imageId: nil, sequence: indexPath.row + 1, kind: Kind.profile)
//        }
//        return cell
    }
}

extension SetProfileImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func convertAssetsToImages(asstes: [PHAsset]) -> [UIImage] {
        var images = [UIImage]()
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        for i in 0..<asstes.count {
            imageManager.requestImage(for: asstes[i],
                                      targetSize: CGSize(width: view.frame.size.width, height: view.frame.size.height),
                                      contentMode: .aspectFit,
                                      options: option) { (result, info) in
                if let image = result {
                    images.append(image)
                }
            }
        }
        return images
    }
    
    private func openLibrary() {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 6 - userImagesData.uploadImages.count
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
//        imagePicker.settings.selection.unselectOnReachingMax = true
        
        self.presentImagePicker(imagePicker, select: { (asset) in
            print("Selected: \(asset)")
        }, deselect: { (asset) in
            print("Deselected: \(asset)")
        }, cancel: { (assets) in
            print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
            print("Finished with selections: \(assets)")
            let appendImages = self.convertAssetsToImages(asstes: assets)
            self.userImagesData.uploadImages.append(contentsOf: appendImages)
            self.imagesCollectionView.reloadData()
        }, completion: {
            
        })
        
//        self.imagePicker.sourceType = .photoLibrary
//        DispatchQueue.main.async {
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
    }

    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    private func deleteImage(_ index: Int) {
        if userImagesData.imageIds.count - 1 >= index { // 0 1 2 / 3 < 2
            userImagesData.deleteUserImageIds = userImagesData.deleteUserImageIds ?? []
            let deletedImageId = userImagesData.imageIds.remove(at: index)
            userImagesData.deleteUserImageIds?.append(deletedImageId) // 전송 요청시 nil 값 제거 해야함
            userImagesData.newImagesIdx -= 1 // 기존 이미지에 삭제한 개수 카운트
        }
        userImagesData.uploadImages.remove(at: index)
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let resizeImage = image.resize(targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width))
            userImagesData.uploadImages.append(resizeImage)
//            if let image = img as? UIImage {
////                userImages.append(image.resize(targetSize: CGSize(width: view.frame.size.width, height: view.frame.height)))
//                let resizeImage = image.resize(targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width))
//                userImagesData.uploadImages.append(resizeImage)
////                userImagesData.imageIds.append(nil) // deleteImage nil 제거 해서 요청
////                let ratio = (view.frame.size.width /  image.size.width)
////                print("image sizse \(image.size)")
////                print("image file bytes \(image.toFile(format: .jpeg(1)))")
////                print("resized image size \(resizedImage.size)")
////                print("resized image file size \(resizedImage.toFile(format: .jpeg(1)))")
//            }
        }
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SetProfileImagesViewController {
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
                repeatingSubitem: pairItem,
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
