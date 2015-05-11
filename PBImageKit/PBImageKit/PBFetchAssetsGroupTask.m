//
//  PBFetchImageTask.m
//  PhotoBook
//
//  Created by andy on 6/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAssetsGroupRequest.h"
#import "ALAssetsLibrary+sharedInstance.h"
#import "PBFetchAssetsGroupTask.h"

@interface PBFetchAssetsGroupTask()

@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic, getter = isFinished) BOOL finished;

@property (nonatomic, readwrite) NSMutableArray *groups;
@property (nonatomic, readwrite) NSError *error;

@end


@implementation PBFetchAssetsGroupTask
{
    PBAssetsGroupRequest *_request;
}

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRequest:(PBAssetsGroupRequest *)request
{
    if (self = [super init]) {
        _request = request;
        _groups = [NSMutableArray array];
    }
    return self;
}

- (void)start
{
    self.executing = YES;
    if (self.isCancelled) {
        [self finish];
    } else {
        [[ALAssetsLibrary sharedInstance] enumerateGroupsWithTypes:_request.type
                                                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                                            if (group) {
                                                                [_groups addObject:group];
                                                            } else {
                                                                [self finish];
                                                                *stop = YES;
                                                            }
                                                            
                                                    } failureBlock:^(NSError *error) {
                                                        NSLog(@"Fail to enumerate groups with Type %@", [error debugDescription]);
                                                        self.error = error;
                                                        [self finish];
        }];
    }
}

- (void)finish
{
    if (_executing) {
        self.executing = NO;
    }
    self.finished = YES;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    PBAssetsGroupRequest *task = [[[self class] allocWithZone:zone] initWithRequest:self.request];
//    task.completionQueue = self.completionQueue;
    return task;
}

#pragma KVO

- (void)setFinished:(BOOL)finished
{
    if (finished != _finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (void)setExecuting:(BOOL)executing
{
    if (executing != _executing ) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<FetchAssetsGroup = %@>", [super description]];
}

@end
