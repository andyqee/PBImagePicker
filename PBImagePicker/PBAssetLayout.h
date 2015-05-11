//
//  PBAssetLayout.h
//  PhotoBook
//
//  Created by andy on 22/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const viewKindForSupplementaryElementOfHeader =  @"viewForSupplementaryElementOfHeader";
static CGFloat const kHeaderViewHeight = 44.0f;

@interface PBAssetLayout : UICollectionViewFlowLayout

@property (nonatomic, readonly) NSInteger numbersOfElement;
@property (nonatomic, assign) NSInteger numbersPerRow;

@end
