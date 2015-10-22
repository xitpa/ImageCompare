//
//  ImageCompare.swift
//  PhotoCompare
//
//  Created by Oleh Makodym on 21/10/15.
//  Copyright © 2015 Cell Phone. All rights reserved.
//

import Foundation

func compareImages(fimage : UIImage?, simage : UIImage?) -> (diffImage : UIImage, percentage : Double, size : CGSize, time : Double)?{
    if let firstImage = fimage, let secondImage = simage {
        let startDate = NSDate()
        let diffImage = ImageDifference.diffedImage(firstImage, image: secondImage)
        
        let imageInspection = CGImageInspection.createImageInspectionWithCGImage(diffImage.CGImage)
        let w = CGImageGetWidth(diffImage.CGImage)
        let h = CGImageGetHeight(diffImage.CGImage)
        
        var totaldiff : Double = 0
        
        for y in 0 ..< w {
            for x in 0..<h {
                var r : CGFloat = 0
                var g : CGFloat = 0
                var b : CGFloat = 0
                var a : CGFloat = 0
                
                imageInspection.colorAt(CGPointMake(CGFloat(x), CGFloat(y)), red: &r, green: &g, blue: &b, alpha: &a)
                
                totaldiff += Double(r)
                totaldiff += Double(g)
                totaldiff += Double(b)
            }
        }
        
        let percentageDiff = (totaldiff * 100) / Double(w * h * 3)
        
        let finishDate = NSDate()
        let timeInterval : NSTimeInterval = finishDate.timeIntervalSinceDate(startDate)
        let size : CGSize = CGSizeMake(CGFloat(w), CGFloat(h))
        return (diffImage: diffImage!, percentage : percentageDiff, size : size, time : Double(timeInterval))
        
    }
    return nil;
}
