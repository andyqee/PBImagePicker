//
//  UIImageView+PBImageFetcher.h
//  PhotoBook
//
//  Created by andy on 10/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBAssetsDefine.h"

@class ALAsset;

@interface UIImageView (PBImageFetcher)

/**
 *  move the cost of creation image from ALAsset to the background thread.
 */

- (void)setImageWithAsset:(ALAsset *)asset withResolution:(PBAssetImageResolution)resolution;

- (void)setImageWithAssetURL:(NSURL *)url withResolution:(PBAssetImageResolution)resolution;

@end
