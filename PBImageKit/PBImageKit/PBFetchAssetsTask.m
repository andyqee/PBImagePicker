//
//  PBFetchAssetsTask.m
//  PhotoBook
//
//  Created by andy on 7/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBFetchAssetsTask.h"
#import "PBAssetsRequest.h"
#import "ALAssetsLibrary+sharedInstance.h"

@interface PBFetchAssetsTask()

@property (nonatomic, readwrite) NSMutableArray *assets;

@property (nonatomic, readwrite) NSError *error;

@property (nonatomic, readwrite) PBAssetsRequest *request;

@end

@implementation PBFetchAssetsTask

- (instancetype)initWithRequest:(PBAssetsRequest *)request
{
    if (self = [super init]) {
        _request = request;
        _assets = [NSMutableArray array];
    }
    return self;
}

- (void)main
{
    if (!self.isCancelled) {
        __weak typeof(self) weakSelf = self;
        [_request.assetGroup enumerateAssetsWithOptions:_request.options
                                             usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                 if (result == nil) {
                                                     return ;
                                                 }
                                                 [weakSelf.assets addObject:result];
                                             }];
    }
}

/**
 *  As the operation is not concurrent, so isFinished and isExecuting should not be override;
 *
 */

- (BOOL)isConcurrent
{
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<FetchAssetTask = %@>", [super description]];
}

@end
