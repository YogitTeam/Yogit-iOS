//
//  PushNoficationViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/12.
//

import UIKit

class PushNotificationViewController: UIViewController {
  
    private var notiList: [PushNotification] = []
    
    private let notiTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PushNotificationTableViewCell.self, forCellReuseIdentifier: PushNotificationTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["CLIPBOARD".localized(), "ACTIVITY".localized()])
        control.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = ServiceColor.primaryColor
        control.layer.cornerRadius = 30
        control.layer.masksToBounds = true
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
        ]
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
        ]
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureTableView()
        configureNotification()
        initGetNotiData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
    }
    
    private func configureView() {
        view.addSubview(segmentedControl)
        view.addSubview(notiTableView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        notiTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureTableView() {
        notiTableView.dataSource = self
        notiTableView.delegate = self
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .notiRefresh, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .notiRefresh, object: nil)
    }
    
    deinit {
        removeNotification()
    }
    
    private func initNavigationBar() {
        DispatchQueue.main.async { [weak self] in
            self?.tabBarController?.makeNaviTopLabel(title: TabBarKind.notification.rawValue.localized())
            self?.tabBarController?.navigationItem.rightBarButtonItems?.removeAll()
        }
//        let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
//        let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "Setting")
//        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        spacer.width = 15
//        self.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
    }
    
    private func initGetNotiData() {
        DispatchQueue.main.async(qos: .userInteractive) { [weak self] in
            self?.refreshNotiData(notiType: PushNotificationManager.NotiType.clipBoard.toKey())
        }
    }
    
    // User touch event
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            refreshNotiData(notiType: PushNotificationManager.NotiType.clipBoard.toKey())
        } else {
            refreshNotiData(notiType: PushNotificationManager.NotiType.apply.toKey())
        }
     }
    
    // 푸쉬 알림 누른후 전달
    @objc func didRecieveNotification(_ notification: Notification) {
        guard let notiType = notification.object as? String else { return }
        refreshNotiData(notiType: notiType)
    }
    
    private func refreshNotiData(notiType: String) {
        notiList.removeAll()
        if notiType == PushNotificationManager.NotiType.clipBoard.toKey() {
            segmentedControl.selectedSegmentIndex = 0
            
            notiList = PushNotificationManager.loadNotificationsByType(type: notiType)
        } else {
            segmentedControl.selectedSegmentIndex = 1
            
            notiList = PushNotificationManager.loadNotificationsByType(type: notiType)
        }
        notiTableView.reloadData()
    }
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PushNotificationTableViewCell.identifier, for: indexPath) as? PushNotificationTableViewCell else { return UITableViewCell() }
        cell.configure(data: notiList[indexPath.row])
        return cell
    }
}

extension PushNotificationViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiList.count//alarmData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension PushNotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        // clipboard, 게시판 분리
        // 클립보드에서 왔을경우 두번 push
        DispatchQueue.main.async {
            cell?.contentView.backgroundColor = .systemBackground
            let GDBVC = GatheringDetailBoardViewController()
            GDBVC.boardWithMode.boardId = self.notiList[indexPath.row].boardId
            if self.segmentedControl.selectedSegmentIndex == 0 { GDBVC.isClipBoardAlarm = true }
            self.navigationController?.pushViewController(GDBVC, animated: true)
        }
        
        PushNotificationManager.updateIsOpened(id: notiList[indexPath.row].id) { (noti) in
            self.notiList[indexPath.row] = noti
        }
    }
}
