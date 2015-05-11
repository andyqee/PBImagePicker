//
//  UIImage+fix_rotation.h
//  PhotoBook
//
//  Created by andy on 24/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

// This solution is adopted from
// http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload?rq=1
//

@interface UIImage (fix_rotation)

- (UIImage *)pb_fixOrientation;

@end
