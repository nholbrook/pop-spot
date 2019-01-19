//
//  MapViewController.swift
//  PredictiveTaxiHeatmap
//
//  Created by Nick Holbrook on 1/19/19.
//  Copyright © 2019 Nick Holbrook. All rights reserved.
//

import UIKit
import GoogleMaps
//import Floaty

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            if ((locationManager.location) != nil) {
                let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
                
                let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 10.0)
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                view = mapView
                
                var heatmapLayer: GMUHeatmapTileLayer!
                heatmapLayer = GMUHeatmapTileLayer()
                heatmapLayer.map = mapView
                addHeatmap()
            }
        }
        
        /*let floaty = Floaty()
        floaty.addItem(title: "Hello, World!")
        self.view.addSubview(floaty)*/
    }
    
    func addHeatmap()  {
        var list = [GMUWeightedLatLng]()
        do {
            // Get the data: latitude/longitude positions of police stations.
            if let path = Bundle.main.url(forResource: "police_stations", withExtension: "json") {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [[String: Any]] {
                    for item in object {
                        let lat = item["lat"]
                        let lng = item["lng"]
                        let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees), intensity: 1.0)
                        list.append(coords)
                    }
                } else {
                    print("Could not read the JSON.")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        // Add the latlngs to the heatmap layer.
        heatmapLayer.weightedData = list
    }


}
