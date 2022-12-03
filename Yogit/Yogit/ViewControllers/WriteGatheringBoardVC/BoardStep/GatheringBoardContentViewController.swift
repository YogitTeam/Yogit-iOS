//
//  GatheringTextDetailViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/12.
//

import UIKit
import Alamofire
import SnapKit

// 글자수 n 글자 이상 m 이하
class GatheringBoardContentViewController: UIViewController, UITableViewDelegate {
    var createBoardReq = CreateBoardReq() {
        didSet {
            print("BoardTextDetail \(createBoardReq)")
        }
    }
    private var images: [UIImage] = [] {
        didSet {
            imagesCollectionView.reloadData()
            createBoardReq.images = self.images
            print("reload")
        }
    }
    private let imagePicker = UIImagePickerController()
    private let rtvh = RequirementTableViewHeader()
    let stepHeaderView = StepHeaderView()
    let step = 3.0
    let minChar = [10, 50, 50]
    let maxChar = [30, 200, 200]
    let placeholderData = ["Ex) Hangout", "Ex) Hangout", "Ex) Hangout"]
    var textViewCount = [0, 0, 0]
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        return button
    }()
    
    private let textDetailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.isScrollEnabled = false
        tableView.sectionHeaderTopPadding = 10
        tableView.register(MyTextViewTableViewCell.self, forCellReuseIdentifier: MyTextViewTableViewCell.identifier)
        tableView.register(RequirementTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RequirementTableViewHeader.identifier)
        return tableView
    }()
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(MyImagesCollectionViewCell.self, forCellWithReuseIdentifier: MyImagesCollectionViewCell.identifier)
//        collectionView.layer.borderColor = UIColor.systemGray.cgColor
//        collectionView.layer.borderWidth = 1
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var contentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        [self.rtvh, self.imagesCollectionView, self.textDetailTableView].forEach { scrollView.addSubview($0) }
        return scrollView
    }()
    
//    private lazy var uploadButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Upload", for: .normal)
//        button.tintColor = .white
//        button.layer.cornerRadius = 8
//        button.isEnabled = false
//        button.backgroundColor = .placeholderText
//        button.addTarget(self, action: #selector(self.uploadButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stepHeaderView)
        view.addSubview(contentScrollView)
//        view.addSubview(uploadButton)
        textDetailTableView.delegate = self
        textDetailTableView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagePicker.delegate = self
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
//            make.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(stepHeaderView.snp.bottom).offset(10)
//            make.width.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
//            make.width.equalToSuperview()
        }
        
        rtvh.snp.makeConstraints { make in
//            make.top.equalTo(stepHeaderView.snp.bottom).offset(20)
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(22)
        }
        
        imagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(rtvh.snp.bottom)
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(rt)
            make.width.equalToSuperview()
            make.height.equalTo(100)
        }
//        textDetailTableView.frame = view.bounds
        
        textDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(imagesCollectionView.snp.bottom).offset(10)
//            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(650)
            make.bottom.equalToSuperview()
        }
//        uploadButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalToSuperview().inset(30)
//            make.height.equalTo(50)
//        }
    }
    
    private func configureViewComponent() {
//        self.navigationItem.title = "Profile"
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.stepHeaderView.step = step
        stepHeaderView.titleLabel.text = "Content"
        view.backgroundColor = .systemBackground
        rtvh.contentNameLabel.text = "Photos"
    }
    
    func textVaildation() -> Bool {
        for i in 0..<3 {
            if self.createBoardReq.images?.count ?? 0 > 0 && textViewCount[i] >= minChar[i] && textViewCount[i] <= maxChar[i] {
                
            } else {
                return false
            }
        }
        return true
    }

    @objc func buttonPressed(_ sender: UIButton) {
        
        if textVaildation() {
            // 통신완료 후 pop root까지
            guard let userItem = try? KeychainManager.getUserItem() else { return }
            createBoardReq.hostId = userItem.userId  // 아이디 받으면 아이디로
            let parameters: [String: Any] = [
                "cityName": "SEOUL",
                "hostId": createBoardReq.hostId!,
                "title": createBoardReq.title!,
                "address": createBoardReq.address!,
                "addressDetail": createBoardReq.addressDetail ?? "",
                "longitute": createBoardReq.longitute!,
                "latitude": createBoardReq.latitude!,
                "date": createBoardReq.date!,
                "notice": "",
                "introduction": createBoardReq.introduction!,
                "kindOfPerson": createBoardReq.kindOfPerson!,
                "totalMember": createBoardReq.totalMember!,
                "categoryId": createBoardReq.categoryId!,
                "refreshToken": userItem.refresh_token
            ]
            
            for image in self.createBoardReq.images! {
                print(image.toFile(format: .jpeg(1))!)
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(Data("\(value)".utf8), withName: key)
                }
                for image in self.createBoardReq.images! {
                    multipartFormData.append(image.toFile(format: .jpeg(0.5))!, withName: "images", fileName: "images.jpeg", mimeType: "images/jpeg")
                }
                print(multipartFormData)
            }, to: API.BASE_URL + "boards", method: .post)
            .validate(statusCode: 200..<500)
            .responseData { response in
                switch response.result {
                case .success:
                    debugPrint(response)
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                        // notification 메인게시글 페이지로 쏴줌 >>  get 요청해서 업데이트
                    }

                case let .failure(error):
                    print(error)
                }
            }
        } else {
            print("Not has all value")
            let alert = UIAlertController(title: "Please enter the required information correctly", message: "Please enter the required information according to the conditionㄴ", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        }

    }
}

