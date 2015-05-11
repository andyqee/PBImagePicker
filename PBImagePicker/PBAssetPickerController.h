//
//  PBAssetPickerController.h
//  PhotoBook
//
//  Created by andy on 22/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol PBAssetPickerControllerDelegate;

@interface PBAssetPickerController : UICollectionViewController
+ (instancetype)defaultController;

@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) NSMutableArray *pbAssets;

@property (nonatomic, weak) id<PBAssetPickerControllerDelegate> pbDelegate;

@end

@protocol PBAssetPickerControllerDelegate <NSObject>

- (void)didSelectAsset:(ALAsset *)asset;

- (void)didSelectBackButtonAtAssetPicker:(PBAssetPickerController *)pickerController;

//return the first asset in the asset group
- (void)assetsDidLoad:(ALAsset *)asset;

@end