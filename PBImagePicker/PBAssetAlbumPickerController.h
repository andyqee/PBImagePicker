//
//  PBAssetAlbumPickerController.h
//  PhotoBook
//
//  Created by andy on 22/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBAssetAlbumPickerControllerDelegate;
@class ALAssetsGroup;

@interface PBAssetAlbumPickerController : UITableViewController
@property (nonatomic, weak) id<PBAssetAlbumPickerControllerDelegate> delegate;

@end

@protocol PBAssetAlbumPickerControllerDelegate <NSObject>
- (void)viewController:(PBAssetAlbumPickerController *)viewController didSelectGroup:(ALAssetsGroup *)group;

@end