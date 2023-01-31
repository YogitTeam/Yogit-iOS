//
//  MKResultsLocalSearchTableViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/14.
//

// google map version
import UIKit
import CoreLocation
import MapKit
import SnapKit

//struct Pl {
//    let address: String
//    let sub: String
//}
protocol MKResultsLocalSearchTableViewControllerDelegate: AnyObject {
    func didTapPlace(coordinate: CLLocationCoordinate2D, placeName: String, placeTitle: String, placeAdministrativeArea: String)
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
        label.text = "Sorry, the address was not found."
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(placeTableView)
        view.addSubview(guideLabel)
        view.backgroundColor = .systemBackground
        placeTableView.frame = view.bounds
        placeTableView.delegate = self
        placeTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("🥲사라짐 resultsview disapper")
        guideLabel.isHidden = true
        placeTableView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalToSuperview().inset(20)
        }
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
//        content.text = places[indexPath.row].name
//        content.secondaryText = places[indexPath.row].placemark.
        cell.contentConfiguration = content
//        print(places[indexPath.row])
        
//        content.text = places[indexPath.row].name
//        content.secondaryText = places[indexPath.row].placeName
//        cell.contentConfiguration = content
//        print(places[indexPath.row])
        return cell
        
        //        let name: String
        //        let identifier: String
        //        let businessStatus: String
        //        let formattedAddress: String
        //        let phoneNumber: String
        //        let rating: String
        //        let openingHours: String
        //        print("name \(places[indexPath.row].name)")
        //        print("id \(places[indexPath.row].identifier)")
        //        print("format add \(places[indexPath.row].formattedAddress)")
        //        print("phoneNumber\(places[indexPath.row].phoneNumber)")
        //        print("rating \(places[indexPath.row].rating)")
        //        print("openingHours \(places[indexPath.row].openingHours)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Didselect")
        tableView.isHidden = true
        
        // 위경도 전달
        let place = places[indexPath.row]
        
        guard let coordinate = place.placemark.location?.coordinate else { return }
        print("1")
        guard let placeName = place.placemark.name else { return }
        print("2")
        guard let placeTitle = place.placemark.title else { return }
        print("3")
        guard let placeAdministrativeArea = place.placemark.administrativeArea else { return }
        print("4")
//        guard let placeLocaclity = place.placemark.locality else { return }
        print("5")
        var resultLocal: String = placeAdministrativeArea
        
        if let placeLocaclity = place.placemark.locality {
            if resultLocal != placeLocaclity {
                resultLocal = resultLocal + " " + placeLocaclity
            }
        }
        // 필드 변경 (administerativeArea >> locality)
        // 로컬라이즈
        self.delegate?.didTapPlace(coordinate: coordinate, placeName: placeName, placeTitle: placeTitle, placeAdministrativeArea: resultLocal)
        self.dismiss(animated: true)
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
