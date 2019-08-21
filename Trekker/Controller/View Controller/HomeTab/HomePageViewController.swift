//
//  HomePageViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import MapKit

class HomePageViewController: UIViewController {
    
    let currentLongitude = CoreLocationController.shared.locationManager.location?.coordinate.longitude
    let currentLatitude = CoreLocationController.shared.locationManager.location?.coordinate.latitude
    
    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        CoreLocationController.shared.activateLocationServices()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
