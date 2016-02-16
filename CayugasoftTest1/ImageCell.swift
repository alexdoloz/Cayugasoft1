//
//  ImageCell.swift
//  CayugasoftTest1
//
//  Created by Alexander on 16.02.16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    let formatter = NSDateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.dateFormat = "EEEE, dd MMM yyyy"
    }
    
    var date: NSDate! {
        didSet {
            let dateString = formatter.stringFromDate(date)
            let commaPosition = (dateString as NSString).rangeOfString(",").location
            let boldRange = NSMakeRange(0, commaPosition)
            let attributedString = NSMutableAttributedString(string: dateString)
            let boldFont = UIFont.boldSystemFontOfSize(14.0)
            attributedString.addAttribute(NSFontAttributeName, value:boldFont, range: boldRange)
            dateLabel.attributedText = attributedString
        }
    }
}
