//
//  HomePageViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import MapKit

class HomePageViewController: UIViewController, HikeDetailsViewControllerDelegate {
    
    //Properties
    let screenSize = UIScreen.main.bounds.size
    var selectedHikeVC = SlidingDetailsViewController()
    var selectedHike: HikeJSON?
    var annotationSelected: Bool = false
    let currentLongitude = CoreLocationController.shared.locationManager.location?.coordinate.longitude
    let currentLatitude = CoreLocationController.shared.locationManager.location?.coordinate.latitude
    var searchResults: [HikeJSON] = []
    
    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
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
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.delegate = self
        mapView.delegate = self
        CoreLocationController.shared.activateLocationServices()
        getMyRegion()
        setUpUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        slidingDetailView.cornerRadius(50)
        searchBar.tintColor = .clear
        searchBar.backgroundColor = .clear
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
