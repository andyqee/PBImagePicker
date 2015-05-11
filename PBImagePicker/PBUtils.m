//
//  PBUtils.c
//  PhotoBook
//
//  Created by andy on 23/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#include "PBUtils.h"

void PBPerformBlockOnMainThread(void (^block)())
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

UIImage *imageWithColor(UIColor *color)
{
   return imageWithColorAndSize(color, (CGSize){.width = 1.0, .height = 1.0});
}

UIImage *imageWithColorAndSize(UIColor *color, CGSize size)
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

CGFloat screenScale(void)
{
    static CGFloat _scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scale = [UIScreen mainScreen].scale;
    });
    return _scale;
}


CGFloat screenWidth(void)
{
    static CGFloat _width;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _width = [UIScreen mainScreen].bounds.size.width;
    });
    return _width;
}

CGFloat screenHeight(void)
{
    static CGFloat _height;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _height = [UIScreen mainScreen].bounds.size.height;
    });
    return _height;
}

