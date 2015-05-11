//
//  PBImageRequest.h
//  PhotoBook
//
//  Created by andy on 7/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface PBAssetsGroupRequest : NSObject

@property (nonatomic, readonly) ALAssetsGroupType type;

+ (instancetype)newAssetsGroupRequestWithType:(ALAssetsGroupType)type;

@end
