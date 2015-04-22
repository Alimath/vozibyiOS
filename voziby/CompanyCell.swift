//
//  CompanyCell.swift
//  voziby
//
//  Created by Fedar Trukhan on 17.04.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell
{
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reliabilityLabel: UILabel!
    @IBOutlet weak var reliabilityImageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var minZakazBackground: UIImageView!
    @IBOutlet weak var minZakazHelpLabel: UILabel!
    @IBOutlet weak var minZakaz: UILabel!
    @IBOutlet weak var minZakazWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var za1kmBackground: UIImageView!
    @IBOutlet weak var za1kmHelpLabel: UILabel!
    @IBOutlet weak var za1kmLabel: UILabel!
    @IBOutlet weak var za1kmWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var za1hBackground: UIImageView!
    @IBOutlet weak var za1hHelpLabel: UILabel!
    @IBOutlet weak var za1hLabel: UILabel!
    @IBOutlet weak var za1hWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reliabilityBack: UIImageView!
    
    
}
