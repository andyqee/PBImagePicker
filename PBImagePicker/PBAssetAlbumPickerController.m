//
//  PBAssetAlbumPickerController.m
//  PhotoBook
//
//  Created by andy on 22/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAssetAlbumPickerController.h"
#import "PBAssetPickerController.h"
#import "PBAssetDataSource.h"
#import "PBAlbumPikerTableViewCell.h"
#import "PBImageManager.h"

#import "PBFetchAssetsGroupTask.h"
#import "PBUtils.h"

static NSString * const cellIdentifier = @"PBAlbumPikerTableViewCell";

@interface PBAssetAlbumPickerController ()

@property (nonatomic, strong) PBAssetDataSource *assetDataSource;
@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, strong) PBFetchAssetsGroupTask *imageTask;

@end

@implementation PBAssetAlbumPickerController

- (void)loadView
{
    [super loadView];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.assetGroups = [@[] mutableCopy];
    
    self.clearsSelectionOnViewWillAppear = NO;
    [self _loadAssetsGroups];
    [self _setupNotification];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ALAssetsLibraryChangedNotification
                                                  object:nil];
}

#pragma mark - set up notification

- (void)_setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateAlbumPickerView:)
                                                 name:ALAssetsLibraryChangedNotification
                                               object:nil];
}

- (void)_updateAlbumPickerView:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    if (!info) {
        [self.assetGroups removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        return;
    }
    
    NSSet *deletedAssetGroupKey = info[ALAssetLibraryDeletedAssetGroupsKey];
    NSSet *insertedAssetGroupKey = info[ALAssetLibraryInsertedAssetGroupsKey];
    NSSet *updatedAssetGroupKey = info[ALAssetLibraryUpdatedAssetGroupsKey];
    
    if ([deletedAssetGroupKey count] > 0 || [insertedAssetGroupKey count] > 0 || [updatedAssetGroupKey count] > 0) {
        _imageTask = [[PBImageManager sharedManager] fetchAssetsGroups:ALAssetsGroupAll
                                                            completion:^(NSArray *groups, NSError *error) {
                                                                if (error) {
                                                                    
                                                                }
                                                                self.assetGroups = [groups mutableCopy];
                                                                [self.assetDataSource replaceWithNewItems:[groups copy]];
                                                                PBPerformBlockOnMainThread(^{
                                                                    [self.tableView reloadData];
                                                                });
                                                            }];
    }
}

#pragma mark - load assetGroup

- (void)_loadAssetsGroups
{
   _imageTask = [[PBImageManager sharedManager] fetchAssetsGroups:ALAssetsGroupAll
                                                       completion:^(NSArray *groups, NSError *error) {
                                                           if (error) {
            
                                                           }
                                                           self.assetGroups = [groups mutableCopy];
                                                           [self _setupTableView];
                                                       }];
}

#pragma mark - setup TableView

- (void)_setupTableView
{
    ConfigureCellBlock configureCell = ^(PBAlbumPikerTableViewCell *cell, ALAssetsGroup *assetsGroup) {
        [cell configureCell:assetsGroup];
    };
    NSArray *items = self.assetGroups;
    self.assetDataSource = [[PBAssetDataSource alloc] initWithItems:items
                                                     cellIdentifier:cellIdentifier
                                                 configureCellBlock:configureCell];
    self.tableView.dataSource = self.assetDataSource;
    [self.tableView registerClass:[PBAlbumPikerTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ALAssetsGroup *group = self.assetGroups[indexPath.row];

    if ([_delegate respondsToSelector:@selector(viewController:didSelectGroup:)]) {
        [_delegate viewController:self didSelectGroup:group];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
