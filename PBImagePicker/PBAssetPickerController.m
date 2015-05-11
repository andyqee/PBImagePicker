//
//  PBAssetPickerController.m
//  PhotoBook
//
//  Created by andy on 22/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAssetPickerController.h"
#import "PhotoBook_Util.h"
#import "PBAssetPickerHeaderView.h"
#import "PBAssetLayout.h"
#import "PBImageManager.h"
#import "UIImageView+PBImageFetcher.h"
#import "PBImagePickerCoordinator.h"
#import "PBUtils.h"

static NSString * const reuseIdentifier = @"PBAssetCollectionViewCell";
static NSString * const headerViewReuseIdentifier = @"PBAssetPickerHeaderView";

@interface PBAssetCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PBAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        [self _initSubviews];
    }
    return self;
}

- (void)_initSubviews {
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    [self.contentView addSubview:_imageView];
}

@end

@interface PBAssetPickerController ()<PBAssetPickerHeaderViewDelegate>

@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) id fetchAssetGroupRequest;
@property (nonatomic, strong) id fetchAssetsRequest;

@end

@implementation PBAssetPickerController
{
    PBImagePickerCoordinator *_coordinator;
    UIButton *_cammeraButton;
    
}

+ (instancetype)defaultController
{
    PBAssetLayout *layout = [[PBAssetLayout alloc] init];
    PBAssetPickerController *instance = [[PBAssetPickerController alloc] initWithCollectionViewLayout:layout];
    return instance;
}

- (void)loadView
{
    [super loadView];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pbAssets = [NSMutableArray array];
    self.clearsSelectionOnViewWillAppear = NO;

    [self _setupCollectionView];
    [self _loadAssetsFromGroup];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        if ([self.collectionView numberOfItemsInSection:0] > 0) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                              animated:NO
                                        scrollPosition:UICollectionViewScrollPositionTop];
        }
    });
    [self _setupNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addCammeraButtonToWindow];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeCammeraButton];
}

- (void)addCammeraButtonToWindow
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:imageWithColorAndSize([UIColor redColor], (CGSize){40, 40}) forState:UIControlStateNormal];
    button.frame = CGRectMake(15, screenHeight() - 50, 40, 40);
    button.alpha = 0;
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self->_cammeraButton = button;
    
    [[UIApplication sharedApplication].keyWindow addSubview:button];
    
    [UIView animateWithDuration:0.6 animations:^{
        button.alpha = 1;
    }];
}

- (void)removeCammeraButton
{
    [_cammeraButton removeFromSuperview];
}

- (void)buttonAction
{
    if (isCameraAvailable()) {
        _coordinator = [PBImagePickerCoordinator new];
        [self presentViewController:[_coordinator cameraVC] animated:YES completion:nil];
    } else {
        NSLog(@"Camera not available");
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ALAssetsLibraryChangedNotification
                                                  object:nil];
}

- (void)_setupCollectionView
{
    [self.collectionView registerClass:[PBAssetCollectionViewCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[PBAssetPickerHeaderView class]
            forSupplementaryViewOfKind:viewKindForSupplementaryElementOfHeader
                   withReuseIdentifier:headerViewReuseIdentifier];
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.scrollEnabled = YES;
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)_loadAssetsFromGroup
{
    if (self.assetGroup == nil) {
        [self _loadDefaultAssetsGroupFromLibrary];
    } else {
        [self _loadAssetsFromAssetsGroup:self.assetGroup];
    }
}

- (void)_setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateAssetPickerView:)
                                                 name:ALAssetsLibraryChangedNotification
                                               object:nil];
}

#pragma mark - setter/getter

- (void)setAssetGroup:(ALAssetsGroup *)assetGroup
{
    if (_assetGroup == assetGroup) {
        return;
    }
    _assetGroup = assetGroup;
    [self _loadAssetsFromAssetsGroup:_assetGroup];;
}

