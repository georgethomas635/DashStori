//
//  WorldStoriesViewController.swift
//  DashStori
//
//  Created by QBurst on 22/09/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Kingfisher

class WorldStoriesViewController: BaseViewController {
    
    var stories:[WorldStori]  = []
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.mapType = .hybrid
        mapView.showsUserLocation = true

        getWorldStoriList()
        setIntialFocus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWorldStoriList() {
        Utilities.showActivityIndicatory()
        let manager = DashStoriManager()
        manager.getListOfWorldStories(){
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let storiList = data as! WorldStoriDetails
                self.stories = storiList.data
                self.populateMapView()
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    
    func populateMapView() {
        mapView.addAnnotations(stories)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapToStoriDetails"){
            let storiDetails = segue.destination as! StoriDetailsViewController
            let storiId = sender as! Int
            storiDetails.storiID = storiId
        }
    }
    
}

//MARK: CLLocationManagerDelegate
extension WorldStoriesViewController: CLLocationManagerDelegate {
    
    func setIntialFocus(){
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
}

//MARK: MKMapViewDelegate
import MapKit
extension WorldStoriesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if(annotation.isEqual(mapView.userLocation)) {
            return nil;
        }
        
        var annotationView:MKPinAnnotationView! = nil
        if let newAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "places") as? MKPinAnnotationView {
            annotationView = newAnnotationView
            annotationView.annotation = annotation
        }
        else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "places")
            annotationView.canShowCallout = true
        }
        annotationView.leftCalloutAccessoryView = self.imageView(for: annotation as! WorldStori)
        annotationView.rightCalloutAccessoryView = self.detailView(for: annotation as! WorldStori)
        return annotationView
    }
    
    func imageView(for annotation: WorldStori) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        if let url = URL(string: IMAGE_URL + annotation.thumbImage) {
            let resource = ImageResource(downloadURL: url)
            
            imageView.kf.setImage(with: resource,
                                  placeholder: UIImage(named: "avtar_small"),
                                  options: nil, progressBlock: nil, completionHandler: nil)
        }
        return imageView
    }
    
    func detailView(for annotation: WorldStori) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let image = UIImage(named: "right-arrow")
        button.setImage(image, for: .normal)
        button.tag = annotation.storiId
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .primaryActionTriggered)
        return button
    }
    
    func didTapButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mapToStoriDetails", sender: sender.tag)
    }
}
