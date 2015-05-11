//
//  PBAssetDataSource.h
//  PhotoBook
//
//  Created by andy on 25/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAssetsGroup, PBAlbumPikerTableViewCell;

typedef void (^ConfigureCellBlock)(PBAlbumPikerTableViewCell *cell, ALAssetsGroup *group);

@interface PBAssetDataSource : NSObject<UITableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)identifier
           configureCellBlock:(ConfigureCellBlock)configureCellBlock;

- (void)replaceWithNewItems:(NSArray *)items;

@end
