//
//  PBFetchImageTask.h
//  PhotoBook
//
//  Created by andy on 6/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBAssetsGroupRequest;

@interface PBFetchAssetsGroupTask : NSOperation

@property (readonly, nonatomic, strong) PBAssetsGroupRequest *request;
@property (nonatomic, readonly) NSMutableArray *groups;
@property (nonatomic, readonly) NSError *error;

/**
 Attention: This completionQueue if/else is adopted from AFNetwroking
 The dispatch queue for the `completionBlock` of request operations. If `NULL` (default), the main queue is used.
 */

#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property (nonatomic, strong) dispatch_queue_t completionQueue;
#else
@property (nonatomic, assign) dispatch_queue_t completionQueue;
#endif

- (instancetype)initWithRequest:(PBAssetsGroupRequest *)request;

@end
