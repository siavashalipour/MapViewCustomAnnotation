//
//  ViewController.swift
//  MapDesign
//
//  Created by Siavash Abbasalipour on 14/09/2016.
//  Copyright © 2016. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

struct Place {
    let latitude: Double
    
    let longitude: Double
}
class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var carousel: iCarousel!
    let locationManager: CLLocationManager = CLLocationManager()
    var annotations: [StoreAnnotation] = []

    fileprivate var currentLocationCoordinate: CLLocationCoordinate2D? {
        didSet {
            getAllStores(isLocationServicesOn: true)
        }
    }
    var places: [Place] = [Place.init(latitude: -33.86414398, longitude: 151.2120223),
                           Place.init(latitude: -33.86183657, longitude: 151.21239781),
                           Place.init(latitude: -33.86202366, longitude: 151.20832086),
                           Place.init(latitude: -33.86422416, longitude: 151.20760202),
                           Place.init(latitude: -33.86444688, longitude: 151.20855689)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        carousel.delegate = self
        carousel.dataSource = self
        carousel.isPagingEnabled = true
        carousel.type = .linear
        
        //mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.delegate = self
        if !isLocationAuthorized(CLLocationManager.authorizationStatus()) {
        }
        addAnnotationWithDistanceInMeter()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func getAllStores(isLocationServicesOn: Bool) {

    }
    func isLocationAuthorized(_ status: CLAuthorizationStatus) -> Bool {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .notDetermined, .restricted:
            return false
        }
    }
    fileprivate func addAnnotationWithDistanceInMeter() {
        for aPlace in places {
            let coordinate = CLLocationCoordinate2DMake(aPlace.latitude, aPlace.longitude)
            let image = UIImage(named: "pin")
            let annotation = StoreAnnotation(coordinate: coordinate, title: "title",image: image!)
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
        mapView.camera.altitude *= 3
        mapView.selectAnnotation(annotations[0], animated: false)
    }

}
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "StoreAnnotationView")
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "StoreAnnotationView")
        }
        annotationView?.image = UIImage(named: "sanFran")
        annotationView?.canShowCallout = true
        return annotationView
        
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {

    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.removeOverlays(mapView.overlays)
        if view is StoreAnnotationView {
            let storeAnnotaionView = view as! StoreAnnotationView
            if let safeCurrentLoc = currentLocationCoordinate {
                let sourcePlacemark = MKPlacemark(coordinate: safeCurrentLoc, addressDictionary: nil)
                let destinationPlacemark = MKPlacemark(coordinate: storeAnnotaionView.coordinate, addressDictionary: nil)
                
                let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                let directionRequest = MKDirectionsRequest()
                directionRequest.source = sourceMapItem
                directionRequest.destination = destinationMapItem
                directionRequest.transportType = .automobile
                
                // Calculate the direction
                let directions = MKDirections(request: directionRequest)
                
                directions.calculate {
                    (response, error) -> Void in
                    
                    guard let response = response else {
                        if let error = error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    let route = response.routes[0]
                    self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                }
            }
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 1.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    fileprivate func locationTrackingIsAuthorized() {
        if CLLocationManager.locationServicesEnabled() && isLocationAuthorized(CLLocationManager.authorizationStatus()) {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if isLocationAuthorized(status) {
            locationTrackingIsAuthorized()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        getAllStores(isLocationServicesOn: false)
    }
}
// MARK: iCarousel
extension ViewController: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 5
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIView
        var innerCardHolderView: MapCardView
        
        //create new view if no view is available for recycling
        if (view == nil) {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            let maxWidth = UIScreen.main.bounds.width-44
            itemView = UIView(frame:CGRect(x:0, y:0, width:maxWidth - 90, height:210))
            
            innerCardHolderView = MapCardView.instanceFromNib()
            innerCardHolderView.tag = 1
            itemView.addSubview(innerCardHolderView)
            innerCardHolderView.snp.makeConstraints { (make) in
                make.edges.equalTo(itemView)
            }
        } else {
            //get a reference to the label in the recycled view
            itemView = view!
            innerCardHolderView = itemView.viewWithTag(1) as! MapCardView!
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        //let anItem = items[index]
        innerCardHolderView.setupUI()
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        print(carousel.currentItemIndex)
        mapView.selectAnnotation(annotations[carousel.currentItemIndex], animated: true)
        mapView.showAnnotations(annotations, animated: true)

    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
//        let anItem = items[index]
//        let aCard = LoyaltyCardView.instanceFromNib()
//        aCard.setupUI(anItem.cornerRadius, barcode: anItem.barcode, loyaltyPoints: anItem.loyaltyPoints)
//        selectedloyaltyCard = aCard
//        performSegueWithIdentifier(editCardSegue, sender: self)
    }
}
