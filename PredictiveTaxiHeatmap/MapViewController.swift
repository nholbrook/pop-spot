//
//  MapViewController.swift
//  PredictiveTaxiHeatmap
//
//  Created by Nick Holbrook on 1/19/19.
//  Copyright © 2019 Nick Holbrook. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit
import Floaty
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var locationManager: CLLocationManager!

    private var gradientColors = [UIColor.green, UIColor.red]
    private var gradientStartPoints = [0.2, 1.0] as [NSNumber]
    
    private var list: [GMUWeightedLatLng]!
    
    override func viewDidLoad() {
        //populateList()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            if ((locationManager.location) != nil) {
                let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
                
                let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 10.0)
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                
                //mapView.settings.myLocationButton = true
                view = mapView
                
                heatmapLayer = GMUHeatmapTileLayer()
                heatmapLayer.radius = 80
                heatmapLayer.opacity = 0.8
                heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                                    startPoints: gradientStartPoints,
                                                    colorMapSize: 256)
                /*if (self.list != nil) {
                    heatmapLayer.weightedData = self.list
                } else {
                    print("list null")
                }*/
                
                addHeatmap()
                // Set the heatmap to the mapview.
                //heatmapLayer.weightedData = [GMUWeightedLatLng]();
                heatmapLayer.map = mapView
            }
        }
        
        let floaty = Floaty()
        floaty.buttonColor = UIColor.darkGray
        floaty.plusColor = UIColor.white
        self.view.addSubview(floaty)
    }
    
    func populateList() {
        self.list = [GMUWeightedLatLng]();
        
        Alamofire.request("https://7abzu16vk0.execute-api.us-west-2.amazonaws.com/Prod")
        .responseJSON(completionHandler: { response in
            if let result = response.result.value {
                let json = JSON(result)
                for item in json["Items"] {
                    print(item.1["latitude"]["S"].doubleValue)
                    
                    let lat = item.1["latitude"]["S"].doubleValue
                    let lng = item.1["longitude"]["S"].doubleValue
                    let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat , lng), intensity: 1.0)
                    print(coords.intensity)
                    self.list.append(coords)
                }
            }
            self.heatmapLayer.weightedData = self.list
            self.heatmapLayer.clearTileCache()
        })
    }
    
    func addHeatmap()  {
        var list = [GMUWeightedLatLng]()
        do {
            // Get the data: latitude/longitude positions of police stations.
            if let path = Bundle.main.url(forResource: "pickups", withExtension: "json") {
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
