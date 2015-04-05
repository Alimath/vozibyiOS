//
//  SearchFiltersView.swift
//  voziby
//
//  Created by Fedar Trukhan on 02.04.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class SearchFiltersView: UIViewController
{
    //Cargo Type elements
    @IBOutlet weak var imageCargoIcon: UIImageView!
    @IBOutlet weak var imagePassengersIcon: UIImageView!
    
    @IBOutlet weak var CargoView: UIView!
    @IBOutlet weak var PassengersView: UIView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    
    
    
    // MARK:
    // MARK: UI Actions
    @IBAction func SelectCargo(sender: AnyObject)
    {
        imageCargoIcon.image = UIImage(named: "searchCargoTypeIconSelected")
        imagePassengersIcon.image = UIImage(named: "searchPassangerTypeUnselected")

        UIView.animateWithDuration(0.2,
        animations:{
            self.CargoView.alpha = 1
            self.PassengersView.alpha = 0
        },
        completion: { (value: Bool) in
            self.CargoView.hidden = false
            self.PassengersView.hidden = true
        })
    }
    
    @IBAction func SelectPassangers(sender: AnyObject)
    {
        imageCargoIcon.image = UIImage(named: "searchCargoTypeIconUnselected")
        imagePassengersIcon.image = UIImage(named: "searchPassangerTypeSelected")
        
        UIView.animateWithDuration(0.2,
        animations:{
            self.CargoView.alpha = 0
            self.PassengersView.alpha = 1
        },
        completion: { (value: Bool) in
            self.CargoView.hidden = true
            self.PassengersView.hidden = false
        })
    }
}
