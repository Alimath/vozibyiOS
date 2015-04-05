//
//  ViewController.swift
//  image-scroll-swift
//
//  Created by Evgenii Neumerzhitckii on 4/10/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit
import AssetsLibrary

class AvatarPickerViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate
{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    @IBOutlet weak var ScrollViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var imagesPickerView: UIView!
    @IBOutlet weak var imagesPickHeightConstraint: NSLayoutConstraint!
    let picker = UIImagePickerController()
    var lastZoomScale: CGFloat = -1
    var images : [UIImage] = []
    var assetsURLs: [NSURL] = []
    @IBOutlet weak var imagePickerActivityIndicator: UIActivityIndicatorView!
    var pointStartScrolling: CGFloat = 0
    var isShowingBigPhotoPicker: Bool = false
    @IBOutlet weak var imagesScrollView: UIScrollView!
    var lastSelectedImage: UIButton!
    
//    var fullImages : [UIImage] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imagePickerActivityIndicator.startAnimating()
        println(self.imagePickerActivityIndicator.frame)
        
        var userInfo: UserInfo = GetUserInfo()
        if(userInfo.logoPath != "")
        {
            let logoFullPath = DocumentsPathForFileName(kVZLogoFileNameKey)
            let logoImageData = NSData(contentsOfFile: logoFullPath)
            let logoImage = UIImage(data: logoImageData!)
            self.imageView.image = logoImage
        }
        
        self.updateConstraints()
        
        self.view.backgroundColor = UIColor(RGBA: "f5f5f5")
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "40a9f4")]
        }
        self.navigationItem.title = "vozim.by"
        
//        let backButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItemStyle.Plain, target: self, action: "Cancel")
//        navigationItem.leftBarButtonItem = backButton
        
        DoneButton.target = self
        DoneButton.action = "MakeShot:"
        
        picker.delegate = self
    
        getLatestPhotos(completion: { images in
            //Set Images in this block.
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "SetPhotos:", name: "PhotosLoaded", object: nil)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.ScrollViewHeightConstraint.constant = self.view.frame.width
    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)

//    imageView.image = UIImage(named: imageScrollLargeImageName)
        scrollView.delegate = self
        updateZoom()
    }

    // Update zoom scale and constraints
    // It will also animate because willAnimateRotationToInterfaceOrientation
    // is called from within an animation block
    //
    // DEPRECATION NOTICE: This method is said to be deprecated in iOS 8.0. But it still works.
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        updateZoom()
    }
    
