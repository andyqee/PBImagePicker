//
//  PBImageManager.h
//  PhotoBook
//
//  Created by andy on 12/3/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PBAssetsDefine.h"

@class PBFetchAssetsGroupTask, PBAssetsGroupRequest, PBFetchAssetsTask, PBFetchImageTask, ALAsset, UIImage;

@interface PBImageManager : NSObject

/**
 Attention: This completionQueue if/else is adopted from AFNetwroking
 The dispatch queue for the `completionBlock` of request operations. If `NULL` (default), the main queue is used.
 */
#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property (nonatomic, strong) dispatch_queue_t completionQueue;
#else
@property (nonatomic, assign) dispatch_queue_t completionQueue;
#endif

+ (instancetype)sharedManager;

- (PBFetchAssetsGroupTask *)fetchAssetsGroups:(ALAssetsGroupType)groupType
                             completion:(void(^)(NSArray *groups, NSError *error))completion;

- (PBFetchAssetsTask *)fetchAssetsInGroups:(ALAssetsGroup *)group
                                completion:(void (^)(NSArray *assets, NSError *error))completion;

/**
 *  FetchImage With Asset
 *  Right now, I am not sure, if we pass asset one by one , will it cost a lof of context switch,
 *  And meanwhile ,if we pass two many assets at once, will it performce current enough
 */

- (PBFetchImageTask *)fetchImageWithAssets:(NSArray *)assets
                            resolutionType:(PBAssetImageResolution)type
                                completion:(void (^)(NSArray *images, NSError *error))completion;

@end
