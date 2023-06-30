//
//  MKResultsLocalSearchTableViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/14.
//

// google map version
import UIKit
import MapKit
import SnapKit

//struct Pl {
//    let address: String
//    let sub: String
//}
protocol MKResultsLocalSearchTableViewControllerDelegate: AnyObject {
    func didTapPlace(coordinate: CLLocationCoordinate2D, placeName: String, placeTitle: String)
}

class MKResultsLocalSearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: MKResultsLocalSearchTableViewControllerDelegate?
    private var places: [MKMapItem] = []
    private let placeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "SEARCH_FAIL_NOTICE_DESCRIPTION".localized()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guideLabel.isHidden = true
        placeTableView.isHidden = true
    }
    
    private func configureView() {
        view.addSubview(placeTableView)
        view.addSubview(guideLabel)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    private func configureTableView() {
        placeTableView.frame = view.bounds
        placeTableView.delegate = self
        placeTableView.dataSource = self
    }
    
    func updateMK(with places: [MKMapItem]) {
        self.places = places
        placeTableView.reloadData()
        guideLabel.isHidden = true
        placeTableView.isHidden = false
    }
    
    func notFound() {
        guideLabel.isHidden = false
        placeTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        print(places[indexPath.row])
        content.text = places[indexPath.row].placemark.name
        content.secondaryText = places[indexPath.row].placemark.title
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isHidden = true
        let place = places[indexPath.row]
        guard let coordinate = place.placemark.location?.coordinate else { return }
        guard let placeName = place.placemark.name else { return }
        guard let placeTitle = place.placemark.title else { return } // 주소, 우편번호
        self.delegate?.didTapPlace(coordinate: coordinate, placeName: placeName, placeTitle: placeTitle)
        DispatchQueue.main.async {
            self.dismiss(animated: true)
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
