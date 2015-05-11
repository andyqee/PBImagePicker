//
//  PBFetchImageRequest.h
//  PhotoBook
//
//  Created by andy on 11/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBAssetsDefine.h"

@class ALAsset;

@interface PBFetchImageRequest : NSObject

@property (nonatomic, readonly) ALAsset *asset;

@property (nonatomic, strong, readonly) NSArray *assets;

@property (nonatomic, assign, readonly) PBAssetImageResolution resolution;

@property (nonatomic, strong, readonly) NSURL *url;

+ (instancetype)newWithALAsset:(ALAsset *)asset
                    orAssetURL:(NSURL *)url
            andImageResolution:(PBAssetImageResolution)resolution;

+ (instancetype)newWithALAssets:(NSArray *)assets
             andImageResolution:(PBAssetImageResolution)resolution;


@end
