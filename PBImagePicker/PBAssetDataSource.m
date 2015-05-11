//
//  PBAssetDataSource.m
//  PhotoBook
//
//  Created by andy on 25/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAssetDataSource.h"
#import "PBAlbumPikerTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PBAssetDataSource()
@property (nonatomic, copy) ConfigureCellBlock configureCellBlock;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSArray *items;

@end

@implementation PBAssetDataSource

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)identifier
           configureCellBlock:(ConfigureCellBlock)configureCellBlock {
    if (self = [super init]) {
        _items = items;
        _identifier = identifier;
        _configureCellBlock = [configureCellBlock copy];
    }
    return self;
}

- (void)replaceWithNewItems:(NSArray *)items
{
    _items = items;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBAlbumPikerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
    ALAssetsGroup *group = _items[indexPath.row];
    if (_configureCellBlock) {
        _configureCellBlock(cell, group);
    }
    return cell;
}

@end
