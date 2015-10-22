//
//  ImageCompare.h
//  PhotoCompare
//
//  Created by Oleh Makodym on 16/10/15.
//  Copyright © 2015 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageDifference : NSObject 
+ (UIImage *)diffedImage:(UIImage*)_newImage image:(UIImage*)_oldImage;
@end
