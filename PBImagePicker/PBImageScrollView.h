//
//  PBImageScrollView.h
//  PhotoBook
//
//  Created by andy on 6/3/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBImageScrollView : UIScrollView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) UIImageView *imageView;

@end
