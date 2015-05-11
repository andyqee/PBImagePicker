//
//  PBFetchAssetsTask.h
//  PhotoBook
//
//  Created by andy on 7/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBAssetsRequest;

@interface PBFetchAssetsTask : NSOperation

@property (nonatomic, readonly) NSMutableArray *assets;

@property (nonatomic, readonly) NSError *error;


#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property (nonatomic, strong) dispatch_queue_t completionQueue;
#else
@property (nonatomic, assign) dispatch_queue_t completionQueue;
#endif

- (instancetype)initWithRequest:(PBAssetsRequest *)request;

@end
