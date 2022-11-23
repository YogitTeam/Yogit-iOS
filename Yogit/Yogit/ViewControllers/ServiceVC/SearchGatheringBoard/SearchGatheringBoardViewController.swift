//
//  SecondSetUpUserInfoViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/23.
//

import UIKit
import SnapKit
import Alamofire

class SearchGatheringBoardController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private lazy var boardButton: UIButton = {
        let button = UIButton()
//        button.setTitle("", for: .normal)
//        button.imageView?.image = UIImage(named: "imageNULL")
        button.setImage(UIImage(named: "imageNULL"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 24
        button.isEnabled = true
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.addTarget(self, action: #selector(self.boardButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        // register new cell
        // self: reference the type object
        tableView.register(BoardMainCollectionTableViewCell.self, forCellReuseIdentifier: BoardMainCollectionTableViewCell.identifier)
        
        return tableView
    }()
    
    private let viewModels: [BoardMainCollectionTableViewCellViewModel] = [
        BoardMainCollectionTableViewCellViewModel(
            viewModels: [
                ThumbnailCollectionCellViewModel(name: "Red", backgroundColor: .systemRed),
                ThumbnailCollectionCellViewModel(name: "Orange", backgroundColor: .systemOrange),
                ThumbnailCollectionCellViewModel(name: "Yellow", backgroundColor: .systemYellow),
                ThumbnailCollectionCellViewModel(name: "Green", backgroundColor: .systemGreen),
                ThumbnailCollectionCellViewModel(name: "Blue", backgroundColor: .systemBlue),
                ThumbnailCollectionCellViewModel(name: "Purple", backgroundColor: .systemPurple),
            ]
        ),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(boardButton)
        tableView.delegate = self
        tableView.dataSource = self
        configureViewComponent()
        getBoardThumbnail()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        boardButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
        
    }
   
    func getBoardThumbnail() {
        let getAllBoardsReq = GetAllBoardsReq(cursor: 1, userId: 1)
        AF.request(API.BASE_URL + "boards/get",
                   method: .post,
                   parameters: getAllBoardsReq,
                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
        .validate(statusCode: 200..<500)
        .response { response in // reponseData
            switch response.result {
            case .success:
                if let data = response.data {
                    do{
                        debugPrint(response)
                    } catch {
                        print(error)
                    }
                }
            case .failure(let error):
                debugPrint(response)
                print(error)
            }
        }
    }
    
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: BoardMainCollectionTableViewCell.identifier, for: indexPath) as? BoardMainCollectionTableViewCell else {
            fatalError()
        }
        cell.delegate = self
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/2
     }
    
    @objc func boardButtonTapped(_ sender: UIButton) {
        
//        let objCreateEventVC = CreateEventVC()
//        objCreateEventVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(objCreateEventVC, animated: false)
        DispatchQueue.main.async(execute: {
            let GBCVC = GatheringBoardCategoryViewController()
            GBCVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(GBCVC, animated: true)
        })
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

extension SearchGatheringBoardController: BoardMainCollectionTableViewCellDelegate {
    func collectionTableViewTapIteom(with viewModel: ThumbnailCollectionCellViewModel) {
        let alert = UIAlertController(title: viewModel.name, message: "Success", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