- (void)_updateAssetPickerView:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    if (!info) {
        [self.pbAssets removeAllObjects];
    }
    NSString *groupURL = [self.assetGroup valueForProperty:ALAssetsGroupPropertyURL];
    
    NSSet *updatedAssetGroupKey = info[ALAssetLibraryUpdatedAssetGroupsKey];
    if (![updatedAssetGroupKey containsObject:groupURL]) {
        return;
    }
    
    NSSet *updatedAssetsKey = info[ALAssetLibraryUpdatedAssetsKey];
    if (updatedAssetsKey.count > 0) {
        [self _loadAssetsFromAssetsGroup:self.assetGroup];
    }
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ([self.pbAssets count] ?: 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PBAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                forIndexPath:indexPath];
    //FIXME: ocationlly it will crash here
    
    ALAsset *asset = self.pbAssets[indexPath.row];
    //TODO: improve
    // every time the cell was scrolled to the visiable scale, the method would be invoked. That is not perfect.
    // But if I cache the image there ,it will cost the memeory, it an cpu and memeory balance art. It's very fantastic to discover the perfect balance.
    [cell.imageView setImageWithAsset:asset withResolution:kPBAssetImageResolutionThumbnail];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PBAssetPickerHeaderView *headerView;
    headerView = [collectionView dequeueReusableSupplementaryViewOfKind:viewKindForSupplementaryElementOfHeader
                                                    withReuseIdentifier:headerViewReuseIdentifier
                                                            forIndexPath:indexPath];
    headerView.titleLabel.text = [self.assetGroup valueForProperty:ALAssetsGroupPropertyName];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.delegate = self;
    
    return headerView;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.pbDelegate respondsToSelector:@selector(didSelectAsset:)]) {
        ALAsset *asset = self.pbAssets[indexPath.row];
        [self.pbDelegate didSelectAsset:asset];
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)didClickLeftBackButton:(PBAssetPickerHeaderView *)headerView
{
    if ([self.pbDelegate respondsToSelector:@selector(didSelectBackButtonAtAssetPicker:)]) {
        [self.pbDelegate didSelectBackButtonAtAssetPicker:self];
    }
}

#pragma mark - load asset resource

- (void)_loadDefaultAssetsGroupFromLibrary
{
    __weak typeof(self) weakSelf = self;
    _fetchAssetGroupRequest = [[PBImageManager sharedManager] fetchAssetsGroups:ALAssetsGroupSavedPhotos
                                                                completion:^(NSArray *groups, NSError *error) {
                                                                    if (error) {
                                                                        //Handl error
                                                                        NSLog(@"error %@", [error localizedDescription]);
                                                                    }
                                                                    if (!groups) {
                                                                        NSLog(@"NO groups fetched");
                                                                        return ;
                                                                    }
                                                                    for (ALAssetsGroup *group in groups) {
                                                                        NSString *groupPropertyName = [group valueForProperty:ALAssetsGroupPropertyName];
                                                                        if ([groupPropertyName isEqualToString:@"Camera Roll"]) {
                                                                            weakSelf.assetGroup = group;
                                                                            return ;
                                                                        }
                                                                    }
                                                                }];
}

- (void)_loadAssetsFromAssetsGroup:(ALAssetsGroup *)assetGroup
{
    if( [_pbAssets count] != 0 ) {
        [_pbAssets removeAllObjects];
    }
    __weak typeof(self) weakSelf = self;
    _fetchAssetsRequest = [[PBImageManager sharedManager] fetchAssetsInGroups:assetGroup
                                                                   completion:^(NSArray *assets, NSError *error) {
                                                                       if (error) {
                                                                           NSLog(@"error %@", [error localizedDescription]);
                                                                       }
                                                                       if (assets == nil || [assets count] == 0) {
                                                                           return ;
                                                                       }
                                                                       __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                       [strongSelf.pbAssets addObjectsFromArray:assets];
                                                                       if ([strongSelf.pbDelegate respondsToSelector:@selector(assetsDidLoad:)]) {
                                                                           [strongSelf.pbDelegate assetsDidLoad:assets[0]];
                                                                           //这行代码是否应该用KVO 来更好的实现
                                                                           [strongSelf.collectionView reloadData];
                                                                       }
                                                                   }];
}

- (void)_addAssetsGroupAlbum:(NSString *)albumName ToLibrary:(ALAssetsLibrary *)assetsLibrary
{
    if (assetsLibrary == nil || albumName == nil) {
        return;
    }
    [assetsLibrary addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
        NSLog(@"success to add assetsGroupAlbum");
        
    } failureBlock:^(NSError *error) {
        NSLog(@"fail to add assetsGroupAlbum \n error: %@", [error localizedDescription]);
        
    }];
}

static BOOL isCameraAvailable() {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end
