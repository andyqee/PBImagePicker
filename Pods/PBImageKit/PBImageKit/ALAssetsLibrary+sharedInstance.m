//
//  ALAssetsLibrary+sharedInstance.m
//  PhotoBook
//
//  Created by andy on 6/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "ALAssetsLibrary+sharedInstance.h"

@implementation ALAssetsLibrary (sharedInstance)

+ (instancetype)sharedInstance
{
    static ALAssetsLibrary *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ALAssetsLibrary new];
    });
    return instance;
}

@end
