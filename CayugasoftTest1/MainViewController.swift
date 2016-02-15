//
//  MainViewController.swift
//  CayugasoftTest1
//
//  Created by Alexander on 16.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainViewController: UICollectionViewController {

    @IBAction func refresh(sender: AnyObject) {
        images = []
        loadImages()
        collectionView!.reloadData()
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        
    }
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
    }
    
    
    
    func loadImages() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        guard let filePaths = try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsPath) else {
            showError()
            return
        }
        let jpegs = filePaths.filter {
            let ext = ($0.lowercaseString as NSString).pathExtension
            return ext == "jpg" || ext == "jpeg"
        }
        for jpegName in jpegs {
            let fullPath = (documentsPath as NSString).stringByAppendingPathComponent(jpegName)
            if let image = UIImage(contentsOfFile: fullPath) {
                self.images.append(image)
            } else {
                // пока ничего
            }
        }
//        print(jpegs)
    }
    
    func showError() {
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCell
        cell.date = NSDate()
        cell.imageView.image = images[indexPath.item]
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
//        layer.shouldRasterize = true
        layer.shadowOpacity = 0.3
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
