//
//  ImageCompare.m
//  SimplePhotoFilter
//
//  Created by Oleh Makodym on 16/10/15.
//  Copyright © 2015 Cell Phone. All rights reserved.
//

#import "ImageDifference.h"
#import "CGImageInspection.h"

@implementation ImageDifference

+ (CGContextRef)createCGContextFromCGImage:(CGImageRef)img
{
    size_t width = CGImageGetWidth(img);
    size_t height = CGImageGetHeight(img);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(img);
    size_t bytesPerRow = CGImageGetBytesPerRow(img);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, // Let CG allocate it for us
                                             width,
                                             height,
                                             bitsPerComponent,
                                             bytesPerRow,
                                             colorSpace,
                                             kCGImageAlphaPremultipliedLast); // RGBA
    CGColorSpaceRelease(colorSpace);
    NSAssert(ctx, @"CGContext creation fail");
    
    return ctx;
}

+ (UIImage *)diffedImage:(UIImage*)_newImage image:(UIImage*)_oldImage
{
    // We assume both images are the same size, but it's just a matter of finding the biggest
    // CGRect that contains both image sizes and create the CGContext with that size
    CGRect imageRect = CGRectMake(0, 0,
                                  CGImageGetWidth(_oldImage.CGImage),
                                  CGImageGetHeight(_oldImage.CGImage));
    // Create our context based on the old image
    CGContextRef ctx = [self createCGContextFromCGImage:_oldImage.CGImage];
    
    // Draw the old image with the default (normal) blendmode
    CGContextDrawImage(ctx, imageRect, _oldImage.CGImage);
    // Change the blendmode for the remaining drawing operations
    CGContextSetBlendMode(ctx, kCGBlendModeDifference);
    // Draw the new image "on top" of the old one
    CGContextDrawImage(ctx, imageRect, _newImage.CGImage);
    
    // Grab the composed CGImage
    CGImageRef diffed = CGBitmapContextCreateImage(ctx);
    // Cleanup and return a UIImage
    CGContextRelease(ctx);
    UIImage *diffedImage = [UIImage imageWithCGImage:diffed];
    CGImageRelease(diffed);
    
    return diffedImage;
}

@end