extension GatheringBoardContentViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        default: fatalError("GatheringBoardSelectDetailVC out of section")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 54
        case 1: return 200
        case 2: return 200
        default: fatalError("GatheringBoardContentViewController out of section index")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTextViewTableViewCell.identifier, for: indexPath) as? MyTextViewTableViewCell else { return UITableViewCell() }
        cell.myTextView.tag = indexPath.section
        cell.myTextView.delegate = self
        cell.myTextView.text = placeholderData[indexPath.section]
        switch indexPath.section {
        case 0: createBoardReq.title = cell.myTextView.text
        case 1: createBoardReq.introduction = cell.myTextView.text
        case 2: createBoardReq.kindOfPerson = cell.myTextView.text
        default: fatalError("Textdetail out of index error")
        }
        cell.textCountLabel.text = "0 / \(maxChar[indexPath.section])"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RequirementTableViewHeader.identifier) as? RequirementTableViewHeader else { return UITableViewHeaderFooterView() }
        
        // userName, age, lanages, gender, nationality
        switch section {
        case 0: headerView.configure(text: "Title")
        case 1: headerView.configure(text: "Gathering introduction")
        case 2: headerView.configure(text: "Please apply this kind of person")
        default: fatalError("Out of header RequirementTableViewHeader section index")
        }
        return headerView
    }
}

extension GatheringBoardContentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Tapped gatherging board collectionview image")
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

extension GatheringBoardContentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
        return images.count < 5 ? (images.count + 1) : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyImagesCollectionViewCell.identifier, for: indexPath)
        print("ProfileImages indexpath update \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  MyImagesCollectionViewCell.identifier, for: indexPath) as? MyImagesCollectionViewCell else { return UICollectionViewCell() }
        DispatchQueue.global().async {
            if indexPath.row < self.images.count {
                DispatchQueue.main.async {
                    cell.configure(image: self.images[indexPath.row], sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
                }
            } else {
                DispatchQueue.main.async {
                    cell.configure(image: UIImage(named: "imageNULL")?.withRenderingMode(.alwaysTemplate), sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
                }
            }
        }
        return cell
    }
}

extension GatheringBoardContentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
//        let size: CGFloat = imagesCollectionView.frame.size.width/2
////        CGSize(width: size, height: size)
//
//        CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
        
        return CGSize(width: collectionView.frame.height - 20, height: collectionView.frame.height - 20)
    }
}

extension GatheringBoardContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary() {
        imagePicker.sourceType = .photoLibrary
        if images.count == 0 {
            self.imagePicker.allowsEditing = true
        } else {
            self.imagePicker.allowsEditing = false
        }
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }

    func openCamera() {
        imagePicker.sourceType = .camera
        if images.count == 0 {
            self.imagePicker.allowsEditing = true
        } else {
            self.imagePicker.allowsEditing = false
        }
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }

    func deleteImage(_ index: Int) {
        images.remove(at: index)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // action 각기 다르게
//        if let img = info[UIImagePickerController.InfoKey.originalImage] {
//            print("image pick")
//            if let image = img as? UIImage {
//                images.append(image)
//            }
//        }
        
        var newImage: UIImage? = nil // update 할 이미지

        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = img // 수정된 이미지
            print(newImage)
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = img // 원본 이미지
            print(newImage)
        }
        guard let image = newImage else { return }
        let resizeImage = image.resize(targetSize: CGSize(width: view.frame.size.width, height: view.frame.size.width))
//        print(resizeImage)
//        print(image.toFile(format: .jpeg(0.5))!)
        images.append(resizeImage)
        
        // tabbar notification get 요청
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension GatheringBoardContentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 0 && text == "\n" { textView.resignFirstResponder() }
        
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= maxChar[textView.tag]
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderData[textView.tag] {
            textView.text = nil
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text =  placeholderData[textView.tag]
            textView.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // textfield count
        // 개수 표시
        let indexPath = IndexPath(row: 0, section: textView.tag)
        guard let cell = textDetailTableView.cellForRow(at: indexPath) as?  MyTextViewTableViewCell else { return }
        if textView.text.count == 0 {
            cell.textCountLabel.textColor = .placeholderText
        }
        else if textView.text.count >= minChar[textView.tag] {
            cell.textCountLabel.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        } else {
            cell.textCountLabel.textColor = .red
        }
        cell.textCountLabel.text = "\(textView.text.count) / \(maxChar[textView.tag])"
        textViewCount[textView.tag] = textView.text.count
        switch textView.tag {
        case 0: createBoardReq.title = textView.text
        case 1: createBoardReq.introduction = textView.text
        case 2: createBoardReq.kindOfPerson = textView.text
        default: fatalError("Gathering board textview error")
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

