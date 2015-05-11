//
//  PBFetchImageTask.m
//  PhotoBook
//
//  Created by andy on 8/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBFetchImageTask.h"
#import <libkern/OSAtomic.h>
#import "PBAssetsDefine.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "PBFetchImageRequest.h"

typedef NS_ENUM(NSInteger, PBFetchImageTaskState){
    
    kPBFetchImageTaskStateReady,
    kPBFetchImageTaskStateExecuting,
    kPBFetchImageTaskStateFinished,
    kPBFetchImageTaskStatePaused

};

/**
 *  this inline function is insipired by AFNetworking
 *
 */

static inline NSString * PBKeyPathFromOperationState(PBFetchImageTaskState state) {
    switch (state) {
        case kPBFetchImageTaskStateReady:
            return @"isReady";
        case kPBFetchImageTaskStateExecuting:
            return @"isExecuting";
        case kPBFetchImageTaskStateFinished:
            return @"isFinished";
        case kPBFetchImageTaskStatePaused:
            return @"isPaused";
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            return @"state";
#pragma clang diagnostic pop
        }
    }
}

static dispatch_group_t image_fetch_operation_completion_group()
{
    static dispatch_group_t pb_image_fetch_operation_completion_group;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        pb_image_fetch_operation_completion_group = dispatch_group_create();
    });
    return pb_image_fetch_operation_completion_group;
}


@interface PBFetchImageTask()

@property (nonatomic, readwrite) NSMutableArray *images;

@property (nonatomic, readwrite) UIImage *image;

@property (nonatomic, readwrite) NSError *error;

@property (nonatomic, readwrite) ALAsset *asset;

@property (nonatomic, readwrite) NSArray *assets;

@property (nonatomic, readwrite) PBFetchImageRequest *request;

@property (nonatomic) PBFetchImageTaskState state;

@property (nonatomic) OSSpinLock lock;

@property (nonatomic) PBAssetImageResolution resolution;

@end

@implementation PBFetchImageTask

- (instancetype)initWithRequest:(PBFetchImageRequest *)request
{
    if (self = [super init]) {
        
        _images = [NSMutableArray array];
        _request = request;
        _state = kPBFetchImageTaskStateReady;
        _asset = [request.asset copy];
        _assets = [request.assets copy];
        _resolution = request.resolution;
        
        _lock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)start
{
    self.state = kPBFetchImageTaskStateExecuting;
    if (!self.isCancelled) {
        for (ALAsset *asset in _assets) {
            [_images addObject:[self _createUIImageBasedOnResolution:asset]];
        }
    }
    self.state = kPBFetchImageTaskStateFinished;
}

- (BOOL)isFinished
{
    return self.state == kPBFetchImageTaskStateFinished;
}

- (BOOL)isExecuting
{
    return self.state == kPBFetchImageTaskStateExecuting;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isReady
{
    return self.state == kPBFetchImageTaskStateReady && [super isReady];
}

- (void)cancel
{
    
}

- (void)setCompletionBlock:(void (^)(void))completionBlock
{
    OSSpinLockLock(&(_lock));
    if (!completionBlock) {
        [super setCompletionBlock:nil];
    } else {
        __weak typeof(self) weakSelf = self;
        [super setCompletionBlock:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            
            dispatch_group_t group = strongSelf.completionGroup ?: image_fetch_operation_completion_group();
            dispatch_queue_t queue = strongSelf.completionQueue ?: dispatch_get_main_queue();
            
            dispatch_group_async(group, queue, ^{
                completionBlock();
            });
            
            dispatch_group_notify(group, queue, ^{
                // When the completion block finished ,set it to nil to break retain cycle;
                [strongSelf setCompletionBlock:nil];
            });
        }];
    }
    OSSpinLockUnlock(&(_lock));
}

- (void)setState:(PBFetchImageTaskState)state
{
    //这里需要加锁吗？是用OSpinlock 还是用 NSRecursiveLock
    OSSpinLockLock(&(_lock));
    
    NSString *oldStateKey = PBKeyPathFromOperationState(self.state);
    NSString *newStateKey = PBKeyPathFromOperationState(state);
    [self willChangeValueForKey:oldStateKey];
    [self willChangeValueForKey:newStateKey];
    _state = state;
    [self didChangeValueForKey:newStateKey];
    [self didChangeValueForKey:newStateKey];
    
    OSSpinLockUnlock(&(_lock));
}

- (UIImage *)_createUIImageBasedOnResolution:(ALAsset *)asset
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    switch (_resolution) {
        case kPBAssetImageResolutionThumbnail:
            return [UIImage imageWithCGImage:asset.thumbnail scale:scale orientation:UIImageOrientationUp];

        case kPBAssetImageResolutionAspectRatioThumbnail:
            return [UIImage imageWithCGImage:asset.aspectRatioThumbnail scale:scale orientation:UIImageOrientationUp];

        case kPBAssetImageResolutionFullscreen:
        {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            return [UIImage imageWithCGImage:[representation fullScreenImage] scale:scale orientation:UIImageOrientationUp];
        }
        case kPBAssetImageResolutionFullsize:
        {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            return [UIImage imageWithCGImage:[representation fullResolutionImage] scale:scale orientation:UIImageOrientationUp];
        }
        default:
            return [UIImage imageWithCGImage:asset.thumbnail scale:scale orientation:UIImageOrientationUp];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<FetchImageTask = %@>", [super description]];
}

@end