//    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
//    {
//        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
//        updateZoom()
//    }

    func updateConstraints()
    {
        if let image = imageView.image
        {
            
//            println("CONSTRAINTS: imagesize: \(imageView.frame.size), scrollSize: \(self.scrollView.frame.size)")
            
//            let navigationBarHeight = self.navigationController?.navigationBar.frame.height
            
            let imageWidth = image.size.width
            let imageHeight = image.size.height

            let viewWidth = self.scrollView.frame.width
            let viewHeight = self.scrollView.frame.height

            // center image if it is smaller than screen
//            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
//            if hPadding < 0 { hPadding = 0 }
//
//            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
//            if vPadding < 0 { vPadding = 0 }

//            imageConstraintLeft.constant = hPadding
//            imageConstraintRight.constant = hPadding
//
//            imageConstraintTop.constant = vPadding - navigationBarHeight!*1.45
//            imageConstraintBottom.constant = vPadding
            
            self.scrollView.contentSize = imageView.frame.size
            // Makes zoom out animation smooth and starting from the right point not from (0, 0)
            view.layoutIfNeeded()
        }
    }

    // Zoom to show as much image as possible unless image is smaller than screen
    private func updateZoom()
    {
        if let image = imageView.image
        {
//            println("AFTER CONSTRAINTS: imagesize: \(imageView.frame.size), scrollSize: \(self.scrollView.contentSize)")
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height
            
            var minZoom: CGFloat = 1.0//= max(view.bounds.size.width / image.size.width, view.bounds.size.height / image.size.height)
            if(image.size.width < image.size.height)
            {
                minZoom = self.scrollView.frame.size.width / image.size.width
            }
            else
            {
                minZoom = self.scrollView.frame.size.width / image.size.height
            }

            scrollView.minimumZoomScale = minZoom

            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale
            {
                minZoom += 0.000001
            }

            scrollView.zoomScale = minZoom
            scrollView.maximumZoomScale = minZoom * 2
            lastZoomScale = minZoom
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func MakeShot(sender: AnyObject)
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
        presentViewController(picker, animated: true, nil)
    }

    // UIScrollViewDelegate
    // -----------------------

    func scrollViewDidZoom(scrollView: UIScrollView)
    {
        updateConstraints()
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
    }

    
    func Cancel()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
        updateZoom()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func SaveImageToServer(sender: AnyObject)
    {
        Server.sharedInstance.SetAvatar(self.MakeAvatarScreen(self.scrollView))
    }
    
    private func MakeAvatarScreen(background: UIView) -> UIImage
    {
        var image: UIImage
        var size: CGSize = self.view.frame.size
        UIGraphicsBeginImageContext(size)
        background.layer.affineTransform()
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imgRef: CGImageRef = CGImageCreateWithImageInRect(image.CGImage, background.frame)
        image = UIImage(CGImage: imgRef)!

        let relativePath = kVZLogoFileNameKey
        let path = DocumentsPathForFileName(relativePath)
        UIImagePNGRepresentation(image).writeToFile(path, atomically: true)
        
        return image
    }
    
    func GetPhotoCount()
    {
        
    }
    
    func getLatestPhotos(completion completionBlock : ([UIImage] -> ()))
    {
        let library = ALAssetsLibrary()
        var count = 0
        var stopped = false
        
        library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group,var stop) -> Void in
            
            if group == nil
            {
                return
            }
            
            group?.setAssetsFilter(ALAssetsFilter.allPhotos())
            var countPh: Int = (group?.numberOfAssets())!
            
            group?.valueForProperty(ALAssetsGroupPropertyName)

            group?.enumerateAssetsWithOptions(NSEnumerationOptions.Reverse, usingBlock: {
                (asset : ALAsset!, index, var stopEnumeration) -> Void in
                if (!stopped)
                {
                    if count >= countPh
                    {
                        
                        stopEnumeration.memory = ObjCBool(true)
                        stop.memory = ObjCBool(true)
                        completionBlock(self.images)
                        stopped = true
                        NSNotificationCenter.defaultCenter().postNotificationName("PhotosLoaded", object: nil)
                    }
                    else
                    {
                        var assetURL = asset.valueForProperty(ALAssetPropertyAssetURL) as NSURL
                        
                        self.assetsURLs.append(assetURL)
                        // For just the thumbnails use the following line.
                        let cgImage = asset.thumbnail().takeUnretainedValue()
//                        self.imagesAssets.append(asset.defaultRepresentation())
                        // Use the following line for the full image.
                        
                        if let image = UIImage(CGImage: cgImage)
                        {
                            self.images.append(image)
                            count += 1
                        }
                    }
                }
                
            })
                
            
            },failureBlock : { error in
                println(error)
        })
    }
    
    func SetPhotos(notification: NSNotification)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            var i: Int = 0
            var j: Int = 0
            
            var contentWidth = self.imagesPickerView.frame.width
            var oneImageSize = self.imagesPickerView.frame.width / CGFloat(4)
            
            
            for image in self.images
            {
                var thumbImageView = UIImageView(image: image)
                thumbImageView.frame = CGRectMake(oneImageSize * CGFloat(i) + 1, oneImageSize * CGFloat(j) + 1, oneImageSize - 2, oneImageSize - 2)
                
                var imagePickBtn = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
                imagePickBtn.frame = CGRectMake(oneImageSize * CGFloat(i) + 1, oneImageSize * CGFloat(j) + 1, oneImageSize - 2, oneImageSize - 2)
                imagePickBtn.backgroundColor = UIColor.clearColor()
                imagePickBtn.addTarget(self, action: "ClickEventOnImage:", forControlEvents: UIControlEvents.TouchUpInside)
                imagePickBtn.tag = i + 4*j
            
                self.imagesPickerView.addSubview(thumbImageView)
                self.imagesPickerView.addSubview(imagePickBtn)
                
                thumbImageView.userInteractionEnabled = true
                i += 1
                if(i == 4)
                {
                    i = 0
                    j += 1
                }
            }
            
            self.imagesPickHeightConstraint.constant = max(oneImageSize + oneImageSize * CGFloat(j) + 1, self.imagesScrollView.frame.height)
            self.imagePickerActivityIndicator.stopAnimating()
        }
        
        
    }
    
    @IBAction func ClickEventOnImage(sender: AnyObject)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            var aas = ALAsset()
            
            var assetLib = ALAssetsLibrary()
            assetLib.assetForURL(self.assetsURLs[sender.tag], resultBlock: { (asset) -> Void in
                self.imageView.image = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
                self.updateConstraints()
                self.updateZoom()
            }, failureBlock: { (error) -> Void in
                println("error read image")
            })
//            self.lastSelectedImage = sender.object as UIButton
            self.ShowHideBigPhotoPicker(false)
//            self.imageView.image = self.fullImages[sender.tag]
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        if(scrollView.tag == 101)
        {
            pointStartScrolling = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView.tag == 101)
        {
            if(scrollView.contentOffset.y > pointStartScrolling)
            {
                self.ShowHideBigPhotoPicker(true)
            }
        }
    }
    
    func ShowHideBigPhotoPicker(show: Bool)
    {
        if(show && self.ScrollViewHeightConstraint.constant > 150)
        {
            self.isShowingBigPhotoPicker = true
            self.ScrollViewHeightConstraint.constant = 100
            self.imagesPickHeightConstraint.constant = max(self.imagesPickHeightConstraint.constant, self.view.frame.height - 100)
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        else if (!show)
        {
            self.isShowingBigPhotoPicker = false
            self.ScrollViewHeightConstraint.constant = self.view.frame.width
            self.imagesPickHeightConstraint.constant = max(self.imagesPickHeightConstraint.constant, self.imagesScrollView.frame.height)
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
        
        if(self.isShowingBigPhotoPicker)
        {
            self.DoneButton.enabled = false
        }
        else
        {
            self.DoneButton.enabled = true
        }
        
    }
}
