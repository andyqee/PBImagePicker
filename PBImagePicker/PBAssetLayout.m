//
//  PBAssetLayout.m
//  PhotoBook
//
//  Created by andy on 22/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAssetLayout.h"
#import "PhotoBook_Util.h"

@interface PBAssetLayout()

@property (nonatomic, readwrite) NSInteger numbersOfElement;

@end

@implementation PBAssetLayout

- (instancetype)init
{
    self = [super init];
    if (self == nil)
    {
        return self;
    }
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumLineSpacing = 1.0;
    self.minimumInteritemSpacing = 1.0;
    self.numbersPerRow = 4;
    CGFloat width = (ScreenWidth - 3) / self.numbersPerRow;
    self.itemSize = CGSizeMake(width ,width);
    self.headerReferenceSize = CGSizeMake(0, kHeaderViewHeight);
    
    return self;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes;
    attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:viewKindForSupplementaryElementOfHeader withIndexPath:indexPath];
    attributes.frame = CGRectMake(0, 0, ScreenWidth, kHeaderViewHeight);
    
    return attributes;
}

- (CGSize)collectionViewContentSize
{
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    NSAssert(self.numbersPerRow != 0, @"numbers Of Elemenet Per row shoul not be 0");
    
    self.numbersOfElement = [self.collectionView numberOfItemsInSection:0];
    NSInteger temp = self.numbersOfElement / self.numbersPerRow;
    NSInteger row = (self.numbersOfElement % self.numbersPerRow == 0) ? temp : temp + 1;
    CGFloat contentHeight = 2 * kHeaderViewHeight + row * (self.itemSize.height + self.minimumInteritemSpacing );  // 这里为什么是两倍的 高度差呢，为什么不是一倍呢
    
    return CGSizeMake(contentWidth, contentHeight);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    return (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds));
}

@end
