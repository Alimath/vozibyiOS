//
//  OrderView.swift
//  voziby
//
//  Created by Fedar Trukhan on 27.03.15.
//  Copyright (c) 2015 Novum Studium. All rights reserved.
//

import UIKit

class OrderView: UIViewController, GMSMapViewDelegate
{
    @IBOutlet weak var ImagesView: UIView!
    @IBOutlet weak var imagesViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var imagesScrollViewHeightConstraint: NSLayoutConstraint!
    
    var currentOrder: OrderInfo = OrderInfo()
    var images: [UIImageView] = []
    var imagesActivityIndicators: [UIActivityIndicatorView] = []
    var imagesIndex: Int = 0
    
    let net = Net(baseUrlString: "http://api.x9.sandbox.hcbogdan.com/")
    @IBOutlet weak var myMapView: GMSMapView!
    @IBOutlet weak var invitedPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionSeparatorImage: UIImageView!
    @IBOutlet weak var volumeDescription: UILabel!
    @IBOutlet weak var weightDescription: UILabel!
    @IBOutlet weak var volumeIcon: UIImageView!
    @IBOutlet weak var weightIcon: UIImageView!
    @IBOutlet weak var routeDetailsScroll: UIScrollView!
    @IBOutlet weak var showMapButtonRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var streetFromLabel: UILabel!
    @IBOutlet weak var cityFromLabel: UILabel!
    @IBOutlet weak var countryFromLabel: UILabel!
    @IBOutlet weak var streetToLabel: UILabel!
    @IBOutlet weak var cityToLabel: UILabel!
    @IBOutlet weak var countryToLabel: UILabel!
    @IBOutlet weak var dateFromLabel: UILabel!
    @IBOutlet weak var dateToLabel: UILabel!
    
    @IBOutlet weak var helpUnloadIcon: UIImageView!
    @IBOutlet weak var helpUnloadLabel: UILabel!
    @IBOutlet weak var helpLoadIcon: UIImageView!
    @IBOutlet weak var helpLoadLabel: UILabel!
    @IBOutlet weak var helpLoadTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var helpLoadUnloadHeitghConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainScrollViewHeightConstraint: NSLayoutConstraint!
    
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
    
    @IBOutlet weak var ShowDealsButton: UIButton!
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        
        var camera = GMSCameraPosition.cameraWithLatitude(53.902464,
            longitude:27.561490, zoom:8)
        
        self.myMapView.camera = camera
        
        var addressFrom = "\(currentOrder.fromAddress), \(currentOrder.fromStreet), \(currentOrder.fromHouse)"
        var addressTo = "\(currentOrder.toAddress), \(currentOrder.toStreet), \(currentOrder.toHouse)"
        
        
        let dataProvider = GoogleDataProvider()
        dataProvider.fetchDirectionsFromAddresses(addressFrom, to: addressTo)
        {optionalRoute in
            if let encodedRoute = optionalRoute {

                let path = GMSPath(fromEncodedPath: encodedRoute)
                
                var marker = GMSMarker(position: path.coordinateAtIndex(0))
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.icon = UIImage(named: "MarkerA")
                marker.map = self.myMapView
                
                var marker2 = GMSMarker(position: path.coordinateAtIndex(path.count()-1))
                marker2.appearAnimation = kGMSMarkerAnimationPop
                marker2.icon = UIImage(named: "MarkerB")
                marker2.map = self.myMapView
                
                var bounds: GMSCoordinateBounds = GMSCoordinateBounds(path: path)
                
                
                var insets: CGFloat = 60
                self.myMapView.camera = self.myMapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
                let line = GMSPolyline(path: path)
            
                
                line.strokeWidth = 4.0
                line.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
                line.tappable = true
                line.map = self.myMapView
                
                self.myMapView.selectedMarker = nil
            }
        }

