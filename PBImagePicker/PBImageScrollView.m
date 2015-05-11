//
//  PBImageScrollView.m
//  PhotoBook
//
//  Created by andy on 6/3/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBImageScrollView.h"

@interface PBImageScrollView()
@property (nonatomic, readwrite) UIImageView *imageView;

@end


@implementation PBImageScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupImageView];
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 4.0;
        self.directionalLockEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    if (image == _image) {
        return;
    }
    _image = image;
    _imageView.image = _image;
    
    CGFloat ratio = _image.size.width / _image.size.height;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    _imageView.frame = (CGRect){ {0, 0}, { width * MAX(1, ratio), height * MAX(1, 1/ratio)} };
    self.contentSize = _imageView.frame.size;
    self.contentInset = UIEdgeInsetsZero;
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - initUI

- (void)_setupImageView
{
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
}


@end
