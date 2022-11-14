////
////  LocationSearchTableViewController.swift
////  Yogit
////
////  Created by Junseo Park on 2022/11/14.
////
//
//import UIKit
//import MapKit
//
//class LocationSearchTableViewController: UITableViewController {
//
//    var matchingItems: [MKMapItem] = []
//    let mapView = MKMapView()
//
////    var handleMapSearchDelegate: HandleMapSearch? = nil
//    
//    private var searchCompleter = MKLocalSearchCompleter()
//    private var searchResults = [MKLocalSearchCompletion]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setupSearchController()
//        // Do any additional setup after loading the view.
//    }
//    func setupSearchController() {
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.placeholder = "Search Language"
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchResultsUpdater = self
//        self.navigationItem.searchController = searchController
//        self.navigationItem.hidesSearchBarWhenScrolling = false
//    }
//}
//
//extension LocationSearchTableViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
////        guard let mapView = mapView,
////        guard let searchBarText = searchController.searchBar else { return }
////        let request = MKLocalSearch.Request()
////        request.naturalLanguageQuery = searchBarText
////        request.region = mapView.region
//        
//        guard let text = searchController.searchBar.text?.lowercased() else { return }
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = text
////        self.filteredSections = self.sections.filter { $0.title.lowercased().hasPrefix(text) }
//        
////        searchRequest.resultTypes = searchController.searchBar.text.filter { $0.lowercased().hasPrefix(text) }
//
//        // Set the region to an associated map view's region.
//        searchRequest.region = mapView.region
//
//        
//        let search = MKLocalSearch(request: searchRequest)
//        search.start { (response, error) in
//            guard let response = response else { return }
//            
//            for item in response.mapItems {
//                if let name = item.name,
//                    let location = item.placemark.location {
//                    print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
//                }
//            }
//        }
//
//        
////        search.start { response, _ in
////            guard let response = response else {
////                return
////            }
////            self.matchingItems = response.mapItems
////            self.tableView.reloadData()
////        }
//    }
//}
//
////extension LocationSearchTableViewController {
////    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return matchingItems.count
////    }
////
////    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = UITableViewCell()
////        var content = cell.defaultContentConfiguration()
////        let selectedItem = matchingItems[indexPath.row].placemark
////        content.text = selectedItem.name
////        let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
////        content.secondaryText = address
////        cell.contentConfiguration = content
////        return cell
////    }
////}
//
////extension LocationSearchTableViewController {
////    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let selectedItem = matchingItems[indexPath.row].placemark
////        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
////        DispatchQueue.main.async {
////            self.dismiss(animated: true)
////        }
////    }
//////    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//////        let selectedItem = matchingItems[indexPath.row].placemark
//////        handleMapSearchDelegate?.dropPinZoomIn(selectedItem)
//////        dismissViewControllerAnimated(true, completion: nil)
//////    }
////}
