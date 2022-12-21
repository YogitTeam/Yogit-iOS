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
    var alarmData: [Alarm] = []
    
    var getFlag = false
    
    // closure parttern
    // () parameter
    private let notiTableView: UITableView = {
        let tableView = UITableView()
        // register new cell
        // self: reference the type object
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(notiTableView)
        notiTableView.dataSource = self
        notiTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .alarmRefresh, object: nil)
        getAlarmDataFlag(flag: self.getFlag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.navigationItem.title = "Nationality"
        notiTableView.frame = view.bounds
    }
    
    // 푸쉬 알림 누른후 전달
    @objc func didRecieveNotification(_ notification: Notification) {
        guard let alarmType = notification.object as? String else { return }
        refreshAlarmData(alarmType: alarmType)
    }
    
    func getAlarmDataFlag(flag: Bool) {
        if !flag { refreshAlarmData(alarmType: AlarmManager.AlarmType.apply.toKey()) }
    }
    
    func refreshAlarmData(alarmType: String) {
        guard let alarms = AlarmManager.loadAlarms(type: alarmType) else { return }
        alarmData = alarms
        getFlag = true
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
        content.image = UIImage(systemName: "bell")

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
        print("Tap alarmData", alarmData[indexPath.row].id)
    }
}
