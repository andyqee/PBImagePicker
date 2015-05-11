//
//  PBUtils.h
//  PhotoBook
//
//  Created by andy on 23/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#ifndef PhotoBook_PBUtils_h
#define PhotoBook_PBUtils_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

void PBPerformBlockOnMainThread(void (^block)());

/**
 *  Generate an uiimage filled by color
 *
 *  @param color color of image
 *
 *  @return image
 */

UIImage *imageWithColor(UIColor *color);

UIImage *imageWithColorAndSize(UIColor *color, CGSize size);


CGFloat screenScale(void);

CGFloat screenWidth(void);

CGFloat screenHeight(void);

#endif
