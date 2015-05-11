//
//  PBImageRequest.m
//  PhotoBook
//
//  Created by andy on 7/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAssetsGroupRequest.h"

@interface PBAssetsGroupRequest()

@property (nonatomic) ALAssetsGroupType type;

@end

@implementation PBAssetsGroupRequest

+ (instancetype)newAssetsGroupRequestWithType:(ALAssetsGroupType)type
{
    PBAssetsGroupRequest *request = [[[self class] alloc] init];
    request.type = type;
    return request;
}

@end
