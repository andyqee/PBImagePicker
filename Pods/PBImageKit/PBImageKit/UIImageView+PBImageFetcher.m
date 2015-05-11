//
//  UIImageView+PBImageFetcher.m
//  PhotoBook
//
//  Created by andy on 10/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "UIImageView+PBImageFetcher.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PBImageManager.h"

@implementation UIImageView (PBImageFetcher)

- (void)setImageWithAsset:(ALAsset *)asset withResolution:(PBAssetImageResolution)resolution
{
    [[PBImageManager sharedManager] fetchImageWithAssets:@[asset]
                                          resolutionType:resolution
                                              completion:^(NSArray *images, NSError *error) {
                                                  if (error) {
                                                      // Handle error
                                                  }
                                                  if (images) {
                                                      self.image = [images firstObject];
                                                  }
    }];
}

- (void)setImageWithAssetURL:(NSURL *)url withResolution:(PBAssetImageResolution)resolution
{
    [[PBImageManager sharedManager] fetchImageWithAssets:@[url]
                                          resolutionType:resolution
                                              completion:^(NSArray *images, NSError *error) {
                                                  if (error) {
                                                      // Handle error
                                                  }
                                                  if (images) {
                                                      self.image = [images firstObject];
                                                  }
                                              }];
}

@end
