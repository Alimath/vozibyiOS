//
//  VZMapViewController.swift
//  voziby
//
//  Created by Fedar Trukhan on 07.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//
import UIKit

class VZMapViewController: UIViewController, GMSMapViewDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "40a9f4")]
        }
        self.navigationItem.title = "vozim.by"
        
        let backButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.Plain, target: self, action: "Cancel")
        navigationItem.leftBarButtonItem = backButton
        
        let nextButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.Plain, target: self, action: "ChoosePosition")
        navigationItem.rightBarButtonItem = nextButton
        
        var camera = GMSCameraPosition.cameraWithLatitude(53.902464,
            longitude:27.561490, zoom:11)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        
        var marker = GMSMarker()
        marker.position = camera.target
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        self.view = mapView
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
    
        mapView.selectedMarker = marker
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ChoosePosition()
    {
        var tempMapView: GMSMapView = self.view as GMSMapView
        
        self.reverseGeocodeCoordinate(tempMapView.selectedMarker.position)
        
        let geocoder = GMSGeocoder()
        SpinnerStub.show()
        geocoder.reverseGeocodeCoordinate(tempMapView.selectedMarker.position)
        { response , error in
            SpinnerStub.hide()
            if let address = response?.firstResult()
            {
                SpinnerStub.hide()
                
                var userDefaults = NSUserDefaults.standardUserDefaults()
                
                if(address.locality != nil)
                {
                    userDefaults.setObject("\(address.country), \(address.locality)", forKey: kVZTempLocationKey)
                }
                else
                {
                    userDefaults.setObject("\(address.country)", forKey: kVZTempLocationKey)
                }
                userDefaults.synchronize()
                
                self.navigationController?.popViewControllerAnimated(true)
                
                NSNotificationCenter.defaultCenter().postNotificationName("addressselected", object: nil)
            }
            else
            {
                ShowAlertView(self, "Ошибка", "Невозможно определить ваше местоположение", "Зыкрыть")
            }
            if let eror = error
            {
                ShowAlertView(self, "Ошибка", "Невозможно определить ваше местоположение", "Зыкрыть")
            }
        }
        
    }
    
    func Cancel()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D)
    {
        var tempMapView: GMSMapView = self.view as GMSMapView
        tempMapView.clear()
        
        var marker = GMSMarker(position: coordinate)
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = tempMapView
        
        tempMapView.selectedMarker = marker
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D)
    {
        
    }
}
