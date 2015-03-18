//
//  ViewController.swift
//  image-scroll-swift
//
//  Created by Evgenii Neumerzhitckii on 4/10/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class AvatarPickerViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageSizeToggleButton: UIButton!

    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var DoneButton: UIBarButtonItem!

    let picker = UIImagePickerController()
    var lastZoomScale: CGFloat = -1

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(RGBA: "f5f5f5")
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor(RGBA: "40a9f4")]
        }
        self.navigationItem.title = "vozim.by"
        
        let backButton = UIBarButtonItem(title: "Отмена", style: UIBarButtonItemStyle.Plain, target: self, action: "Cancel")
        navigationItem.leftBarButtonItem = backButton
        
        DoneButton.target = self
        DoneButton.action = "SaveImageToServer:"
        
        picker.delegate = self
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
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        updateZoom()
    }

    func updateConstraints()
    {
        if let image = imageView.image
        {
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height
            
            let imageWidth = image.size.width
            let imageHeight = image.size.height

            let viewWidth = self.scrollView.frame.width
            let viewHeight = self.scrollView.frame.height

            // center image if it is smaller than screen
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }

            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }

            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding

            imageConstraintTop.constant = vPadding - navigationBarHeight!*1.45
            imageConstraintBottom.constant = vPadding

            // Makes zoom out animation smooth and starting from the right point not from (0, 0)
            view.layoutIfNeeded()
        }
    }

    // Zoom to show as much image as possible unless image is smaller than screen
    private func updateZoom()
    {
        if let image = imageView.image
        {
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
    }
    
    @IBAction func OpenLibrary(sender: AnyObject)
    {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
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
//        AvatarScrollView.contentSize = AvatarImage.frame.size
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func SaveImageToServer(sender: AnyObject)
    {
        Server.sharedInstance.SetAvatar(self.MakeAvatarScreen(self.scrollView))
    }
    
//    private func MakeAvatarScreen() -> UIImage
//    {
//        var windowLayer = self.scrollView.layer
//        println("\(self.scrollView.frame)")
//        UIGraphicsBeginImageContextWithOptions(self.scrollView.frame.size, false, 1.0)
//        windowLayer.renderInContext(UIGraphicsGetCurrentContext())
//        var screenImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext();
//        
//        let relativePath = "hallo.png"
//        let path = DocumentsPathForFileName(relativePath)
//        UIImagePNGRepresentation(screenImage).writeToFile(path, atomically: true)
//        
//        println(path)
//        
//        return screenImage;
//    }
    
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

        let relativePath = "hallo.png"
        let path = DocumentsPathForFileName(relativePath)
        UIImagePNGRepresentation(image).writeToFile(path, atomically: true)
        println(path)
        
        return image
    }
}










