//
//  CGImageInspection.h
//  PhotoCompare
//
//  Created by Oleh Makodym on 19/10/15.
//  Copyright © 2015 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGImageInspection : NSObject
+ (CGImageInspection *) createImageInspectionWithCGImage: (CGImageRef) imageRef ;

- (void) colorAt: (CGPoint) location
             red: (CGFloat *) red
           green: (CGFloat *) green
            blue: (CGFloat *) blue
           alpha: (CGFloat *) alpha ;

@end
