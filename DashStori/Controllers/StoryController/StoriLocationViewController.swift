//
//  StoriLocationViewController.swift
//  DashStori
//
//  Created by George on 02/05/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class StoriLocationViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var txtPlaceName: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var autoCompleteTable: UITableView!
    
    var fetcher: GMSAutocompleteFetcher?
    var addressList:[String] = []
    var placeId:[String] = []
    var storiLocation = CLLocationCoordinate2D()
    var readOnlyMode:Bool = false
    var gestureRecognizer:UITapGestureRecognizer!
    var didFindLocationFlag:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = .hybrid
        mapView.showsUserLocation = true
        addGestureRecognizer()
        setVariables()
        setIntialFocus()
        setAutocompleteFetcher()
        setStoriLocation()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func isMenuHeaderHidden() -> Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "navigateToWriteStori"){
            let storiDetails = segue.destination as! WriteStoriViewController
            storiDetails.storiLocation = self.storiLocation
        }
    }
    //MARK: @IBAction
    @IBAction func backAction(_ sender: Any) {
        cancelToWriteStori()
    }
    @IBAction func doneAction(_ sender: Any) {
        navigateToWriteStori()
    }
    
    //MARK: Initialisation
    func setVariables(){
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = Utilities.getColor(hex: COLOR_RED).cgColor
        
        txtPlaceName?.addTarget(self, action: #selector(placeNameAutoComplete),
                                for: .editingChanged)
        
        self.autoCompleteTable.delegate = self
        self.autoCompleteTable.dataSource = self
        tableHeight.constant =  CGFloat(30) * CGFloat(addressList.count)
        if(readOnlyMode == true){
            doneButton.isHidden = true
            txtPlaceName.isEnabled = false
            mapView.removeGestureRecognizer(gestureRecognizer)
        }
    }
    var locationManager: CLLocationManager!
    func setIntialFocus(){
        // set initial location in Honolulu
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: GestureRecognizer
    func addGestureRecognizer(){
        gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        //Clear Mapview
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let location = gestureReconizer.location(in: mapView)
        storiLocation = mapView.convert(location,toCoordinateFrom: mapView)
        setPlaceName(location: storiLocation)
        dropPin(location: storiLocation,tabGestureFlag:true)
    }
    
    //MARK: MapView
    func dropPin(location: CLLocationCoordinate2D,tabGestureFlag:Bool){
        // Add annotation:
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        //Focus change
        self.storiLocation = location
        let mapBoundsWidth = Double(self.mapView.bounds.size.width)
        let mapRectWidth = self.mapView.visibleMapRect.size.width
        let scale = mapBoundsWidth / mapRectWidth
        let viewRegion = MKCoordinateRegionMakeWithDistance(location, scale, scale)
        self.mapView.setRegion(viewRegion, animated: true)
        
    }
    
    func getcoordinate(location:String) {
        
        DispatchQueue.main.async {
            let placesClient = GMSPlacesClient.shared()
            placesClient.lookUpPlaceID((location), callback: { (place, error) in
                Utilities.hideActivityIndicatory()
                if(place != nil){
                    print(place?.coordinate ?? "default")
                    self.dropPin(location: (place?.coordinate)!,tabGestureFlag: false)
                    
                    self.view.endEditing(true)
                    self.hideAutoComplete()
                }else{
                    self.showAlertMessage(errorMessage: error.debugDescription)
                    print(error.debugDescription)
                }
            })
        }
    }
    
    func setPlaceName(location: CLLocationCoordinate2D){
        let geocoder = CLGeocoder()
        let addressPoint = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(addressPoint){
            (placemarks, error) -> Void in
            self.hideAutoComplete()
            if(placemarks != nil){
                if (placemarks?.count)! > 0 {
                    let address = (placemarks?[0])! as CLPlacemark
                    self.displayLocationInfo(placemark: address)
                }
                else {
                    self.showAlertMessage(errorMessage: "Problem with the data received from geocoder")
                }
            }else{
                self.showAlertMessage(errorMessage: "Problem with the data received from geocoder")
            }
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark?)
    {
        if let containsPlacemark = placemark
        {
            //stop updating location to save battery life
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality! + "," : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea! + "," : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            txtPlaceName.text = locality + administrativeArea + country!
            
        }
        
    }
    
    func placeNameAutoComplete(){
        fetcher?.sourceTextHasChanged(txtPlaceName.text!)
    }
    
    //MARK: Navigate
    func navigateToWriteStori(){
        let index = (self.navigationController?.viewControllers.count)! - 2
        let viewController = self.navigationController?.viewControllers[index] as! WriteStoriViewController
        viewController.storiLocation = storiLocation
        self.navigationController?.popViewController(animated: true)
    }
    func cancelToWriteStori(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: AutocompleteFetcher
    func setAutocompleteFetcher(){
        
        GMSPlacesClient.provideAPIKey("AIzaSyB7lhdj03iUlaBHy-Zwwy8bZBqoqzymilI")
        // Set bounds to America.
        let neBoundsCorner = CLLocationCoordinate2D(latitude: 37.0902,
                                                    longitude: 95.7129)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: 56.1304,
                                                    longitude: 106.3468)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                         coordinate: swBoundsCorner)
        
        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        
        
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
    }
    //MARK: Auto complete
    func hideAutoComplete(){
        autoCompleteTable.isHidden = true
    }
    func showpopovercontroller(){
        autoCompleteTable.isHidden = false
        tableHeight.constant =  CGFloat(30) * CGFloat(addressList.count)
        if(addressList.count != 0){
            autoCompleteTable.reloadData()
        }else{
            hideAutoComplete()
        }
    }
    func setStoriLocation(){
        if(storiLocation.latitude != 0){
            dropPin(location: storiLocation,tabGestureFlag: false)
            setPlaceName(location: storiLocation)
        }
    }
}
//MARK: MKMapViewDelegate
extension StoriLocationViewController: MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //self.mapView.showsUserLocation = true
        if(storiLocation.latitude == 0){
            if(!didFindLocationFlag){
                didFindLocationFlag = !didFindLocationFlag
                let location = locations.last! as CLLocation
                
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
}

//MARK: AutocompleteFetcherDelegate
extension StoriLocationViewController: GMSAutocompleteFetcherDelegate{
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        addressList.removeAll()
        placeId.removeAll()
        for prediction in predictions {
            addressList.append(prediction.attributedFullText.string)
            placeId.append(prediction.placeID!)
        }
        showpopovercontroller()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        hideAutoComplete()
        print(error.localizedDescription)
        showAlertMessage(errorMessage: error.localizedDescription)
    }
}

//MARK: TableViewDelegate
extension StoriLocationViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoCompleteCell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell")
        if(indexPath.row <= addressList.count && addressList.count != 0){
            autoCompleteCell?.textLabel?.text = addressList[indexPath.row]
        }
        return autoCompleteCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Utilities.showActivityIndicatory()
        txtPlaceName.text = addressList[indexPath.row]
        getcoordinate(location: placeId[indexPath.row])
        print(placeId[indexPath.row])
    }
}
