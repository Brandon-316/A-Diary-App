//
//  MapViewController.swift
//  A Diary App
//
//  Created by Brandon Mahoney on 2/8/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    
    //MARK: Properties
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
    var entryLocation: CLLocation?
    
    //Callback for saving new location
    var onSave: ((_ location: (locationString: String, location: CLLocation)) -> ())?
    
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        checkLocationServices()
    }
    
    
    //MARK: Methods
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        //Check if location already set
        if let location = self.entryLocation {
            let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            return
        }
        
        //If not center on current location
        if let location = locationManager.location {
            let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
//            self.entryLocation = location
            return
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
            self.generalAlert(title: "Location Services Off", message: "Please turn on location services to record a location")
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                startTackingUserLocation()
            case .denied:
                // Show alert instructing them how to turn on permissions
                self.generalAlert(title: "Error", message: "Please go to settings and make sure you have enabled location services for this app.")
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // Show an alert letting them know what's up
                self.generalAlert(title: "Error", message: "Please go to settings and make sure you have enabled location services for this app.")
                break
            case .authorizedAlways:
                break
            default: break
        }
    }
    
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    @objc func saveTapped() {
        guard let location = addressLabel.text else { return }
        guard let coordinates = self.entryLocation else { return }
        let object: (locationString: String, location: CLLocation) = (location, coordinates)
        self.onSave?(object)
        self.navigationController?.popViewController(animated: true)
    }
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        self.entryLocation = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? ""
            let country = placemark.country ?? ""
            
            DispatchQueue.main.async {
                if city.isEmpty {
                    self.addressLabel.text = "\(state) \(country)"
                } else {
                    self.addressLabel.text = "\(city), \(state) \(country)"
                }
            }
        }
    }
}
