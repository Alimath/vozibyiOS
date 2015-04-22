//
//  OrderView.swift
//  voziby
//
//  Created by Fedar Trukhan on 27.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class OrderView: UIViewController, GMSMapViewDelegate, UIScrollViewDelegate
{
    @IBOutlet weak var ImagesView: UIView!
    @IBOutlet weak var imagesViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var imagesScrollViewHeightConstraint: NSLayoutConstraint!
    
    var currentOrder: OrderInfo = OrderInfo()
    var images: [UIImageView] = []
    var imagesActivityIndicators: [UIActivityIndicatorView] = []
    var imagesIndex: Int = 0
    var path: GMSPath = GMSPath()
    var isMapOpened: Bool = false
    var arrowBackImage: UIImageView = UIImageView()
    
    let net = Net(baseUrlString: "http://api.x9.sandbox.hcbogdan.com/")
    @IBOutlet weak var myMapView: GMSMapView!
    @IBOutlet weak var routeDetailsViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var offeredPriceLabel: UILabel!
    @IBOutlet weak var offeredPriceLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var invitedPriceLabel: UILabel!
    @IBOutlet weak var invitedPriceLabelWIdthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var createrName: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var volumeValueLabel: UILabel!
    @IBOutlet weak var volumeTextLabel: UILabel!
    @IBOutlet weak var weightValueLabel: UILabel!
    @IBOutlet weak var weightTextLabel: UILabel!
    @IBOutlet weak var paletteValueLabel: UILabel!
    @IBOutlet weak var paletteTextLabel: UILabel!
    @IBOutlet weak var passengersValueLabel: UILabel!
    @IBOutlet weak var baggageValueLabel: UILabel!
    
    @IBOutlet weak var lengthValue: UILabel!
    @IBOutlet weak var widthValue: UILabel!
    @IBOutlet weak var heightValue: UILabel!
    @IBOutlet weak var CargoDetailScroll: UIScrollView!
    
    
    
    @IBOutlet weak var cargoDetailView: UIView!
    @IBOutlet weak var passengersDetailView: UIView!
    @IBOutlet weak var autoDetailView: UIView!
    
    @IBOutlet weak var auto0Value: UILabel!
    @IBOutlet weak var auto0Label: UILabel!
    @IBOutlet weak var auto21Value: UILabel!
    @IBOutlet weak var auto21Label: UILabel!
    @IBOutlet weak var auto31Value: UILabel!
    @IBOutlet weak var auto31Label: UILabel!
    @IBOutlet weak var auto22Value: UILabel!
    @IBOutlet weak var auto22Label: UILabel!
    @IBOutlet weak var auto32Value: UILabel!
    @IBOutlet weak var auto32Label: UILabel!
    
    
    
    @IBOutlet weak var routeDetailsScroll: UIScrollView!
    @IBOutlet weak var showMapButotn: UIButton!
    @IBOutlet weak var showMapButtonRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var streetFromLabel: UILabel!
    @IBOutlet weak var cityFromLabel: UILabel!
    @IBOutlet weak var countryFromLabel: UILabel!
    @IBOutlet weak var streetToLabel: UILabel!
    @IBOutlet weak var cityToLabel: UILabel!
    @IBOutlet weak var countryToLabel: UILabel!
    @IBOutlet weak var dateFromLabel: UILabel!
    @IBOutlet weak var dateFromLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateToLabel: UILabel!
    @IBOutlet weak var dateToLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateToIconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var routeDetailScrollHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var routeInfoTime: UILabel!
    @IBOutlet weak var routeInfoLength: UILabel!
    @IBOutlet weak var routeInfoView: UIView!
    
    @IBOutlet weak var helpLoadUnloadView: UIView!
    @IBOutlet weak var helpLoadUnloadSeparator: UIImageView!
    @IBOutlet weak var helpUnloadIcon: UIImageView!
    @IBOutlet weak var helpUnloadLabel: UILabel!
    @IBOutlet weak var helpLoadIcon: UIImageView!
    @IBOutlet weak var helpLoadLabel: UILabel!
    @IBOutlet weak var helpLoadTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpLoadUnloadHeitghConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainScrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapOpenImageCenterConstraint: NSLayoutConstraint!
    
    //moneys
    @IBOutlet weak var moneysView: UIView!
    @IBOutlet weak var moneysViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cashIcon: UIImageView!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var nonCashIcon: UIImageView!
    @IBOutlet weak var nonCashLabel: UILabel!
    @IBOutlet weak var nonCashHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardIcon: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardWebpayIcon: UIImageView!
    @IBOutlet weak var cardWebpayLabel: UILabel!
    @IBOutlet weak var cardWebpayHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eMoneyIcon: UIImageView!
    @IBOutlet weak var eMoneyLabel: UILabel!
    @IBOutlet weak var eMoneyHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesShadowHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesShadow: UIImageView!
    
    @IBOutlet weak var ShowDealsButton: UIButton!
    @IBOutlet weak var showHideMapImage: UIImageView!
    
    //важно наличие
    @IBOutlet weak var VazhnoNalichieView: UIView!
    @IBOutlet weak var lebedka: UIView!
    @IBOutlet weak var sdvigPlatform: UIView!
    @IBOutlet weak var sdvigPlatformHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gidromanipulator: UIView!
    @IBOutlet weak var gidromanipulatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var utilizatijamebeli: UIView!
    @IBOutlet weak var utilizatiojamebeliHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gidrolift: UIView!
    @IBOutlet weak var gidroliftHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var zadnjajaPogruzka: UIView!
    @IBOutlet weak var zadnjajaPogruzkaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bokovajaPorgruzka: UIView!
    @IBOutlet weak var bokovajaPogruzkaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gidrotelezhka: UIView!
    @IBOutlet weak var gidroTelezhkaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var televizor: UIView!
    @IBOutlet weak var televizorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var minibar: UIView!
    @IBOutlet weak var minibarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stolik: UIView!
    @IBOutlet weak var stolikHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var regSidenija: UIView!
    @IBOutlet weak var regSidenijaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cooler: UIView!
    @IBOutlet weak var coolerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var VazhnoNalichieHeightConstraint: NSLayoutConstraint!
    
    
    //примечание автомобиль
    @IBOutlet weak var PrimechanieView: UIView!
    @IBOutlet weak var PrimechanieViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var wheelBlocked: UIView!
    @IBOutlet weak var inCuvette: UIView!
    @IBOutlet weak var inCuvetteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var controllBlocked: UIView!
    @IBOutlet weak var controllBlockedHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var divorcedWheel: UIView!
    @IBOutlet weak var divorcedWheelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emergencyState: UIView!
    @IBOutlet weak var emergencyStateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var damagedSuspension: UIView!
    @IBOutlet weak var damagedSuspensionHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        var addressFrom = "\(currentOrder.fromAddress), \(currentOrder.fromStreet), \(currentOrder.fromHouse)"
        var addressTo = "\(currentOrder.toAddress), \(currentOrder.toStreet), \(currentOrder.toHouse)"
        
        if let font = UIFont(name: "Roboto-Regular", size: 16)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "727272")]
        }
        self.navigationItem.title = "Карточка объявления"
        
        
        if(self.isMapOpened == false)
        {
            var camera = GMSCameraPosition.cameraWithLatitude(53.902464,
            longitude:27.561490, zoom:8)
            
            self.myMapView.camera = camera
            let dataProvider = GoogleDataProvider()
            dataProvider.fetchDirectionsFromAddresses(addressFrom, to: addressTo)
            {optionalRoute, disAndDur in
                if let encodedRoute = optionalRoute {

                    var distance = disAndDur[0]
                    var duration = disAndDur[1]
                    
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        var routeTimeArray = split(duration) {$0 == " "}
                        
                        if(routeTimeArray.count > 3)
                        {
                            if(routeTimeArray[1] == "days" || routeTimeArray[1] == "day")
                            {
                                self.routeInfoTime.text = "\(routeTimeArray[0])д \(routeTimeArray[2])ч"
                            }
                            else
                            {
                                self.routeInfoTime.text = "\(routeTimeArray[0])ч \(routeTimeArray[2])мин"
                            }
                        }
                        else
                        {
                            self.routeInfoTime.text = "\(routeTimeArray[0])мин"
                        }
                        
                        distance = distance.removeCharsFromEnd(3)
                        self.routeInfoLength.text = "\(distance) км"
                    }
                    
                    self.path = GMSPath(fromEncodedPath: encodedRoute)
                    
                    self.myMapView.clear()
                    
                    var marker = GMSMarker(position: self.path.coordinateAtIndex(0))
                    marker.appearAnimation = kGMSMarkerAnimationPop
                    marker.icon = UIImage(named: "MarkerA")
                    marker.map = self.myMapView
                    
                    var marker2 = GMSMarker(position: self.path.coordinateAtIndex(self.path.count()-1))
                    marker2.appearAnimation = kGMSMarkerAnimationPop
                    marker2.icon = UIImage(named: "MarkerB")
                    marker2.map = self.myMapView
                    
                    
                    var bounds: GMSCoordinateBounds = GMSCoordinateBounds(path: self.path)
                    var insets: CGFloat = 60
                    self.myMapView.camera = self.myMapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
                    let line = GMSPolyline(path: self.path)
                
                    
                    line.strokeWidth = 4.0
                    line.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
                    line.tappable = true
                    line.map = self.myMapView
                    
                    self.myMapView.selectedMarker = nil
                }
            }
            self.myMapView.delegate = self
        }
        
        
        self.mainScrollViewHeightConstraint.constant = self.moneysView.frame.origin.y + self.moneysViewHeightConstraint.constant + 40
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let font = UIFont(name: "Roboto-Regular", size: 16)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "727272")]
        }
        self.navigationItem.title = "Карточка объявления"
        
        let backButton = UIBarButtonItem(title: "    Назад", style: UIBarButtonItemStyle.Plain, target: self, action: "GoBack")
        if let font = UIFont(name: "Roboto-Regular", size: 13)
        {
            backButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "40a9f4")], forState: UIControlState.Normal)
        }
        navigationItem.leftBarButtonItem = backButton
        backButton.setTitlePositionAdjustment(UIOffsetMake(0, -11), forBarMetrics: UIBarMetrics.Default)
        
        arrowBackImage = UIImageView(frame: CGRectMake(7, 14, 11, 18))
        arrowBackImage.image = UIImage(named: "backArrow")
        self.navigationController?.navigationBar.addSubview(arrowBackImage)
        
        
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "imageLoaded:",
            name:kVZOrderImageLoaded,
            object: nil)

        
        self.routeInfoView.layer.borderColor = UIColor(RGBA: "bebebe").CGColor
        
        self.imagesScrollViewHeightConstraint.constant = self.view.frame.width * 0.75
        self.routeDetailsScroll.backgroundColor = UIColor(RGBA: "f5f5f5")
        
        var i: Int = 0
        for logoPath: String in self.currentOrder.logos
        {
            var imageView: UIImageView = UIImageView(frame: CGRectMake(CGFloat(i) * self.view.frame.width, 0, self.view.frame.width, self.view.frame.width * 0.75))
            imageView.backgroundColor = UIColor(RGBA: "F2F2F2")//UIImage(named: "loadingImage")
            self.ImagesView.addSubview(imageView)
            self.LoadImage(logoPath, index: i)
            self.images.append(imageView)
            i++
        }
        
        if(i > 0)
        {
            self.imagesViewWidthConstraint.constant = self.view.frame.width * CGFloat(i)
            self.imagesShadow.hidden = true
        }
        else
        {
            self.imagesScrollViewHeightConstraint.constant = 108
            self.imagesShadow.hidden = true
        }
        
        
        var numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.groupingSeparator = "."
        
        self.invitedPriceLabel.text = "\(numberFormatter.stringFromNumber(NSNumber(long: self.currentOrder.budgetBYR))!) BYR"
        var testLabel = UILabel(frame: self.invitedPriceLabel.frame)
        testLabel.font = self.invitedPriceLabel.font
        testLabel.text = self.invitedPriceLabel.text
        testLabel.sizeToFit()
        if(testLabel.frame.width > 60)
        {
            self.invitedPriceLabelWIdthConstraint.constant = testLabel.frame.width
        }
        else
        {
            self.invitedPriceLabelWIdthConstraint.constant = 60
        }

        self.offeredPriceLabel.text = "\(numberFormatter.stringFromNumber(NSNumber(long: 500000))!) BYR"
        var testLabel2 = UILabel(frame: self.offeredPriceLabel.frame)
        testLabel2.font = self.offeredPriceLabel.font
        testLabel2.text = self.offeredPriceLabel.text
        testLabel2.sizeToFit()
        if(testLabel2.frame.width > 80)
        {
            self.offeredPriceLabelWidthConstraint.constant = testLabel2.frame.width
        }
        else
        {
            self.offeredPriceLabelWidthConstraint.constant = 80
        }
        
        if(self.currentOrder.transportType == TransportType.Evacuator)
        {
            self.descriptionLabel.text = self.currentOrder.autoDescription
        }
        else
        {
            self.descriptionLabel.text = self.currentOrder.goodName
        }
        var testLabel3 = UILabel(frame: CGRectMake(0, 0, self.descriptionLabel.frame.width, 800))
        testLabel3.text = self.descriptionLabel.text
        testLabel3.font = self.descriptionLabel.font
        testLabel3.lineBreakMode = NSLineBreakMode.ByWordWrapping
        testLabel3.numberOfLines = 0
        testLabel3.sizeToFit()
        
        self.descriptionLabelHeightConstraint.constant = testLabel3.frame.height
        if(testLabel3.frame.height < 30)
        {
            self.descriptionLabel.textAlignment = NSTextAlignment.Center
        }
        
        if(self.descriptionLabel.text == "")
        {
            self.descriptionTopConstraint.constant = 0
        }
        
        
        if(self.currentOrder.transportType == TransportType.Goods || self.currentOrder.transportType == TransportType.Furniture)
        {
            var volume = (self.currentOrder.width) * (self.currentOrder.length) * (self.currentOrder.height)
            
            
            var numberFormatter: NSNumberFormatter = NSNumberFormatter()
            numberFormatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            numberFormatter.groupingSeparator = "."
            numberFormatter.decimalSeparator = ","
            
            
            self.lengthValue.text = numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.0f", self.currentOrder.length).floatValue))
            self.widthValue.text = numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.0f", self.currentOrder.width).floatValue))
            self.heightValue.text = numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.0f", self.currentOrder.height).floatValue))
            
            if(volume < 1000)
            {
                self.volumeTextLabel.text = "Объём, см"
                self.volumeValueLabel.text = numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.0f", volume).floatValue))
            }
            else
            {
                volume = (self.currentOrder.width/100.0) * (self.currentOrder.length/100.0) * (self.currentOrder.height/100.0)
            
                if(volume < 100)
                {
                    let checkFloatStringVolume = NSString(format: "%.02f", volume)
                    if(checkFloatStringVolume.hasSuffix(".00"))
                    {
                        self.volumeValueLabel.text = numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.0f", volume).floatValue))
                    }
                    else
                    {
                        if(checkFloatStringVolume.hasSuffix("0"))
                        {
                            self.volumeValueLabel.text = numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.01f", volume).floatValue))
                        }
                        else
                        {
                            
                            self.volumeValueLabel.text = numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.02f", volume).floatValue))
                        }
                    }
                }
                else if(volume < 1000)
                {
                    let checkFloatStringVolume = NSString(format: "%.01f", volume)
                    if(checkFloatStringVolume.hasSuffix(".0"))
                    {
                        self.volumeValueLabel.text =  numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.0f", volume).floatValue))
                    }
                    else
                    {
                        self.volumeValueLabel.text = numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.01f", volume).floatValue))
                    }
                }
                else
                {
                    self.volumeValueLabel.text =  numberFormatter.stringFromNumber(NSNumber(float: NSString(format: "%.0f", volume).floatValue))
                }
            }
            self.volumeTextLabel.sizeToFit()
            
            let checkFloatStringWeight = NSString(format: "%.01f", self.currentOrder.weight)
            if(checkFloatStringWeight.hasSuffix(".0"))
            {
                self.weightValueLabel.text = NSString(format: "%.0f", self.currentOrder.weight) as String
            }
            else
            {
                self.weightValueLabel.text = checkFloatStringWeight as String
            }
            
            self.cargoDetailView.hidden = false
            self.CargoDetailScroll.hidden = false
            self.passengersDetailView.hidden = true
            self.autoDetailView.hidden = true
        }
        else if(self.currentOrder.transportType == TransportType.Passangers)
        {
            self.descriptionLabelHeightConstraint.constant = 0
            
            self.cargoDetailView.hidden = true
            self.CargoDetailScroll.hidden = true
            self.CargoDetailScroll.userInteractionEnabled = false
            self.autoDetailView.hidden = true
            self.passengersDetailView.hidden = false
            
            self.passengersValueLabel.text = "\(self.currentOrder.passagersCount)"
            
            let checkFloatString = NSString(format: "%.01f", self.currentOrder.baggage)
            if(checkFloatString.hasSuffix(".0"))
            {
                self.baggageValueLabel.text = NSString(format: "%.00f", self.currentOrder.baggage) as String
            }
            else
            {
                self.baggageValueLabel.text = NSString(format: "%.01f", self.currentOrder.baggage) as String
            }
        }
        else if(self.currentOrder.transportType == TransportType.Evacuator)
        {
            self.autoDetailView.hidden = false
            self.cargoDetailView.hidden = true
            self.CargoDetailScroll.hidden = true
            self.CargoDetailScroll.userInteractionEnabled = false
            self.passengersDetailView.hidden = true
            
            var autoTypeCountAndCost: [AutoType:[Int]] = [AutoType.Passenger:[0,0], AutoType.Special:[0,0], AutoType.Jeep:[0,0], AutoType.Limousine:[0,0], AutoType.Microbus:[0,0], AutoType.Minivan:[0,0], AutoType.Moto:[0,0]]
            
            for autoItem in self.currentOrder.autoDataList
            {
                if let category = autoTypeCountAndCost.indexForKey(autoItem.category)
                {
                    autoTypeCountAndCost.updateValue([autoTypeCountAndCost[autoTypeCountAndCost.indexForKey(autoItem.category)!].1[0]+1, autoTypeCountAndCost[autoTypeCountAndCost.indexForKey(autoItem.category)!].1[1]+autoItem.cost], forKey: autoItem.category)
                }
                else
                {
                    println("undefined category: \(autoItem.category.rawValue)")
                }
            }
            
            var cleanAutoTypeCountAndCost:[AutoType:[Int]] = [AutoType:[Int]]()
            
            for autoTypeCountItem in autoTypeCountAndCost
            {
                if(autoTypeCountItem.1[0] != 0)
                {
                    cleanAutoTypeCountAndCost.updateValue([autoTypeCountItem.1[0],autoTypeCountItem.1[1]], forKey: autoTypeCountItem.0)
                }
            }
            
            if(cleanAutoTypeCountAndCost.count == 1 || cleanAutoTypeCountAndCost.count == 3)
            {
                auto0Label.hidden = false
                auto0Value.hidden = false
                
                var categoryCount: Int = cleanAutoTypeCountAndCost.values.array[0][0]
                var categoryCost: Int = cleanAutoTypeCountAndCost.values.array[0][1]
                var categoryName: String = AutoTypeToStringWithCount(cleanAutoTypeCountAndCost.keys.array[0], categoryCount)
                
                auto0Value.text = "\(numberFormatter.stringFromNumber(categoryCost)!)$"
                auto0Label.text = "\(categoryName)"
                
            }
            if(cleanAutoTypeCountAndCost.count == 2)
            {
                auto21Label.hidden = false
                auto21Value.hidden = false
                auto22Label.hidden = false
                auto22Value.hidden = false
                
                var categoryCount: Int = cleanAutoTypeCountAndCost.values.array[0][0]
                var categoryCost: Int = cleanAutoTypeCountAndCost.values.array[0][1]
                var categoryName: String = AutoTypeToStringWithCount(cleanAutoTypeCountAndCost.keys.array[0], categoryCount)
                
                auto21Value.text = "\(numberFormatter.stringFromNumber(categoryCost)!)$"
                auto21Label.text = "\(categoryName)"
                
                categoryCount = cleanAutoTypeCountAndCost.values.array[1][0]
                categoryCost = cleanAutoTypeCountAndCost.values.array[1][1]
                categoryName = AutoTypeToStringWithCount(cleanAutoTypeCountAndCost.keys.array[1], categoryCount)
                
                auto22Value.text = "\(numberFormatter.stringFromNumber(categoryCost)!)$"
                auto22Label.text = "\(categoryName)"
            }
            if(cleanAutoTypeCountAndCost.count == 3)
            {
                auto31Label.hidden = false
                auto31Value.hidden = false
                auto32Label.hidden = false
                auto32Value.hidden = false
                
                var categoryCount: Int = cleanAutoTypeCountAndCost.values.array[1][0]
                var categoryCost: Int = cleanAutoTypeCountAndCost.values.array[1][1]
                var categoryName: String = AutoTypeToStringWithCount(cleanAutoTypeCountAndCost.keys.array[1], categoryCount)
                
                auto31Value.text = "\(numberFormatter.stringFromNumber(categoryCost)!)$"
                auto31Label.text = "\(categoryName)"
                
                categoryCount = cleanAutoTypeCountAndCost.values.array[2][0]
                categoryCost = cleanAutoTypeCountAndCost.values.array[2][1]
                categoryName = AutoTypeToStringWithCount(cleanAutoTypeCountAndCost.keys.array[2], categoryCount)
                
                auto32Value.text = "\(numberFormatter.stringFromNumber(categoryCost)!)$"
                auto32Label.text = "\(categoryName)"
            }
            
        }
        
        
        
        var addresArray = split(self.currentOrder.fromAddress) {$0 == ","}
        
        var countryFrom: String = ""
        var cityFrom: String = ""
        if(addresArray[0] as String == "Россия")
        {
            cityFrom = addresArray[addresArray.count-1]
            addresArray = addresArray.reverse()
            for otherString in addresArray[1...addresArray.count-1]
            {
                countryFrom = "\(countryFrom), \(otherString)"
            }
        }
        else
        {
            cityFrom = addresArray[0]
            for otherString in addresArray[1...addresArray.count-1]
            {
                countryFrom = "\(countryFrom), \(otherString)"
            }
        }
        
        let punctuationCharacterSet = NSCharacterSet.punctuationCharacterSet()
        let spaceSet = NSCharacterSet.whitespaceCharacterSet()
        
        countryFrom = countryFrom.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch).stringByTrimmingCharactersInSet(punctuationCharacterSet).stringByTrimmingCharactersInSet(spaceSet)
        cityFrom = cityFrom.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch).stringByTrimmingCharactersInSet(punctuationCharacterSet).stringByTrimmingCharactersInSet(spaceSet)
        

        
        
        
        addresArray = split(self.currentOrder.toAddress) {$0 == ","}
        
        var cityTo = ""
        var countryTo = ""
        if(addresArray[0] as String == "Россия")
        {
            cityTo = addresArray[addresArray.count-1]
            addresArray = addresArray.reverse()
            for otherString in addresArray[1...addresArray.count-1]
            {
                countryTo = "\(countryTo), \(otherString)"
            }
        }
        else
        {
            cityTo = addresArray[0]
            for otherString in addresArray[1...addresArray.count-1]
            {
                countryTo = "\(countryTo), \(otherString)"
            }
        }
        
        countryTo = countryTo.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch).stringByTrimmingCharactersInSet(punctuationCharacterSet).stringByTrimmingCharactersInSet(spaceSet)
        cityTo = cityTo.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch).stringByTrimmingCharactersInSet(punctuationCharacterSet).stringByTrimmingCharactersInSet(spaceSet)
        
        
        
        
        if(cityFrom == cityTo)
        {
            if(self.currentOrder.fromStreet != "")
            {
                self.streetFromLabel.text = "\(self.currentOrder.fromStreet), \(self.currentOrder.fromHouse)"
                self.cityFromLabel.text = "\(cityFrom),"
                self.countryFromLabel.text = "\(countryFrom)"
            }
            else
            {
                self.streetFromLabel.text = "\(cityFrom),"
                self.cityFromLabel.text = "\(countryFrom)"
                self.countryFromLabel.text = ""
            }
            
            if(self.currentOrder.toStreet != "")
            {
                self.streetToLabel.text = "\(self.currentOrder.toStreet), \(self.currentOrder.toHouse)"
                self.cityToLabel.text = "\(cityTo),"
                self.countryToLabel.text = "\(countryTo)"
            }
            else
            {
                self.streetToLabel.text = "\(cityTo),"
                self.cityToLabel.text = "\(countryTo)"
                self.countryToLabel.text = ""
            }
        }
        else
        {
            self.streetFromLabel.text = "\(cityFrom),"
            self.cityFromLabel.text = "\(countryFrom)"
            if(self.currentOrder.fromStreet != "")
            {
                self.countryFromLabel.text = "\(self.currentOrder.fromStreet), \(self.currentOrder.fromHouse)"
            }
            else
            {
                self.countryFromLabel.text = ""
            }

            self.streetToLabel.text = "\(cityTo),"
            self.cityToLabel.text = "\(countryTo)"
            if(self.currentOrder.toStreet != "")
            {
                self.countryToLabel.text = "\(self.currentOrder.toStreet), \(self.currentOrder.toHouse)"
            }
            else
            {
                self.countryToLabel.text = ""
            }
        }
        
        
        self.dateFromLabel.attributedText = self.dateArrayToAttributedStringSequence(self.currentOrder.fromDate)
        var testLabel4 = UILabel(frame: CGRectMake(0, 0, self.dateFromLabel.frame.width, 8000))
        testLabel4.attributedText = self.dateFromLabel.attributedText
        testLabel4.lineBreakMode = NSLineBreakMode.ByWordWrapping
        testLabel4.numberOfLines = 0
        testLabel4.sizeToFit()
        self.dateFromLabelHeightConstraint.constant = testLabel4.frame.height
        self.dateToIconTopConstraint.constant = (testLabel4.frame.height > 70) ? testLabel4.frame.height+20 : 70
        
        self.dateToLabel.attributedText = self.dateArrayToAttributedStringSequence(self.currentOrder.toDate)
        var testLabel5 = UILabel(frame: CGRectMake(0, 0, self.dateToLabel.frame.width, 8000))
        testLabel5.attributedText = self.dateToLabel.attributedText
        testLabel5.lineBreakMode = NSLineBreakMode.ByWordWrapping
        testLabel5.numberOfLines = 0
        testLabel5.sizeToFit()
        self.dateToLabelHeightConstraint.constant = testLabel5.frame.height
        
