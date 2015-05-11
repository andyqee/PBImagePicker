//
//  PBFetchImageTask.h
//  PhotoBook
//
//  Created by andy on 8/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class PBFetchImageRequest;

@interface PBFetchImageTask : NSOperation


/* The image that was fetched by the receiver.
 */

@property (nonatomic, readonly) NSMutableArray *images;

@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, readonly) NSError *error;

#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property (nonatomic, strong) dispatch_queue_t completionQueue;
#else
@property (nonatomic, assign) dispatch_queue_t completionQueue;
#endif

/**
 The dispatch group for `completionBlock`. If `NULL` (default), a private dispatch group is used.
 */
#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property (nonatomic, strong) dispatch_group_t completionGroup;
#else
@property (nonatomic, assign) dispatch_group_t completionGroup;
#endif

- (instancetype)initWithRequest:(PBFetchImageRequest *)request;

@end