        self.myMapView.delegate = self
        
        
        self.mainScrollViewHeightConstraint.constant = self.moneysView.frame.origin.y + self.moneysViewHeightConstraint.constant
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "imageLoaded:",
            name:kVZOrderImageLoaded,
            object: nil)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToScrollSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.imagesScrollView.addGestureRecognizer(swipeLeft)
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToScrollSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.imagesScrollView.addGestureRecognizer(swipeRight)
        
        
        if(self.currentOrder.logos.count > 0)
        {
            self.imagesScrollViewHeightConstraint.constant = self.view.frame.width
        }
        else
        {
            self.imagesScrollViewHeightConstraint.constant = 0
        }
        
        
        var i: Int = 0
        for logoPath: String in self.currentOrder.logos
        {
            var imageView: UIImageView = UIImageView(frame: CGRectMake(CGFloat(i) * self.view.frame.width, 0, self.view.frame.width, self.view.frame.width))
            imageView.image = UIImage(named: "loadingImage")
            self.ImagesView.addSubview(imageView)
            self.LoadImage(logoPath, index: i)
            self.images.append(imageView)
            
            i++
        }
        
        if(i > 0)
        {
            self.imagesViewWidthConstraint.constant = self.view.frame.width * CGFloat(i)
        }
        else
        {
            self.imagesViewWidthConstraint.constant = self.view.frame.width
        }
        
        
        
        self.invitedPriceLabel.text = "\(self.currentOrder.budgetBYR) BYR"
        self.descriptionLabel.text = self.currentOrder.goodName
        
        if(self.currentOrder.transportType == TransportType.Goods || self.currentOrder.transportType == TransportType.Furniture)
        {
            var volume = (self.currentOrder.width/100.0) * (self.currentOrder.length/100.0) * (self.currentOrder.height/100.0)
            self.volumeDescription.text = "Общий объём: \(volume) м3"
            self.weightDescription.text = "Вес: \(self.currentOrder.weight) кг."
        }
        else if(self.currentOrder.transportType == TransportType.Passangers)
        {
            self.descriptionLabelHeightConstraint.constant = 0
            self.descriptionSeparatorImage.hidden = true
            
            self.volumeIcon.image = UIImage(named: "passengersCountIcon")
            self.weightIcon.image = UIImage(named: "baggageVolumeIcon")
            
            self.volumeDescription.text = "Количество мест: \(self.currentOrder.passagersCount)"
            self.weightDescription.text = "Объём багажа: \(self.currentOrder.baggage) л."
        }
        
        self.streetFromLabel.text = "\(self.currentOrder.fromStreet), \(self.currentOrder.fromHouse)"
        var addresArray = split(self.currentOrder.fromAddress) {$0 == ","}
        
        self.cityFromLabel.text = "\(addresArray[0]),"
        self.countryFromLabel.text = "\(self.currentOrder.fromAddress)"
        
        self.streetToLabel.text = "\(self.currentOrder.toStreet), \(self.currentOrder.toHouse)"
        addresArray = split(self.currentOrder.toAddress) {$0 == ","}
        
        self.cityToLabel.text = "\(addresArray[0]),"
        self.countryToLabel.text = "\(self.currentOrder.toAddress)"
        
        self.dateFromLabel.text = "\(self.currentOrder.fromDate)"
        self.dateToLabel.text = "\(self.currentOrder.toDate)"
        
        
        if(self.currentOrder.helpLoad == false && self.currentOrder.helpUnload == false)
        {
            self.helpLoadUnloadHeitghConstraint.constant = 0
            
            self.helpUnloadIcon.hidden = true
            self.helpUnloadLabel.hidden = true
            self.helpLoadIcon.hidden = true
            self.helpLoadLabel.hidden = true
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
        
        if(self.currentOrder.cashPayment == false && self.currentOrder.nocashPayment == false && self.currentOrder.cardPayment == false && self.currentOrder.webpayPayment == false && self.currentOrder.onlinePayment == false)
        {
            self.moneysViewHeightConstraint.constant = 0
        }
        else
        {
            self.moneysViewHeightConstraint.constant = CGFloat(paymentsCount) * CGFloat(30) + CGFloat(150)
        }
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
                self.images[index].image = self.RBSquareImage(image)
                self.images[index].contentMode = UIViewContentMode.ScaleToFill;
            }
            
            }) { (error) -> () in
                println("error")
        }
        
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        var originalWidth  = image.size.width
        var originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        var posX = (originalWidth  - edge) / 2.0
        var posY = (originalHeight - edge) / 2.0
        
        var cropSquare = CGRectMake(posX, posY, edge, edge)
        
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
    
    @IBAction func ShowHideMap(sender: AnyObject)
    {
        if(self.routeDetailsScroll.contentOffset.x < 10)
        {
            self.routeDetailsScroll.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
            self.showMapButtonRightConstraint.constant = -self.view.frame.width + 25
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        else
        {
            self.routeDetailsScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.showMapButtonRightConstraint.constant = 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func ShowDeals(sender: AnyObject)
    {
        
    }
    
}
