//
//  MapVC.swift
//  LIFT
//
//  Created by Jordan Kauffman on 2/25/16.
//  Copyright © 2016 Jordan Kauffman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!

    private let regionRadius: CLLocationDistance = 15000
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let loc = CLLocation(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        
        centerMapOnLocation(location: loc)
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Gyms"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            if error != nil
            {
                print("Error occured in search: \(error!.localizedDescription)")
            }
            else if response!.mapItems.count == 0
            {
                print("No matches found")
            }
            else
            {
                print("Matches found")
                
                for item in response!.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name!
                    annotation.subtitle = item.phoneNumber!
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    @IBAction func back(sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
