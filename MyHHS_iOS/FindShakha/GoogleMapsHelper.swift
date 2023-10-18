//
//  GoogleMapsHelper.swift
//  MyHHS_iOS
//
//  Created by Patel on 23/07/2021.
//

import Foundation
import GoogleMaps

struct GoogleMapsHelper {
    static let London = CLLocation(latitude: 51.5074, longitude: 0.1278)
    static var preciseLocationZoomLevel: Float = 15.0
    static var approximateLocationZoomLevel: Float = 10.0

    static func initLocationManager(_ locationManager: CLLocationManager, delegate: UIViewController) {
        var locationManager = locationManager
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = delegate as? CLLocationManagerDelegate
    }
    
    static func createMap(on view: UIView, locationManager: CLLocationManager, mapView: GMSMapView) {
        if #available(iOS 14.0, *) {
            let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
            let camera = GMSCameraPosition.camera(withLatitude: London.coordinate.latitude, longitude: London.coordinate.longitude, zoom: zoomLevel)
            
            var mapView = mapView
            mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
            mapView.settings.myLocationButton = true
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.isMyLocationEnabled = true
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
            marker.title = "Hey"
            marker.snippet = "How r u!!"
            marker.map = mapView
//            view.addSubview(mapView)
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    static func didUpdateLocations(_ locations: [CLLocation], locationManager: CLLocationManager,  mapView: GMSMapView) {
        if #available(iOS 14.0, *) {
            let location: CLLocation = locations.last!

            let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
            let camera = GMSCameraPosition.camera(withLatitude: London.coordinate.latitude, longitude: London.coordinate.longitude, zoom: zoomLevel)
            mapView.camera = camera
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    static func handle(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //  Check accuracy authorization
        if #available(iOS 14.0, *) {
            let accuracy = manager.accuracyAuthorization
            switch accuracy {
            case .fullAccuracy:
                print("Location accuracy is precise.")
            case .reducedAccuracy:
                print("Location accuracy is not precise.")
            default:
                fatalError()
            }
            
        //  Handle authorization status
            switch status {
            case .restricted:
                print("Location access was restricted.")
            case .denied:
                print("User denied access to location.")
            case .notDetermined:
                print("Location status not determined.")
            case .authorizedAlways: fallthrough
            case .authorizedWhenInUse:
                print("Location status is ok.")
            default:
                fatalError()
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
}

