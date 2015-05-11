//
//  PBImageManager.m
//  PhotoBook
//
//  Created by andy on 12/3/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBImageManager.h"
#import "PBFetchAssetsGroupTask.h"
#import "PBFetchAssetsTask.h"
#import "PBFetchImageTask.h"

#import "PBAssetsGroupRequest.h"
#import "PBAssetsRequest.h"
#import "PBFetchImageRequest.h"
#import "ALAssetsLibrary+sharedInstance.h"

@implementation PBImageManager
{
    NSOperationQueue *_operationQueue;
}

+ (instancetype)sharedManager
{
    static PBImageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PBImageManager new];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _operationQueue = [NSOperationQueue new];
    }
    return self;
}

- (PBFetchAssetsGroupTask *)fetchAssetsGroups:(ALAssetsGroupType)groupType
                             completion:(void(^)(NSArray *groups, NSError *error))completion
{
    PBAssetsGroupRequest *request = [PBAssetsGroupRequest newAssetsGroupRequestWithType:groupType];
    //这个里面没有体现出 request 的作用
    PBFetchAssetsGroupTask *task = [[PBFetchAssetsGroupTask alloc] initWithRequest:request];
    
    PBFetchAssetsGroupTask __weak *weakTask = task;
    
    [task setCompletionBlock:^{
        dispatch_async(weakTask.completionQueue ?: dispatch_get_main_queue(), ^{
            if (completion) {
                completion(weakTask.groups, weakTask.error);
            }
        });
    }];
    
    task.completionQueue = self.completionQueue;
    [_operationQueue addOperation:task];
    return task;
}

- (PBFetchAssetsTask *)fetchAssetsInGroups:(ALAssetsGroup *)group
                               completion:(void (^)(NSArray *assets, NSError *error))completion
{
    PBAssetsRequest *request = [PBAssetsRequest newWithAssetGroup:group
                                              withEnumerateOptions:NSEnumerationReverse];
    
    PBFetchAssetsTask *task = [[PBFetchAssetsTask alloc] initWithRequest:request];
    PBFetchAssetsTask __weak *weakTask = task;
    
    [task setCompletionBlock:^{
        dispatch_async(weakTask.completionQueue ?: dispatch_get_main_queue(), ^{
            if (completion) {
                completion(weakTask.assets, weakTask.error);
            }
        });
    }];
    
    task.completionQueue = self.completionQueue;
    [_operationQueue addOperation:task];
    return task;
}

- (PBFetchImageTask *)fetchImageWithAssets:(NSArray *)assets
                            resolutionType:(PBAssetImageResolution)type
                                completion:(void (^)(NSArray *images, NSError *error))completion
{
    PBFetchImageRequest *request = [PBFetchImageRequest newWithALAssets:assets andImageResolution:type];
    PBFetchImageTask *task = [self _fetchImageTaskWithReqeust:request completion:completion];
    
    [_operationQueue addOperation:task];
    return task;
}

- (PBFetchImageTask *)_fetchImageTaskWithReqeust:(PBFetchImageRequest *)request
                                      completion:(void (^)(NSArray *images, NSError *error))completion
{
    PBFetchImageTask *task = [[PBFetchImageTask alloc] initWithRequest:request];
    PBFetchImageTask __weak *weakTask = task;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    
    [task setCompletionBlock:^{
        dispatch_async(weakTask.completionQueue ?: dispatch_get_main_queue(), ^{
            if (completion) {
                // we use strong refrence to prevent the task be released before run the completion block, and manualy set completion block to nil in the PBFetchImageTask
                completion(task.images, task.error);
            }
        });
    }];
    return task;
    
#pragma clang diagnostic pop

}

@end
