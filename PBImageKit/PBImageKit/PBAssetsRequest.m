//
//  PBAssetsRequest.m
//  PhotoBook
//
//  Created by andy on 7/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAssetsRequest.h"

@interface PBAssetsRequest()

@property (nonatomic, readwrite) ALAssetsGroup *assetGroup;

@property (nonatomic, readwrite) NSEnumerationOptions options;

@end

@implementation PBAssetsRequest

+ (instancetype)newWithAssetGroup:(ALAssetsGroup *)assetGroup
             withEnumerateOptions:(NSEnumerationOptions)options;
{
    PBAssetsRequest *instance = [[self alloc] init];
    instance.assetGroup = assetGroup;
    instance.options = options;
    return instance;
}

@end
