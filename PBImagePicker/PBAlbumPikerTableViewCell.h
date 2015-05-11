//
//  PBAlbumPikerTableViewCell.h
//  PhotoBook
//
//  Created by andy on 25/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsGroup;

@interface PBAlbumPikerTableViewCell : UITableViewCell

- (void)configureCell:(ALAssetsGroup *)assetsGroup;

@end
