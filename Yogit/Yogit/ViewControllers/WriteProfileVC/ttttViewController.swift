//
//  ttttViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/03/13.
//

import UIKit
import MapKit
import CoreLocation

class tttViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up location manager and map view
        
        locationManager.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // Add map view to the view hierarchy and set its constraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        // Request location authorization
////        requestLocationAuthorization()
//    }
    
//    func requestLocationAuthorization() {
//        DispatchQueue.global(qos: .userInitiated).async {
//               self.locationManager.requestWhenInUseAuthorization()
//           }
//
//    }
    
    // Location manager delegate method called when authorization status changes
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        if manager.authorizationStatus == .authorizedWhenInUse {
//            // Center the map on the user's current location
//            if let location = manager.location {
//                let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//                mapView.setRegion(region, animated: true)
//            }
//        }
//    }
//
    // Map view delegate method called when the user's location is updated
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // Center the map on the user's current location
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
    }
    
    // Map view delegate method called when the user's location cannot be determined
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        // Handle the error here
    }
}
