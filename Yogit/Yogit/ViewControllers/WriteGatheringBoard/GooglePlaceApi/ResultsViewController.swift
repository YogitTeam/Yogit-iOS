//
//  ResultsViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/14.
//

// google map version
import UIKit
import CoreLocation

protocol ResultViewControllerDelegate: AnyObject {
    func didTapPlace(with coordinates: CLLocationCoordinate2D)
}

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: ResultViewControllerDelegate?
    private var places: [Place] = []
    private let placeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(placeTableView)
        view.backgroundColor = .systemBackground
        placeTableView.frame = view.bounds
        placeTableView.delegate = self
        placeTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    public func update(with places: [Place]) {
        self.places = places
        placeTableView.reloadData()
        placeTableView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = places[indexPath.row].name
        content.secondaryText = places[indexPath.row].placeName
        cell.contentConfiguration = content
        print(places[indexPath.row])
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
        let place = places[indexPath.row]
        GooglePlacesManager.shaerd.resolveLocation(for: place) { result in
            switch result {
            case .success(let coordinate):
                self.delegate?.didTapPlace(with: coordinate)
//                DispatchQueue.main.async {
//                    self.delegate?.didTapPlace(with: coordinate)
////                    self.dismiss(animated: true)
//                }
            case .failure(let error):
                print(error)
            }
            
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
