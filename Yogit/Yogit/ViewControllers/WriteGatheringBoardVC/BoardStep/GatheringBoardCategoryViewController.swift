//
//  GatheringBoardCategoryViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/10.
//

import UIKit
import Alamofire

//enum Mode {
//    case post
//    case edit
//}

class GatheringBoardCategoryViewController: UIViewController {
    
    var boardWithMode = BoardWithMode() {
        didSet {
            print("BoardWithMode", boardWithMode)
        }
    }
    
    var categoryId: Int? {
        didSet {
            DispatchQueue.main.async { [self] in
                categoryTableView.reloadData()
                if categoryId != nil {
                    nextButton.isEnabled = true
                    nextButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
                } else {
                    nextButton.isEnabled = false
                    nextButton.backgroundColor = .placeholderText
                }
            }
        }
    }
    
    private let step: Float = 0.0
    
    private lazy var stepHeaderView: StepHeaderView = {
        let view = StepHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70), step: step)
        view.titleLabel.text = "GATHERING_CATEGORY".localized()
        return view
    }()
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(GatheringBoardCategoryTableViewCell.self, forCellReuseIdentifier: GatheringBoardCategoryTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.isHidden = false
        button.backgroundColor = .placeholderText
        button.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureView()
        configureLayout()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stepHeaderView.fillProgress(step: step + 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.size.width/2
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(stepHeaderView)
        view.addSubview(categoryTableView)
        view.addSubview(nextButton)
    }
    
    private func configureLayout() {
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.right.equalToSuperview()
            make.height.equalTo(70)
        }
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(stepHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(120)
        }
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.width.height.equalTo(60)
        }
    }
    
    private func configureTableView() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    private func configureNav() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    @objc func categoryContentViewTapped(sender: UITapGestureRecognizer) {
        // 3 state toggle 값
        self.categoryId == sender.view?.tag ? (self.categoryId = nil) : (self.categoryId = sender.view?.tag)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        guard let apiCategoryId = categoryId else { return }
        boardWithMode.categoryId = apiCategoryId + 1
        DispatchQueue.main.async {
            let GBSDVC = GatheringBoardOptionViewController()
            GBSDVC.boardWithMode = self.boardWithMode
            self.navigationController?.pushViewController(GBSDVC, animated: true)
        }
    }
    
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GatheringBoardCategoryTableViewCell.identifier, for: indexPath) as? GatheringBoardCategoryTableViewCell else { return UITableViewCell() }
        if let categoryString = CategoryId(rawValue: indexPath.row + 1)?.toString(),
           let categoryDescription = CategoryId(rawValue: indexPath.row + 1)?.getDescribe() {
            cell.categoryImageView.image = UIImage(named: categoryString)?.withRenderingMode(.alwaysTemplate)
            cell.categoryTitleLabel.text = categoryString.localized()
            cell.categoryDescriptionLabel.text = categoryDescription.localized()
        }
        cell.categoryContentView.tag = indexPath.row
        cell.categoryContentView.removeGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.categoryContentViewTapped(sender:))))
        cell.categoryContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.categoryContentViewTapped(sender:))))

        if categoryId == nil {
            cell.isTapped = nil
        } else if categoryId == indexPath.row {
            cell.isTapped = true
        } else {
            cell.isTapped = false
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension GatheringBoardCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension GatheringBoardCategoryViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryId.allCases.count
    }
}
