//
//  PBAssetsRequest.h
//  PhotoBook
//
//  Created by andy on 7/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAssetsGroup;

@interface PBAssetsRequest : NSObject

@property (nonatomic, readonly) ALAssetsGroup *assetGroup;

@property (nonatomic, readonly) NSEnumerationOptions options;

+ (instancetype)newWithAssetGroup:(ALAssetsGroup *)assetGroup
             withEnumerateOptions:(NSEnumerationOptions)options;

@end
