//
//  TracingViewController.swift
//  TraceMyRoutes
//
//  Created by sean on 2017/1/24.
//  Copyright © 2017年 oddesign. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps


class TracingViewController: UIViewController, CLLocationManagerDelegate {


    @IBOutlet weak var carPlateNumberLabel: UILabel!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var endButtonWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var mapContainer: GMSMapView!


    var carPlateNumber = ""

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkCoreLocationPermission()

        // TODO: refactor this
        
        KMLMachine.shared.initMachine()

        TraceRouteMachine.shared.startTraceLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func endButtonPressed(_ sender: UIButton) {
        TraceRouteMachine.shared.isLocationTraceDone = true
        TraceRouteMachine.shared.carPlateNumber = self.carPlateNumber
    }

    override func viewWillAppear(_ animated: Bool) {

        carPlateNumberLabel.text = carPlateNumber.description
        initUI()

    }

    func initUI() {
        settingEndButtonUI()

    }
    func settingEndButtonUI() {

        endButtonWidthConstraint.constant = AppConfig.buttonHeight
        view.layoutIfNeeded()
        
        endButton.clipsToBounds = true
        endButton.layer.cornerRadius = endButton.frame.size.height / 2.0

        
    }
    func checkCoreLocationPermission() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        default:
            locationManager.requestWhenInUseAuthorization()
            break;
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.startUpdatingLocation()

        mapContainer.isMyLocationEnabled = true
        mapContainer.settings.myLocationButton = true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard !TraceRouteMachine.shared.isLocationTraceDone else {
            return
        }

        let currentLocation: CLLocation = locations[0]
        print("currentLocation = \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)") //kimuranow
        KMLMachine.shared.save(currentLocation)


        mapContainer.camera = GMSCameraPosition(target: currentLocation.coordinate, zoom: 18, bearing: 0, viewingAngle: 0)

    }

}
