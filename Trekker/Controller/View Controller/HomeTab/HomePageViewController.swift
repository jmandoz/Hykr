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

class HomePageViewController: UIViewController, SlidingDetailsViewControllerDelegate {
    
    
    @IBOutlet weak var centerLocationButton: UIButton!
    
    
    //Properties
    var selectedHike: HikeJSON?
    var searchResults: [HikeJSON] = []
    var routeDistance = CLLocationDistance()
    var distanceToHike: String?
    var expectedTimeToHike: String?
    var travelTimeToHike = TimeInterval()
    var sourceLocation = CLLocationCoordinate2D()
    var destinationLocation = CLLocationCoordinate2D()
    var directionsArray: [MKDirections] = []
    var selectedHikeVC = SlidingDetailsViewController()
    var annotationSelected: Bool = false
    var currentLongitude = CoreLocationController.shared.locationManager.location?.coordinate.longitude
    var currentLatitude = CoreLocationController.shared.locationManager.location?.coordinate.latitude
    let screenSize = UIScreen.main.bounds.size
    var searchBar: UISearchBar?
    
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
       // CoreLocationController.shared.locationManager.delegate = self
        mapView.delegate = self
        centerLocationButton.isHidden = true
        CoreLocationController.shared.activateLocationServices()
        getMyRegion()
        setUpUI()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func centerLocationButtonTapped(_ sender: Any) {
        self.currentLongitude = CoreLocationController.shared.locationManager.location?.coordinate.longitude
        self.currentLatitude = CoreLocationController.shared.locationManager.location?.coordinate.latitude
        getMyRegion()
        fetchHikes()
        centerLocationButton.isHidden = true
    }
    
    func setUpUI() {
        slidingDetailView.cornerRadius(50)
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController?.searchBar.barTintColor = .white
        self.searchBar = searchController.searchBar
        self.searchBar?.delegate = self
        self.searchBar?.tintColor = .white
        self.searchBar?.barTintColor = .white
        self.searchBar?.placeholder = "Search any location"
        self.searchBar?.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHikes()
    }
    
    func getMyRegion() {
        DispatchQueue.main.async {
            guard let latitude = self.currentLatitude,
                let longitude = self.currentLongitude else {return}
            let userCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mySpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let myRegion = MKCoordinateRegion(center: userCoordinates, span: mySpan)
            self.mapView.setRegion(myRegion, animated: true)
        }
    }
    
    func selectedHikeRegion() {
        guard let latitude = selectedHike?.latitude,
            let longitude = selectedHike?.longitude else {return}
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mySpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let myRegion = MKCoordinateRegion(center: coordinates, span: mySpan)
        self.mapView.setRegion(myRegion, animated: true)
    }
    
    func deselectedHikeRegion() {
        guard let latitude = selectedHike?.latitude,
            let longitude = selectedHike?.longitude else {return}
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mySpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let myRegion = MKCoordinateRegion(center: coordinates, span: mySpan)
        self.mapView.setRegion(myRegion, animated: true)
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
            let currentLon = currentLongitude,
            let url = NetworkController.sharedInstance.buildURL(baseURL: HikeAPIStrings.baseURL, components: [HikeAPIStrings.components], queryItems: [HikeAPIStrings.latitudeQuery : "\(currentLat)", HikeAPIStrings.longitudeQuery : "\(currentLon)", HikeAPIStrings.apiKey : HikeAPIStrings.apiKeyValue]) else { return }
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
    
    func directionsButtonTapped(view: SlidingDetailsViewController) {
        getDirections(view)
    }
    
    func getDirections(_ view: SlidingDetailsViewController) {
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
            let distance = route.distance
            self.routeDistance = distance
            let travelTime = route.expectedTravelTime
            self.travelTimeToHike = travelTime
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                           edgePadding: UIEdgeInsets(top: 20.0, left: 10.0, bottom: self.screenSize.height / 3, right: 10.0),
                                           animated: false)
            let distanceFormatter = MKDistanceFormatter()
            let timeFormatter = DateComponentsFormatter()
            timeFormatter.allowedUnits = [.day, .hour, .minute, .second]
            timeFormatter.unitsStyle = .abbreviated
            timeFormatter.maximumUnitCount = 1
            self.distanceToHike = distanceFormatter.string(fromDistance: distance)
            self.expectedTimeToHike = timeFormatter.string(from: self.travelTimeToHike)
            view.hikeDistanceLabel.text = "\(self.distanceToHike ?? "0") - Expected Travel Time: \(self.expectedTimeToHike ?? "0")"
            view.hikeDistanceLabel.alpha = 1
            
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResultsForSearchController(searchBar: searchBar)
    }
    
    func updateSearchResultsForSearchController(searchBar: UISearchBar) {
        guard let mapView = mapView,
            let searchBarText = searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            self.currentLongitude = response.mapItems[0].placemark.coordinate.longitude
            self.currentLatitude = response.mapItems[0].placemark.coordinate.latitude
            self.centerLocationButton.isHidden = false
            self.getMyRegion()
            self.fetchHikes()
        }
    }
    
    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    
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
        renderer.alpha = 0.7
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? HikeAnnotation else { return }
        selectedHike = selectedAnnotation.hike
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                view.centerOffset = CGPoint(x: 0, y: -20)
            }, completion: nil)
            self.showDetailView()
            self.selectedHikeRegion()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        DispatchQueue.main.async {
            self.hideDetailView()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                view.centerOffset = CGPoint(x: 0, y: -10)
            }, completion: nil)
            self.deselectedHikeRegion()
            mapView.removeOverlays(mapView.overlays)
            let _ = self.directionsArray.map {($0.cancel())}
            self.selectedHikeRegion()
        }
    }
}
