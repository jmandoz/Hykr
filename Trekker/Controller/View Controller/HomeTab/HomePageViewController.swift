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
    
    let screenSize = UIScreen.main.bounds.size
    
    var selectedHikeVC = SlidingDetailsViewController()
    
    var selectedHike: HikeJSON?
    
    let currentLongitude = CoreLocationController.shared.locationManager.location?.coordinate.longitude
    let currentLatitude = CoreLocationController.shared.locationManager.location?.coordinate.latitude
    
    var searchResults: [HikeJSON] = []
    
    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var slidingDetailView: UIView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hideDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        CoreLocationController.shared.activateLocationServices()
        getMyRegion()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHikes()
        
    }
    
    func getMyRegion() {
        DispatchQueue.main.async {
            guard let latitude = CoreLocationController.shared.locationManager.location?.coordinate.latitude, let longitude = CoreLocationController.shared.locationManager.location?.coordinate.longitude else {return}
            let userCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mySpan = MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
            let myRegion = MKCoordinateRegion(center: userCoordinates, span: mySpan)
            self.mapView.setRegion(myRegion, animated: true)
        }
    }
    
    func createAnnotations(hikeArray: [HikeJSON]) {
        for hike in hikeArray {
            DispatchQueue.main.async {
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerViewEmbedSegue" {
            if let destinationVC = segue.destination as? SlidingDetailsViewController {
                selectedHikeVC = destinationVC
                selectedHikeVC.delegate = self
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension HomePageViewController: MKMapViewDelegate {
    

    
    func showDetailView() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
//                self.slidingDetailView.alpha = 1
                let distance = self.slidingDetailView.frame.height
                self.slidingDetailView.frame = self.slidingDetailView.frame.offsetBy(dx: 0, dy: -distance)
                self.selectedHikeVC.selectedHikeLanding = self.selectedHike
            }, completion: nil)
    }
    
    func hideDetailView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
//            self.slidingDetailView.alpha = 0
            let distance = self.slidingDetailView.frame.height
            self.slidingDetailView.frame = self.slidingDetailView.frame.offsetBy(dx: 0, dy: distance)
            self.selectedHikeVC.selectedHikeLanding = nil
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
