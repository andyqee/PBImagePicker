//
//  PBFetchImageRequest.m
//  PhotoBook
//
//  Created by andy on 11/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBFetchImageRequest.h"

@interface PBFetchImageRequest()

@property (nonatomic, readwrite) ALAsset *asset;

@property (nonatomic, assign, readwrite) PBAssetImageResolution resolution;

@property (nonatomic, strong, readwrite) NSURL *url;

@property (nonatomic, strong, readwrite) NSArray *assets;

@end

@implementation PBFetchImageRequest

+ (instancetype)newWithALAsset:(ALAsset *)asset
                    orAssetURL:(NSURL *)url
            andImageResolution:(PBAssetImageResolution)resolution
{
    PBFetchImageRequest *instance = [[self alloc] init];
    instance.asset = asset;
    instance.url = [url copy];
    instance.resolution = resolution;
    return instance;
}

+ (instancetype)newWithALAssets:(NSArray *)assets
             andImageResolution:(PBAssetImageResolution)resolution
{
    PBFetchImageRequest *instance = [[self alloc] init];
    instance.assets = [assets copy];
    instance.resolution = resolution;
    return instance;
}

@end
