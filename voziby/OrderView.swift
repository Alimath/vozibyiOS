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
    @IBOutlet weak var routeDetailsViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var offeredPriceLabel: UILabel!
    @IBOutlet weak var offeredPriceLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var invitedPriceLabel: UILabel!
    @IBOutlet weak var invitedPriceLabelWIdthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var createrName: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionSeparatorImage: UIImageView!
    @IBOutlet weak var volumeDescription: UILabel!
    @IBOutlet weak var weightDescription: UILabel!
    @IBOutlet weak var volumeIcon: UIImageView!
    @IBOutlet weak var weightIcon: UIImageView!
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
    @IBOutlet weak var dateToLabel: UILabel!
    
    @IBOutlet weak var helpLoadUnloadSeparator: UIImageView!
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
    @IBOutlet weak var imagesShadowHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesShadow: UIImageView!
    
    @IBOutlet weak var ShowDealsButton: UIButton!
    @IBOutlet weak var showHideMapImage: UIImageView!
    
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
        
        
        self.mainScrollViewHeightConstraint.constant = self.moneysView.frame.origin.y + self.moneysViewHeightConstraint.constant + 40
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let font = UIFont(name: "HelveticaNeue", size: 25)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        }
        self.navigationItem.title = "Карточка объявления"
        
        
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
        
        
        self.imagesScrollViewHeightConstraint.constant = self.view.frame.width * 0.75
        
        var i: Int = 0
        for logoPath: String in self.currentOrder.logos
        {
            var imageView: UIImageView = UIImageView(frame: CGRectMake(CGFloat(i) * self.view.frame.width, 0, self.view.frame.width, self.view.frame.width * 0.75))
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
            var imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.width * 0.75))
            imageView.image = UIImage(named: "noImage")
            self.ImagesView.addSubview(imageView)
            self.images.append(imageView)
            self.imagesViewWidthConstraint.constant = self.view.frame.width
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
        
//        self.invitedPriceLabel.adjustsFontSizeToFitWidth = true
        self.offeredPriceLabel.text = "\(numberFormatter.stringFromNumber(NSNumber(long: 0))!) BYR"
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
        
//        self.offeredPriceLabel.adjustsFontSizeToFitWidth = true
        
        self.descriptionLabel.text = self.currentOrder.goodName
        
        if(self.currentOrder.transportType == TransportType.Goods || self.currentOrder.transportType == TransportType.Furniture)
        {
            var volume = (self.currentOrder.width/100.0) * (self.currentOrder.length/100.0) * (self.currentOrder.height/100.0)
            self.volumeDescription.text = "Общий объём: "+NSString(format: "%.02f", volume)+" м3"
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
        
        var country: String = ""
        var city: String
        if(addresArray[0] as String == "Россия")
        {
            city = addresArray[addresArray.count-1]
            addresArray = addresArray.reverse()
            for otherString in addresArray[1...addresArray.count-1]
            {
                country = "\(country), \(otherString)"
            }
        }
        else
        {
            city = addresArray[0]
            for otherString in addresArray[1...addresArray.count-1]
            {
                country = "\(country), \(otherString)"
            }
        }
        
        let punctuationCharacterSet = NSCharacterSet.punctuationCharacterSet()
        let spaceSet = NSCharacterSet.whitespaceCharacterSet()
        
        country = country.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch).stringByTrimmingCharactersInSet(punctuationCharacterSet).stringByTrimmingCharactersInSet(spaceSet)
        city = city.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch).stringByTrimmingCharactersInSet(punctuationCharacterSet).stringByTrimmingCharactersInSet(spaceSet)
        

        
        
        self.cityFromLabel.text = "\(city),"
        self.countryFromLabel.text = "\(country)"
        
        self.streetToLabel.text = "\(self.currentOrder.toStreet), \(self.currentOrder.toHouse)"
        addresArray = split(self.currentOrder.toAddress) {$0 == ","}
        
        country = ""
        if(addresArray[0] as String == "Россия")
        {
            city = addresArray[addresArray.count-1]
            addresArray = addresArray.reverse()
            for otherString in addresArray[1...addresArray.count-1]
            {
                country = "\(country), \(otherString)"
            }
        }
        else
        {
            city = addresArray[0]
            for otherString in addresArray[1...addresArray.count-1]
            {
                country = "\(country), \(otherString)"
            }
        }
        
        country = country.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch).stringByTrimmingCharactersInSet(punctuationCharacterSet).stringByTrimmingCharactersInSet(spaceSet)
        city = city.stringByReplacingOccurrencesOfString("\\s+", withString: " ", options: .RegularExpressionSearch).stringByTrimmingCharactersInSet(punctuationCharacterSet).stringByTrimmingCharactersInSet(spaceSet)
        
        
        self.cityToLabel.text = "\(city),"
        self.countryToLabel.text = "\(country)"
        
        self.dateFromLabel.text = "\(self.currentOrder.fromDate)"
        self.dateToLabel.text = "\(self.currentOrder.toDate)"
        
        
        if(self.currentOrder.helpLoad == false && self.currentOrder.helpUnload == false)
        {
            self.helpLoadUnloadHeitghConstraint.constant = 0
            
            self.helpUnloadIcon.hidden = true
            self.helpUnloadLabel.hidden = true
            self.helpLoadIcon.hidden = true
            self.helpLoadLabel.hidden = true
            self.helpLoadUnloadSeparator.hidden = true
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
        
        self.view.layoutSubviews()
        
        if(self.currentOrder.cashPayment == false && self.currentOrder.nocashPayment == false && self.currentOrder.cardPayment == false && self.currentOrder.webpayPayment == false && self.currentOrder.onlinePayment == false)
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
                self.images[index].image = self.RBResizeImage(image, targetSize: CGSize(width: self.imagesScrollView.frame.width, height: self.imagesScrollView.frame.width * 0.75))
                self.images[index].contentMode = UIViewContentMode.ScaleToFill;
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
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
//            (sender as UIButton).setImage(UIImage(named: "closeMapArrow")!, forState: UIControlState.Normal)
            self.showMapButtonRightConstraint.constant = -self.view.frame.width + 40
            self.showHideMapImage.image = UIImage(named: "closeMapArrow")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        else
        {
            self.routeDetailsScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//            (sender as UIButton).setImage(UIImage(named: "openMapArrow")!, forState: UIControlState.Normal)
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
    
}
