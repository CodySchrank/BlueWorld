//
//  Tools.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/4/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation
import UIKit
import DateTools

class Tools {
    static var ads = false
    
    static var ErrorNotification = "com.BlueWorld.ErrorNotication"
    
    static func postError(error: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(ErrorNotification, object: nil, userInfo: ["error":error])
    }
    
    static func startLoad(view: UIView, spinner: UIActivityIndicatorView) {
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
        view.userInteractionEnabled = false
        view.alpha = 0.5
    }
    
    static func stopLoad(view: UIView, spinner: UIActivityIndicatorView) {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
        view.userInteractionEnabled = true
        view.alpha = 1
    }
    
    static func parseJSON(data: NSData) -> [String: AnyObject]? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            if let jsonDict = json as? [String: AnyObject] {
                return jsonDict
            }
        } catch let e {
            print(e)
        }
        return nil
    }
    
    static func parseAnyJSON(data: NSData) -> AnyObject? {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            return json
        } catch let e {
            print(e)
        }
        return nil
    }
    
    static func calculateRectOfImageInImageView(imageView: UIImageView) -> CGRect {
        let imageViewSize = imageView.frame.size
        let imgSize = imageView.image?.size
        
        guard let imageSize = imgSize where imgSize != nil else {
            return CGRectZero
        }
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        // Center image
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        // Add imageView offset
        imageRect.origin.x += imageView.frame.origin.x
        imageRect.origin.y += imageView.frame.origin.y
        
        return imageRect
    }
    
    static func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension String {
    func substringWithRange(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
    
        let range = self.startIndex.advancedBy(start) ..< self.startIndex.advancedBy(end)
        return self.substringWithRange(range)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

extension NSDate {
    
    func formattedRelativeString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        
        if isToday() {
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.dateStyle = .NoStyle
        } else if isYesterday() {
            dateFormatter.timeStyle = .NoStyle
            dateFormatter.dateStyle = .MediumStyle
        } else if daysAgo() < 6 {
            return dateFormatter.weekdaySymbols[weekday()-1]
        } else {
            dateFormatter.timeStyle = .NoStyle
            dateFormatter.dateStyle = .ShortStyle
        }
        
        return dateFormatter.stringFromDate(self)
    }
}