//        if(self.dateFromLabel.text != "" || self.dateToLabel.text != "")
//        {
        self.routeDetailScrollHeightConstraint.constant = self.dateFromLabel.frame.origin.y + self.dateToIconTopConstraint.constant + max(testLabel5.frame.height, 30) + 10
//        }
//        else
//        {
//            self.routeDetailScrollHeightConstraint.constant = 170
//        }
        
        
        
        
        if(self.currentOrder.helpLoad == false && self.currentOrder.helpUnload == false)
        {
            self.helpLoadUnloadHeitghConstraint.constant = 0
            
            self.helpUnloadIcon.hidden = true
            self.helpUnloadLabel.hidden = true
            self.helpLoadIcon.hidden = true
            self.helpLoadLabel.hidden = true
            self.helpLoadUnloadSeparator.hidden = true
            
            self.helpLoadUnloadView.hidden = true
        }
        else
        {
            if(self.currentOrder.helpUnload == false)
            {
                self.helpUnloadIcon.hidden = true
                self.helpUnloadLabel.hidden = true
                
                self.helpLoadTopConstraint.constant = 0
                self.helpLoadUnloadHeitghConstraint.constant = 110
            }
            else if(self.currentOrder.helpLoad == false)
            {
                self.helpLoadIcon.hidden = true
                self.helpLoadLabel.hidden = true
                
                self.helpLoadTopConstraint.constant = 0
                self.helpLoadUnloadHeitghConstraint.constant = 110
            }
        }
        
        var paymentsCount: Int = 5
        if(self.currentOrder.cashPayment == false)
        {
            paymentsCount--
            self.cashIcon.hidden = true
            self.cashLabel.hidden = true
            
            self.nonCashHeightConstraint.constant = 0
        }
        if(self.currentOrder.nocashPayment == false)
        {
            paymentsCount--
            self.nonCashIcon.hidden = true
            self.nonCashLabel.hidden = true
            
            self.cardHeightConstraint.constant = 0
        }
        if(self.currentOrder.cardPayment == false)
        {
            paymentsCount--
            self.cardIcon.hidden = true
            self.cardLabel.hidden = true
            
            self.cardWebpayHeightConstraint.constant = 0
        }
        if(self.currentOrder.webpayPayment == false)
        {
            paymentsCount--
            self.cardWebpayIcon.hidden = true
            self.cardWebpayLabel.hidden = true
            
            self.eMoneyHeightConstraint.constant = 0
        }
        if(self.currentOrder.onlinePayment == false)
        {
            paymentsCount--
            self.eMoneyIcon.hidden = true
            self.eMoneyLabel.hidden = true
        }
        
        var optionsCount: Int = 13
        if(self.currentOrder.winch == false)
        {
            optionsCount--
            self.lebedka.hidden = true
            self.sdvigPlatformHeightConstraint.constant = 0
        }
        if(self.currentOrder.slidingPlatform == false)
        {
            optionsCount--
            self.sdvigPlatform.hidden = true
            self.gidromanipulatorHeightConstraint.constant = 0
        }
        if(self.currentOrder.gidroManipulator == false)
        {
            optionsCount--
            self.gidromanipulator.hidden = true
            self.utilizatiojamebeliHeightConstraint.constant = 0
        }
        if(self.currentOrder.furnitureUtilization == false)
        {
            optionsCount--
            self.utilizatijamebeli.hidden = true
            self.gidroliftHeightConstraint.constant = 0
        }
        if(self.currentOrder.gidrolift == false)
        {
            optionsCount--
            self.gidrolift.hidden = true
            self.zadnjajaPogruzkaHeightConstraint.constant = 0
        }
        if(self.currentOrder.backLoading == false)
        {
            optionsCount--
            self.zadnjajaPogruzka.hidden = true
            self.bokovajaPogruzkaHeightConstraint.constant = 0
        }
        if(self.currentOrder.sideLoading == false)
        {
            optionsCount--
            self.bokovajaPorgruzka.hidden = true
            self.gidroTelezhkaHeightConstraint.constant = 0
        }
        if(self.currentOrder.gidroCart == false)
        {
            optionsCount--
            self.gidrotelezhka.hidden = true
            self.televizorHeightConstraint.constant = 0
        }
        if(self.currentOrder.tv == false)
        {
            optionsCount--
            self.televizor.hidden = true
            self.minibarHeightConstraint.constant = 0
        }
        if(self.currentOrder.miniBar == false)
        {
            optionsCount--
            self.minibar.hidden = true
            self.stolikHeightConstraint.constant = 0
        }
        if(self.currentOrder.table == false)
        {
            optionsCount--
            self.stolik.hidden = true
            self.regSidenijaHeightConstraint.constant = 0
        }
        if(self.currentOrder.adjustableSeats == false)
        {
            optionsCount--
            self.regSidenija.hidden = true
            self.coolerHeightConstraint.constant = 0
        }
        if(self.currentOrder.cooler == false)
        {
            optionsCount--
            self.cooler.hidden = true
        }
        
        
        var primechanieCount = 6
        if(self.currentOrder.blockTheWheel == false)
        {
            primechanieCount--
            self.wheelBlocked.hidden = true
            self.inCuvetteHeightConstraint.constant = 0
        }
        if(self.currentOrder.inCuvette == false)
        {
            primechanieCount--
            self.inCuvette.hidden = true
            self.controllBlockedHeightConstraint.constant = 0
        }
        if(self.currentOrder.blockControl == false)
        {
            primechanieCount--
            self.controllBlocked.hidden = true
            self.divorcedWheelHeightConstraint.constant = 0
        }
        if(self.currentOrder.divorcedWheel == false)
        {
            primechanieCount--
            self.divorcedWheel.hidden = true
            self.emergencyStateHeightConstraint.constant = 0
        }
        if(self.currentOrder.emergencyState == false)
        {
            primechanieCount--
            self.emergencyState.hidden = true
            self.damagedSuspensionHeightConstraint.constant = 0
        }
        if(self.currentOrder.damagedSuspension == false)
        {
            primechanieCount--
            self.damagedSuspension.hidden = true
        }
        
        
        self.view.layoutSubviews()
        
        if(primechanieCount == 0)
        {
            self.PrimechanieView.hidden = true
            self.PrimechanieViewHeightConstraint.constant = 0
        }
        else
        {
            self.PrimechanieViewHeightConstraint.constant = self.wheelBlocked.frame.origin.y + CGFloat(primechanieCount)*CGFloat(30) + CGFloat(15)
        }
        
        if(optionsCount == 0)
        {
            self.VazhnoNalichieView.hidden = true
            self.VazhnoNalichieHeightConstraint.constant = 0
        }
        else
        {
            self.VazhnoNalichieHeightConstraint.constant = self.lebedka.frame.origin.y + CGFloat(optionsCount)*CGFloat(30) + CGFloat(15)
        }
        
        if(paymentsCount == 0)
        {
            self.moneysViewHeightConstraint.constant = 0
        }
        else
        {
            self.moneysViewHeightConstraint.constant = self.cashIcon.frame.origin.y + CGFloat(paymentsCount)*CGFloat(30) + CGFloat(15)
        }
        
        let logoFullPath = DocumentsPathForFileName(kVZLogoFileNameKey)
        let logoImageData = NSData(contentsOfFile: logoFullPath)
        let logoImage = UIImage(data: logoImageData!)
        self.avatarImage.image = logoImage
        
        var userInfo: UserInfo = GetUserInfo()
        self.createrName.text = userInfo.personName
        self.showMapButotn.imageView?.contentMode = UIViewContentMode.ScaleToFill
        
        if(self.currentOrder.offers.count > 0)
        {
            self.ShowDealsButton.setTitle("Просмотреть ставки (\(self.currentOrder.offers.count))", forState: UIControlState.Normal)
        }
        else
        {
            self.ShowDealsButton.setTitle("Нет предложений", forState: UIControlState.Normal)
        }
        
        self.routeDetailsViewWidthConstraint.constant = self.view.frame.width * 2
        
        self.imagesShadowHeightConstraint.constant = self.imagesScrollView.frame.width * 0.27222
        self.ImagesView.bringSubviewToFront(self.imagesShadow)
    }
    
    func LoadImage(url: String, index: Int)
    {
        var logo: UIImage = UIImage()
        
        Server.sharedInstance.loadCookies()
        
        net.GET(url, params: nil, successHandler: { (responseData) -> () in
            var error: NSErrorPointer = nil
            var image = responseData.image(error: error)!
            
            NSOperationQueue.mainQueue().addOperationWithBlock
            {
                self.images[index].image = image//, targetSize: CGSize(width: self.imagesScrollView.frame.width, height: self.imagesScrollView.frame.width * 0.75))
                self.images[index].contentMode = UIViewContentMode.ScaleAspectFill
                self.images[index].clipsToBounds = true
            }
            
            }) { (error) -> () in
                println("error")
        }
        
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
//        image.contentMode = UIViewContentMode.ScaleAspectFill
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func RBSquareImage(image: UIImage) -> UIImage
    {
        var originalWidth  = image.size.width
        var originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight
        {
            edge = originalHeight
        }
        else
        {
            edge = originalWidth
        }
        
        var posX = (originalWidth  - edge) / 2.0
        var posY = (originalHeight/0.75 - edge*0.75) / 2.0
        
        var cropSquare = CGRectMake(posX, posY, edge, edge*0.75)
        
        var imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)!
    }
    
    
    func respondToScrollSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.Left:
                var point: CGPoint = self.imagesScrollView.contentOffset
                imagesIndex++
                imagesIndex = min(imagesIndex, self.images.count-1)
                point.x = CGFloat(imagesIndex) * self.view.frame.width
                self.imagesScrollView.setContentOffset(point, animated: true)
                
            case UISwipeGestureRecognizerDirection.Right:
                var point: CGPoint = self.imagesScrollView.contentOffset
                imagesIndex--
                imagesIndex = max(imagesIndex, 0)
                point.x = CGFloat(imagesIndex) * self.view.frame.width
                self.imagesScrollView.setContentOffset(point, animated: true)
                
            default:
                break
            }
        }
    }
    
    func respondToMapScrollSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.Left:
                if(self.routeDetailsScroll.contentOffset.x < 10)
                {
                    self.routeDetailsScroll.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
                    self.showMapButtonRightConstraint.constant = -self.view.frame.width + 40
                    self.showHideMapImage.image = UIImage(named: "closeMapArrow")
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.view.layoutIfNeeded()
                    })
                }
                
            case UISwipeGestureRecognizerDirection.Right:
                if(self.routeDetailsScroll.contentOffset.x > 10)
                {
                    self.routeDetailsScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.showMapButtonRightConstraint.constant = 0
                    self.showHideMapImage.image = UIImage(named: "openMapArrow")
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.view.layoutIfNeeded()
                    })
                }
                
            default:
                break
            }
        }
    }
    
    func respondToCargoDetailScrollSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.Left:
                if(self.CargoDetailScroll.contentOffset.x < 10)
                {
                    self.CargoDetailScroll.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
                }
                
            case UISwipeGestureRecognizerDirection.Right:
                if(self.CargoDetailScroll.contentOffset.x > 10)
                {
                    self.CargoDetailScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
                
            default:
                break
            }
        }
    }
    
    @IBAction func ChangeCargoDetailInfo(sender: AnyObject)
    {
        if(self.CargoDetailScroll.contentOffset.x < 10)
        {
            self.CargoDetailScroll.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
        }
        else
        {
            self.CargoDetailScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    
    @IBAction func ShowHideMap(sender: AnyObject)
    {
        if(self.routeDetailsScroll.contentOffset.x < 10)
        {
            self.routeDetailsScroll.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
            self.showMapButtonRightConstraint.constant = -self.view.frame.width + 40
            self.showHideMapImage.image = UIImage(named: "closeMapArrow")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        else
        {
            self.routeDetailsScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.showMapButtonRightConstraint.constant = 0
            self.showHideMapImage.image = UIImage(named: "openMapArrow")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func ShowDeals(sender: AnyObject)
    {
        
    }
    
    func dateArrayToAttributedStringSequence(dates: [NSDate]) -> NSMutableAttributedString
    {
        var intervalLength = 1
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        let dateDayFormatter = NSDateFormatter()
        dateDayFormatter.dateFormat = "eee"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateDayFormatter.locale = NSLocale(localeIdentifier: "ru-ru")
        
        var attributedString: NSMutableAttributedString = NSMutableAttributedString()
        
        
        if(dates.count > 0)
        {
            var beginLineDate: NSDate = dates[0]
            var endLineDate: NSDate = dates[dates.count-1]
            
            var datesSeparatorAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: " - ", attributes: [NSFontAttributeName:UIFont(name: "Roboto-Light", size: 16.0)!])
            var datesEndStringAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\n", attributes: [NSFontAttributeName:UIFont(name: "Roboto-Light", size: 16.0)!])
            
            var datesAttributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(dateDayFormatter.stringFromDate(beginLineDate)) \(dateFormatter.stringFromDate(beginLineDate))", attributes: [NSFontAttributeName:UIFont(name: "Roboto-Light", size: 16.0)!])
            datesAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Roboto-Medium", size: 16)!, range: NSRange(location: 0, length: dateDayFormatter.stringFromDate(beginLineDate).length()))
            
            if(dates.count != 1)
            {
                for fromDateItem in dates
                {
                    if(beginLineDate == fromDateItem.dateByAddingTimeInterval(-86400) || beginLineDate == fromDateItem)
                    {
                        if(beginLineDate != fromDateItem)
                        {
                            intervalLength++
                        }
                        beginLineDate = fromDateItem
                    }
                    else
                    {
                        if(intervalLength > 1)
                        {
                            var tempAttributedString = NSMutableAttributedString(string: "\(dateDayFormatter.stringFromDate(beginLineDate)) \(dateFormatter.stringFromDate(beginLineDate))", attributes: [NSFontAttributeName:UIFont(name: "Roboto-Light", size: 16.0)!])
                            tempAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Roboto-Medium", size: 16)!, range: NSRange(location: 0, length: dateDayFormatter.stringFromDate(beginLineDate).length()))
                            
                            datesAttributedString.appendAttributedString(datesSeparatorAttributedString)
                            datesAttributedString.appendAttributedString(tempAttributedString)
                            datesAttributedString.appendAttributedString(datesEndStringAttributedString)
                        }
                        else
                        {
                            datesAttributedString.appendAttributedString(datesEndStringAttributedString)
                        }
                        var tempAttributedString = NSMutableAttributedString(string: "\(dateDayFormatter.stringFromDate(fromDateItem)) \(dateFormatter.stringFromDate(fromDateItem))", attributes: [NSFontAttributeName:UIFont(name: "Roboto-Light", size: 16.0)!])
                        tempAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Roboto-Medium", size: 16)!, range: NSRange(location: 0, length: dateDayFormatter.stringFromDate(fromDateItem).length()))
                        
                        datesAttributedString.appendAttributedString(tempAttributedString)
                        
                        beginLineDate = fromDateItem
                        intervalLength = 1
                    }
                    
                    if(beginLineDate == endLineDate)
                    {
                        if(intervalLength > 1)
                        {
                            var tempAttributedString = NSMutableAttributedString(string: "\(dateDayFormatter.stringFromDate(beginLineDate)) \(dateFormatter.stringFromDate(beginLineDate))", attributes: [NSFontAttributeName:UIFont(name: "Roboto-Light", size: 16.0)!])
                            tempAttributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Roboto-Medium", size: 16)!, range: NSRange(location: 0, length: dateDayFormatter.stringFromDate(beginLineDate).length()))
                            
                            datesAttributedString.appendAttributedString(datesSeparatorAttributedString)
                            datesAttributedString.appendAttributedString(tempAttributedString)
                        }
                    }
                }
            }
            attributedString = datesAttributedString
        }
        
        return attributedString
    }
    
    @IBAction func openMapView(sender: AnyObject)
    {
        let bigMapView: VZMapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VZMap") as! VZMapViewController
        bigMapView.path = self.path
        self.isMapOpened = true
        self.navigationController?.pushViewController(bigMapView, animated: true)
        self.ShowHideMap(self.showMapButotn)
        self.mapOpenImageCenterConstraint.constant = 20
    }
    
    func GoBack()
    {
        self.arrowBackImage.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        if(scrollView.tag == 98)
        {
            if(scrollView.contentOffset.x > 200)
            {
                self.mapOpenImageCenterConstraint.constant = -20
            }
            else
            {
                self.mapOpenImageCenterConstraint.constant = 20
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
//    {
//        if(scrollView.tag == 99 || scrollView.tag == 98)
//        {
//            if(velocity.x != 0)
//            {
//                if(velocity.x > 0)
//                {
//                    targetContentOffset.memory.x = self.view.frame.width
//                    if(scrollView.tag == 98)
//                    {
//                        self.routeDetailsScroll.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
//                        self.showMapButtonRightConstraint.constant = -self.view.frame.width + 40
//                        self.showHideMapImage.image = UIImage(named: "closeMapArrow")
//                        UIView.animateWithDuration(0.3, animations: { () -> Void in
//                            self.view.layoutIfNeeded()
//                        })
//                    }
//                }
//                else
//                {
//                    targetContentOffset.memory.x = 0
//                    if(scrollView.tag == 98)
//                    {
//                        self.routeDetailsScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//                        self.showMapButtonRightConstraint.constant = 0
//                        self.showHideMapImage.image = UIImage(named: "openMapArrow")
//                        UIView.animateWithDuration(0.3, animations: { () -> Void in
//                            self.view.layoutIfNeeded()
//                        })
//                    }
//                }
//            }
//            else
//            {
//                if(scrollView.contentOffset.x > self.view.frame.width/2)
//                {
//                    scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
//                    if(scrollView.tag == 98)
//                    {
//                        self.routeDetailsScroll.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
//                        self.showMapButtonRightConstraint.constant = -self.view.frame.width + 40
//                        self.showHideMapImage.image = UIImage(named: "closeMapArrow")
//                        UIView.animateWithDuration(0.3, animations: { () -> Void in
//                            self.view.layoutIfNeeded()
//                        })
//                    }
//                }
//                else
//                {
//                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//                    if(scrollView.tag == 98)
//                    {
//                        self.routeDetailsScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//                        self.showMapButtonRightConstraint.constant = 0
//                        self.showHideMapImage.image = UIImage(named: "openMapArrow")
//                        UIView.animateWithDuration(0.3, animations: { () -> Void in
//                            self.view.layoutIfNeeded()
//                        })
//                    }
//                }
//            }
//        }
    
//    }
}

















