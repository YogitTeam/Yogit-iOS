//
//  PushNoficationViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/12.
//

import UIKit

class PushNoficationViewController: UIViewController {
    // MARK: - TableView
    // 이미지도 같이
    var alarmData: [Alarm] = [] {
        didSet {
            alarmData.reverse()
            notiTableView.reloadData()
        }
    }
    
//    var getFlag = false
    
    // closure parttern
    // () parameter
    private let notiTableView: UITableView = {
        let tableView = UITableView()
        // register new cell
        // self: reference the type object
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Clip Board Notification", "Activity Notification"])
        control.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
//        control.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        control.selectedSegmentTintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        control.layer.cornerRadius = 30
        control.layer.masksToBounds = true
//        control.clipsToBounds = true
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(segmentedControl)
        view.addSubview(notiTableView)
        notiTableView.dataSource = self
        notiTableView.delegate = self
        configureViewComponent()
        refreshAlarmData(alarmType: AlarmManager.AlarmType.clipBoard.toKey())
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .alarmRefresh, object: nil)
//        getAlarmDataFlag(flag: self.getFlag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
    }

//    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.navigationItem.title = "Nationality"
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        notiTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
//            make.leading.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
//        notiTableView.frame = view.bounds
    }
    
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        print("selectedSegmentIndex \(sender.selectedSegmentIndex)")
        alarmData.removeAll()
        if sender.selectedSegmentIndex == 0 {
            // 조회 get 요청
            print("ClipBoard Alarm - segement 0")
            
            refreshAlarmData(alarmType: AlarmManager.AlarmType.clipBoard.toKey())
        } else {
            // 생성 get 요청
            print("ApplyBoard Alarm - segment 1")
            refreshAlarmData(alarmType: AlarmManager.AlarmType.apply.toKey())
        }

//        self.searchMyBoardCollectionView.isHidden = !self.searchMyBoardCollectionView.isHidden
//        self.createMyBoardCollectionView.isHidden = !self.createMyBoardCollectionView.isHidden
     }
    
    // 푸쉬 알림 누른후 전달
    @objc func didRecieveNotification(_ notification: Notification) {
        guard let alarmType = notification.object as? String else { return }
//        refreshAlarmData(alarmType: alarmType)
        if alarmType == AlarmManager.AlarmType.clipBoard.toKey() {
            segmentedControl.selectedSegmentIndex = 0
        } else {
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
//    func getAlarmDataFlag(flag: Bool) {
//        if !flag { refreshAlarmData(alarmType: AlarmManager.AlarmType.apply.toKey()) }
//    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
    }
    
    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.notification.rawValue)
//        let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
//        let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "Setting")
//        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        spacer.width = 15
//        self.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
    }
    
    func refreshAlarmData(alarmType: String) {
        guard let alarms = AlarmManager.loadAlarms(type: alarmType) else { return }
        alarmData = alarms
//        getFlag = true
    }
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure content
        // Similar View - ViewModel arhitecture
        
        var content = cell.defaultContentConfiguration()
        content.text = alarmData[indexPath.row].title
        content.secondaryText = alarmData[indexPath.row].body
//        content.text = nationalityData[indexPath.row]
        content.image = UIImage(named: "ServiceIcon")
        // Customize appearence
        cell.contentConfiguration = content
        
    
        return cell
    }
}

extension PushNoficationViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmData.count
    }
}

extension PushNoficationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // clipboard, 게시판 분리
        // 클립보드에서 왔을경우 두번 push
        print("Tap alarmData", alarmData[indexPath.row].id)
        DispatchQueue.main.async {
            let GDBVC = GatheringDetailBoardViewController()
            GDBVC.boardId = self.alarmData[indexPath.row].id
            if self.segmentedControl.selectedSegmentIndex == 0 { GDBVC.isClipBoardAlarm = true }
            self.navigationController?.pushViewController(GDBVC, animated: true)
        }
    }
}
