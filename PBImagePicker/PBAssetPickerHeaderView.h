//
//  PBAssetPickerHeaderView.h
//  PhotoBook
//
//  Created by andy on 26/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBAssetPickerHeaderViewDelegate;

@interface PBAssetPickerHeaderView : UICollectionReusableView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, weak) id<PBAssetPickerHeaderViewDelegate> delegate;

@end

@protocol PBAssetPickerHeaderViewDelegate <NSObject>
- (void)didClickLeftBackButton:(PBAssetPickerHeaderView *)headerView;

@end