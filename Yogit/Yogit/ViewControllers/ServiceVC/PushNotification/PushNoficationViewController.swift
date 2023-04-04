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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["CLIPBOARD".localized(), "ACTIVITY".localized()])
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
        configureView()
        configureNotification()
        configureTableView()
        refreshAlarmData(alarmType: AlarmManager.AlarmType.clipBoard.toKey())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        notiTableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.addSubview(segmentedControl)
        view.addSubview(notiTableView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .alarmRefresh, object: nil)
    }
    
    private func configureTableView() {
        notiTableView.dataSource = self
        notiTableView.delegate = self
    }
    
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        alarmData.removeAll()
        if sender.selectedSegmentIndex == 0 {
            refreshAlarmData(alarmType: AlarmManager.AlarmType.clipBoard.toKey())
        } else {
            refreshAlarmData(alarmType: AlarmManager.AlarmType.apply.toKey())
        }
     }
    
    // 푸쉬 알림 누른후 전달
    @objc func didRecieveNotification(_ notification: Notification) {
        guard let alarmType = notification.object as? String else { return }
        refreshAlarmData(alarmType: alarmType)
        if alarmType == AlarmManager.AlarmType.clipBoard.toKey() {
            segmentedControl.selectedSegmentIndex = 0
        } else {
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.notification.rawValue.localized())
//        let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
//        let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "Setting")
//        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        spacer.width = 15
//        self.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
    }
    
    private func refreshAlarmData(alarmType: String) {
        guard let alarms = AlarmManager.loadAlarms(type: alarmType) else { return }
        alarmData = alarms
    }
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        let args = alarmData[indexPath.row].args
        let bodyLocKey = alarmData[indexPath.row].body
        let localizedString = NSLocalizedString(bodyLocKey, comment: "")
      
        content.text = alarmData[indexPath.row].title.localized()
        content.secondaryText = localizedString.localized()

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
        DispatchQueue.main.async {
            let GDBVC = GatheringDetailBoardViewController()
            GDBVC.boardWithMode.boardId = self.alarmData[indexPath.row].id
            if self.segmentedControl.selectedSegmentIndex == 0 { GDBVC.isClipBoardAlarm = true }
            self.navigationController?.pushViewController(GDBVC, animated: true)
        }
    }
}
