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
    var path: GMSPath? = GMSPath()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        if let font = UIFont(name: "Roboto-Regular", size: 16)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "727272")]
        }
        self.navigationItem.title = "vozim.by"
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        
        let backButton = UIBarButtonItem(title: "    Назад", style: UIBarButtonItemStyle.Plain, target: self, action: "GoBack")
        if let font = UIFont(name: "Roboto-Regular", size: 13)
        {
            backButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "40a9f4")], forState: UIControlState.Normal)
        }
        navigationItem.leftBarButtonItem = backButton
        
        if(path == nil)
        {
            let nextButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.Plain, target: self, action: "ChoosePosition")
            navigationItem.rightBarButtonItem = nextButton
        }
        
        if(path != nil)
        {
            var bounds: GMSCoordinateBounds = GMSCoordinateBounds(path: path)
            var insets: CGFloat = 20
            //        mapView.camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
            let line = GMSPolyline(path: path)
            var mapView = GMSMapView(frame: self.view.frame)
            
            mapView.camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
            
//            var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:GMSMapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)))
            
            var marker = GMSMarker(position: path!.coordinateAtIndex(0))
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.icon = UIImage(named: "MarkerA")
            marker.map = mapView
            
            var marker2 = GMSMarker(position: path!.coordinateAtIndex(path!.count()-1))
            marker2.appearAnimation = kGMSMarkerAnimationPop
            marker2.icon = UIImage(named: "MarkerB")
            marker2.map = mapView
            
            
            
            line.strokeWidth = 4.0
            line.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
            line.tappable = true
            line.map = mapView
            
            
            mapView.delegate = self
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            self.view = mapView
        }
        else
        {
            var marker = GMSMarker()
            
            var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(53.902464, longitude:27.561490, zoom:11)
            var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
            
            marker.position = camera.target
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
            
            mapView.selectedMarker = marker
            
            mapView.delegate = self
            
            self.view = mapView
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ChoosePosition()
    {
        var tempMapView: GMSMapView = self.view as! GMSMapView
        
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
    
    func GoBack()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D)
    {
        if(self.path == nil)
        {
            var tempMapView: GMSMapView = self.view as! GMSMapView
            tempMapView.clear()
            
            var marker = GMSMarker(position: coordinate)
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = tempMapView
            
            tempMapView.selectedMarker = marker
        }
    }
        
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D)
    {
        
    }
}
