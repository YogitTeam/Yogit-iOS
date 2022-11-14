//
//  GooglePlacesManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/14.
//

import Foundation
import GooglePlaces
import CoreLocation

struct Place {
    let name: String
    let identifier: String
    let placeName: String
//    let businessStatus: String
//    let formattedAddress: String
//    let addressComponents: String
//    let photos: String
}
final class GooglePlacesManager {
    static let shaerd = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()
    private init() { }
    enum PlaceError: Error {
        case failedToFind
        case failedToGetCoordinate
    }
    
    public func findPlaces(
        query: String,
        completion: @escaping (Result<[Place], Error>) -> Void
    ) {
//        let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//        let fields: GMSPlaceField = GMSPlaceField(rawValue:
//                                                    UInt(GMSPlaceField.placeID.rawValue))
//        autocompleteController.placeFields = fields
//        // Specify a filter.
//        let filter = GMSAutocompleteFilter()
//        filter.types = [.addre]
//        autocompleteController.autocompleteFilter = filter
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.countries = ["kr"] // 로컬라이즈
//        filter.autoContentAccessingProxy
        
//        filter.locationBias = GMSPlaceRectangularLocationOption(<#T##northEastBounds: CLLocationCoordinate2D##CLLocationCoordinate2D#>, <#T##southWestBounds: CLLocationCoordinate2D##CLLocationCoordinate2D#>)//        filter.locationBias = "kore"
    
        client.findAutocompletePredictions(
            fromQuery: query,
            filter: filter,
            sessionToken: nil
        ) { (results, error) in
            guard let results = results, error == nil else {
                completion(.failure(PlaceError.failedToFind))
                return
            }
            
//        businessStatus: String
//        let formattedAddress: String
//        let phoneNumber: String
//        let rating: String
//        let openingHours: String
            
            let places: [Place] = results.compactMap({
                Place(
                    name: $0.attributedFullText.string,
                    identifier: $0.placeID,
                    placeName: $0.attributedPrimaryText.string
                )
            })
            
            completion(.success(places))
        }
    }
    
    //
    public func resolveLocation(
        for place: Place,
        completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void
    ) {
        client.fetchPlace(
            fromPlaceID: place.identifier,
            placeFields: .coordinate,
            sessionToken: nil
        ) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlaceError.failedToGetCoordinate))
                return
            }
            let coordinate = CLLocationCoordinate2D(
                latitude: googlePlace.coordinate.latitude,
                longitude: googlePlace.coordinate.longitude
            )
            completion(.success(coordinate))
        }
    }
}
