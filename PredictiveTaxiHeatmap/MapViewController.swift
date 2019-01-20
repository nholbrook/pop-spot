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
import Toaster

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var locationManager: CLLocationManager!
    
    private var list: [GMUWeightedLatLng]!

    private var gradientColors = [UIColor.green, UIColor.red]
    private var gradientStartPoints = [0.1, 0.3] as [NSNumber]
    
    override func viewDidLoad() {
        //populateList()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
                
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            if ((locationManager.location) != nil) {
                let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
                
                let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 10.0)
                mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                mapView.setMinZoom(9.0, maxZoom: 11.0)
                
                mapView.isMyLocationEnabled = true
                
                view = mapView
                
                //addHeatmap()
                // Set the heatmap to the mapview.
                //heatmapLayer.weightedData = [GMUWeightedLatLng]();
                //heatmapLayer.map = mapView
                list = [GMUWeightedLatLng]()
                
                Alamofire.request("https://7abzu16vk0.execute-api.us-west-2.amazonaws.com/Prod")
                    .responseJSON(completionHandler: { response in
                        if let result = response.result.value {
                            let json = JSON(result)
                            for item in json["Items"] {
                                print(item.1["latitude"]["S"].doubleValue)
                                
                                let lat = item.1["latitude"]["S"].doubleValue
                                let lng = item.1["longitude"]["S"].doubleValue
                                let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat , lng ), intensity: 0.5)
                                print(coords.intensity)
                                self.list.append(coords)
                            }
                        }
                        self.heatmapLayer = GMUHeatmapTileLayer()
                        self.heatmapLayer.radius = 80
                        self.heatmapLayer.opacity = 0.7
                        self.heatmapLayer.gradient = GMUGradient(colors: self.gradientColors,
                                                            startPoints: self.gradientStartPoints,
                                                            colorMapSize: 256)
                        print(self.list)
                        self.heatmapLayer.weightedData = self.list
                        //self.heatmapLayer.clearTileCache()
                        self.heatmapLayer.map = self.mapView
                })
                
            }
        }
        
        let floaty = Floaty()
        floaty.buttonColor = UIColor(red: 37/255, green: 38/255, blue: 41/255, alpha: 255/255)
        floaty.plusColor = UIColor.white
        floaty.addItem(title: "Log Pickup",  handler: { item in
            let lat = Double.random(in: 42.67 ... 42.77)
            let long = Double.random(in: -84.53 ... -84.43)
            Alamofire.request("https://7abzu16vk0.execute-api.us-west-2.amazonaws.com/Prod?latitude=" + String(lat) + "&longitude=" + String(long), method: .post).response(completionHandler: { response in
                print(response)
                ToastView.appearance().bottomOffsetPortrait = 60
                let toast = Toast(text: "Pickup recorded at (" + String(lat) + ", " + String(long) + ")", duration: Delay.short)
                toast.show()
                let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat , long), intensity: 0.5)
                print(coords.intensity)
                self.list.append(coords)
                self.heatmapLayer.weightedData = self.list
                self.heatmapLayer.clearTileCache()
                self.heatmapLayer.map = self.mapView
            });

            floaty.close()
        })
        floaty.addItem(title: "Log Pickup x10 [DEV]",  handler: { item in
            for _ in 0 ..< 10 {
                let lat = Double.random(in: 42.67 ... 42.77)
                let long = Double.random(in: -84.53 ... -84.43)
                Alamofire.request("https://7abzu16vk0.execute-api.us-west-2.amazonaws.com/Prod?latitude=" + String(lat) + "&longitude=" + String(long), method: .post).response(completionHandler: { response in
                    print(response)
                });
                let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat , long), intensity: 0.5)
                print(coords.intensity)
                self.list.append(coords)
            }
            ToastView.appearance().bottomOffsetPortrait = 60
            let toast = Toast(text: "10 pickups recorded [DEV]", duration: Delay.short)
            toast.show()
            self.heatmapLayer.weightedData = self.list
            self.heatmapLayer.clearTileCache()
            self.heatmapLayer.map = self.mapView
            
            floaty.close()
        })
        floaty.addItem(title: "Log Pickup x50 [DEV]",  handler: { item in
            for _ in 0 ..< 50 {
                let lat = Double.random(in: 42.56 ... 42.88)
                let long = Double.random(in: -84.64 ... -84.32)
                Alamofire.request("https://7abzu16vk0.execute-api.us-west-2.amazonaws.com/Prod?latitude=" + String(lat) + "&longitude=" + String(long), method: .post).response(completionHandler: { response in
                    print(response)
                });
                let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat , long), intensity: 0.5)
                print(coords.intensity)
                self.list.append(coords)
            }
            ToastView.appearance().bottomOffsetPortrait = 60
            let toast = Toast(text: "50 pickups recorded [DEV]", duration: Delay.short)
            toast.show()
            self.heatmapLayer.weightedData = self.list
            self.heatmapLayer.clearTileCache()
            self.heatmapLayer.map = self.mapView
            
            floaty.close()
        })
        self.view.addSubview(floaty)
    }
    
    /*func addHeatmap() {
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
            // Add the latlngs to the heatmap layer.
            heatmapLayer = GMUHeatmapTileLayer()
            heatmapLayer.radius = 80
            heatmapLayer.opacity = 0.8
            heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                                startPoints: gradientStartPoints,
                                                colorMapSize: 256)
            heatmapLayer.clearTileCache()
            heatmapLayer.weightedData = list
            
        } catch {
            print(error.localizedDescription)
        }
    }*/
}
