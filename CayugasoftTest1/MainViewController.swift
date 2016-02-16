//
//  MainViewController.swift
//  CayugasoftTest1
//
//  Created by Alexander on 16.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation


private let reuseIdentifier = "Cell"


class MainViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func refresh(sender: AnyObject) {
        refreshImages()
    }
    
    func refreshImages() {
        images = []
        dates = []
        loadImages()
        updateCollectionView()
    }
    
    func updateCollectionView() {
        collectionView!.reloadData()
        collectionView!.scrollToItemAtIndexPath(NSIndexPath(forItem: images.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)

    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        let cameraAvailable = UIImagePickerController.isSourceTypeAvailable(.Camera) && AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == .Authorized
        guard cameraAvailable else {
            showCameraError()
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.sourceType = .Camera
        presentViewController(picker, animated: true, completion: nil)
    }
    
    var images: [UIImage?] = []
    var dates: [NSDate?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let side = self.view.bounds.size.width / 2 - 30
        layout.itemSize = CGSize(width: side, height: side)
        loadImages()
    }
    
    func documentsPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    }
    
    func loadImages() {
        let fm = NSFileManager.defaultManager()
        guard let filePaths = try? fm.contentsOfDirectoryAtPath(documentsPath()) else {
            showLoadingError()
            return
        }
        let jpegs = filePaths.filter {
            let ext = ($0.lowercaseString as NSString).pathExtension
            return ext == "jpg" || ext == "jpeg"
        }
        for jpegName in jpegs {
            let fullPath = (documentsPath() as NSString).stringByAppendingPathComponent(jpegName)
            let attributes = try? fm.attributesOfItemAtPath(fullPath)
            self.dates.append(attributes?[NSFileCreationDate] as? NSDate)
            
            self.images.append(UIImage(contentsOfFile: fullPath))
        }
    }
    
// MARK: Errors
    func showLoadingError() {
        let alert = UIAlertController(title: "Ошибка загрузки", message: "Не удалось загрузить фото", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
 
    func showCameraError() {
        let alert = UIAlertController(title: "Камера не работает", message: "Возможно, у приложения нет разрешения использовать камеру. Перейдите в настройки, чтобы это исправить", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Настройки", style: .Default, handler: { action in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        alert.addAction(UIAlertAction(title: "Oтмена", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSavingError() {
        let alert = UIAlertController(title: "Ошибка сохранения", message: "Не удалось сохранить фото. Возможно, на устройстве закончилось место", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
// MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        let imageName = (NSDate().description as NSString).stringByAppendingPathExtension("jpg")!
        let path = (documentsPath() as NSString).stringByAppendingPathComponent(imageName)
        if (try? UIImageJPEGRepresentation(image, 1.0)?.writeToFile(path, options: [])) == nil {
            showSavingError()
        }
        dismissViewControllerAnimated(true) { [weak self] in
            self?.images.append(image)
            self?.dates.append(NSDate())
            self?.updateCollectionView()
        }
    }

 
// MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell
        let item = indexPath.item
        let date = dates[item]
        let image = images[item]
        if date != nil {
            cell.date = date
        } else {
            cell.dateLabel.text = "???"
        }
        
        if image != nil {
            cell.imageView.image = image
        } else {
            cell.imageView.image = UIImage(named: "placeholder")
        }
        decorate(cell)
        
        return cell
    }
    
    func decorate(cell: UICollectionViewCell) {
        let layer = cell.layer
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 3
        layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 0).CGPath
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
    }
}
