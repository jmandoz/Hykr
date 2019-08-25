//
//  HomePageViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomePageViewController: UIViewController, HikeDetailsViewControllerDelegate {
    
    
    //Properties
    var sourceLocation = CLLocationCoordinate2D()
    var destinationLocation = CLLocationCoordinate2D()
    var directionsArray: [MKDirections] = []
    let screenSize = UIScreen.main.bounds.size
    var selectedHikeVC = SlidingDetailsViewController()
    var selectedHike: HikeJSON?
    var annotationSelected: Bool = false
    let currentLongitude = CoreLocationController.shared.locationManager.location?.coordinate.longitude
    let currentLatitude = CoreLocationController.shared.locationManager.location?.coordinate.latitude
    var searchResults: [HikeJSON] = []
    
    //Outlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var slidingDetailView: UIView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if annotationSelected == false {
        let distance = self.slidingDetailView.frame.height
        slidingDetailView.frame = slidingDetailView.frame.offsetBy(dx: 0, dy: distance)
        self.reloadInputViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        CoreLocationController.shared.activateLocationServices()
        getMyRegion()
        setUpUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setUpUI() {
        slidingDetailView.cornerRadius(50)
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController?.searchBar.tintColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHikes()
    }
    
    func getMyRegion() {
        DispatchQueue.main.async {
            guard let latitude = CoreLocationController.shared.locationManager.location?.coordinate.latitude,
                let longitude = CoreLocationController.shared.locationManager.location?.coordinate.longitude else {return}
            let userCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mySpan = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
            let myRegion = MKCoordinateRegion(center: userCoordinates, span: mySpan)
            self.mapView.setRegion(myRegion, animated: true)
        }
    }
    
    func createAnnotations(hikeArray: [HikeJSON]) {
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            for hike in hikeArray {
                let annotation = HikeAnnotation(hike: hike)
                annotation.coordinate = CLLocationCoordinate2D(latitude: hike.latitude!, longitude: hike.longitude!)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func fetchHikes() {
        guard let currentLat = currentLatitude,
            let currentLon = currentLongitude
            else { return }
        guard let url = NetworkController.sharedInstance.buildURL(baseURL: HikeAPIStrings.baseURL, components: [HikeAPIStrings.components], queryItems: [HikeAPIStrings.latitudeQuery : "\(currentLat)", HikeAPIStrings.longitudeQuery : "\(currentLon)", HikeAPIStrings.apiKey : HikeAPIStrings.apiKeyValue]) else { return }
        NetworkController.sharedInstance.getDataFromURL(url: url) { (data) in
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let topLevelJSON = try decoder.decode(TopLevelJSON.self, from: data)
                guard let trails = topLevelJSON.trails else { return }
                self.searchResults = trails
            } catch {
                print ("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                return
            }
            self.createAnnotations(hikeArray: self.searchResults)
        }
    }
    
    func directionsButtonTapped() {
        getDirections()
    }
    
    func getDirections() {
        guard let hikeLat = selectedHike?.latitude,
            let hikeLong = selectedHike?.longitude,
            let userLat = CoreLocationController.shared.locationManager.location?.coordinate.latitude,
            let userLong = CoreLocationController.shared.locationManager.location?.coordinate.longitude
            else {return}
        let sourceCoordinate = CLLocationCoordinate2DMake(userLat, userLong)
        let destinationCoordinate = CLLocationCoordinate2DMake(hikeLat, hikeLong)
        sourceLocation = sourceCoordinate
        destinationLocation = destinationCoordinate
        let request = createDirectionRequest()
        let directions = MKDirections(request: request)
        resetMapWithNew(directions: directions)
        directions.calculate { [unowned self] (response, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let directionResponse = response else {return}
            let route = directionResponse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func resetMapWithNew(directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map {($0.cancel())}
        directionsArray.removeAll()
    }
    
    func createDirectionRequest() -> MKDirections.Request {
        let startingLocatin = MKPlacemark(coordinate: sourceLocation)
        let destinationCoordinate = MKPlacemark(coordinate: destinationLocation)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocatin)
        request.destination = MKMapItem(placemark: destinationCoordinate)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        return request
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerViewEmbedSegue" {
            if let destinationVC = segue.destination as? SlidingDetailsViewController {
                selectedHikeVC = destinationVC
                selectedHikeVC.delegate = self
            }
        }
    }
}

extension HomePageViewController: UISearchBarDelegate {
    
        func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePageViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
}

extension HomePageViewController: MKMapViewDelegate {
    func showDetailView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            let distance = self.slidingDetailView.frame.height
            self.slidingDetailView.frame = self.slidingDetailView.frame.offsetBy(dx: 0, dy: -distance)
            self.selectedHikeVC.selectedHikeLanding = self.selectedHike
            self.annotationSelected = true
        }, completion: nil)
    }
    
    func hideDetailView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            let distance = self.slidingDetailView.frame.height
            self.slidingDetailView.frame = self.slidingDetailView.frame.offsetBy(dx: 0, dy: distance)
            self.selectedHikeVC.selectedHikeLanding = nil
            self.annotationSelected = false
        }, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? HikeAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            let size = CGSize(width: 37, height: 37)
            annotationView.image = #imageLiteral(resourceName: "pin").resizeImage(targetSize: size)
            annotationView.centerOffset = CGPoint(x: 0, y: -10)
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        renderer.fillColor = .blue
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? HikeAnnotation else { return }
        selectedHike = selectedAnnotation.hike
        view.centerOffset = CGPoint(x: 0, y: -10)
        DispatchQueue.main.async {
            self.showDetailView()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        DispatchQueue.main.async {
                self.hideDetailView()
        }
    }
}
