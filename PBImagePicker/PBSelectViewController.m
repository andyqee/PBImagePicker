//
//  PBSelectViewController.m
//  PhotoBook
//
//  Created by andy on 21/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBSelectViewController.h"
#import "PBAssetPickerController.h"
#import "PBAssetAlbumPickerController.h"
#import "PBImagePickerCoordinator.h"

#import "PBImageScrollView.h"
#import "UIView+Position.h"
#import "PBImageManager.h"

static NSTimeInterval childViewControllerTransitionDuration = 0.3;
static NSInteger kBackgroundScrollViewTag = 1;
static NSInteger kImageScrollViewTag = 2;
static NSInteger kAssetPickerCollectionViewTag = 3;
static NSInteger kAssetAblumPickerTableViewTag = 4;


@interface PBSelectViewController ()<PBAssetPickerControllerDelegate,
                                     PBAssetAlbumPickerControllerDelegate,
                                     UIScrollViewDelegate>

// for display selected photo
@property (nonatomic, strong) PBImageScrollView *imageScrollView;

@property (nonatomic, strong) UIView *handleBar;

@property (nonatomic, strong) PBAssetAlbumPickerController *albumPickerController;
@property (nonatomic, strong) PBAssetPickerController *pickerController;

@property (nonatomic, strong) ALAsset *selectedAsset;

@property (nonatomic) BOOL isPickerAnimating;

@end

@implementation PBSelectViewController
{
    PBImagePickerCoordinator *_coordinator;
}

- (PBAssetAlbumPickerController *)albumPickerController {
    if (_albumPickerController == nil) {
        _albumPickerController = [[PBAssetAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
        _albumPickerController.delegate = self;
        _albumPickerController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _albumPickerController;
}

- (PBAssetPickerController *)pickerController {
    if (_pickerController == nil) {
        _pickerController = [PBAssetPickerController defaultController];
        _pickerController.pbDelegate = self;
        _pickerController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _pickerController;
}

#pragma mark - Life cycle

- (void)loadView
{
    [super loadView];
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [PBGeneralHelper screenWidth], [PBGeneralHelper screenHeight])];
//    scrollView.delegate = self;
//    self.view = scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizesSubviews = YES;
    
    [self _setupNavigationBar];
    [self _loadImageScrollView];
    [self _setupHandleBar];
    [self _loadAssetPickerComponent];
}

- (void)leftButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightButtonAction:(id)sender
{
    //TODO:
//    PBPhotoFilterViewController *viewController = [[PBPhotoFilterViewController alloc] init];
//    CGFloat ratio = self.imageScrollView.zoomScale;
//    UIImage *image = [_imageScrollView.image crop:CGRectMake(_imageScrollView.contentOffset.x *ratio, _imageScrollView.contentOffset.y *ratio, _imageScrollView.frameWidth *ratio, _imageScrollView.frameHeight *ratio)];
//    viewController.inputImage = image;
//    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return (scrollView.tag == kBackgroundScrollViewTag);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag == kImageScrollViewTag)
    {
       return ((PBImageScrollView *)scrollView).imageView;
    }
    return nil;
}

#pragma mark - PBAssetPickerControllerDelegate

- (void)didSelectAsset:(ALAsset *)asset
{
    if (_selectedAsset == asset) {
        return;
    }
    _selectedAsset = asset;
    [[PBImageManager sharedManager] fetchImageWithAssets:@[asset]
                                          resolutionType:kPBAssetImageResolutionFullscreen
                                              completion:^(NSArray *images, NSError *error) {
                                                  if (error) {
                                                      // Handle error
                                                  }
                                                  if (images) {
                                                      _imageScrollView.image = [images firstObject];
                                                  }
                                              }];
}

- (void)assetsDidLoad:(ALAsset *)asset
{
    [self didSelectAsset:asset];
}

- (void)didSelectBackButtonAtAssetPicker:(PBAssetPickerController *)pickerController
{
    CGRect destionationFrameA = pickerController.view.frame;
    self.albumPickerController.view.frame = CGRectMake(-destionationFrameA.size.width, destionationFrameA.origin.y, destionationFrameA.size.width, destionationFrameA.size.height);
    self.albumPickerController.view.tag = kAssetAblumPickerTableViewTag;
    
    [self addChildViewController:self.albumPickerController];
    [_pickerController willMoveToParentViewController:nil];
    
    __weak typeof(self) weakSelf = self;
    [self transitionFromViewController:self.pickerController
                      toViewController:self.albumPickerController
                              duration:childViewControllerTransitionDuration 
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                   
                                   weakSelf.albumPickerController.view.frameX = 0;
                                   weakSelf.pickerController.view.frameX = destionationFrameA.size.width;
                                   
                          } completion:^(BOOL finished) {
                              
                              [self.albumPickerController didMoveToParentViewController:self];
                              [self.pickerController removeFromParentViewController];
                              [self.view addSubview:self.albumPickerController.view];
    }];
}

#pragma mark - PBAssetAlbumPickerControllerDelegate

- (void)viewController:(PBAssetAlbumPickerController *)viewController didSelectGroup:(ALAssetsGroup *)group
{
    CGRect destionationFrameA = viewController.view.frame;
    self.pickerController.view.frame = CGRectMake(destionationFrameA.size.width, destionationFrameA.origin.y, destionationFrameA.size.width, destionationFrameA.size.height);
    self.pickerController.assetGroup = group;
    
    [self addChildViewController:self.pickerController];
    [viewController willMoveToParentViewController:nil];
    
    __weak typeof(self) weakSelf = self;
    [self transitionFromViewController:viewController
                      toViewController:self.pickerController
                              duration:childViewControllerTransitionDuration
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                   
                                   viewController.view.frameX = - destionationFrameA.size.width;
                                   weakSelf.pickerController.view.frameX = 0;
                                   
                          } completion:^(BOOL finished) {
                              
                              [self.pickerController didMoveToParentViewController:self];
                              [viewController removeFromParentViewController];
                              [self.view addSubview:self.pickerController.view];
    }];
}

#pragma mark - Private setup method

- (void)_loadImageScrollView
{
    _imageScrollView = [[PBImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, self.view.frameWidth)];
    _imageScrollView.backgroundColor = [UIColor grayColor];
    _imageScrollView.delegate = self;
    _imageScrollView.tag = kImageScrollViewTag;
    _imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _imageScrollView.contentInset = UIEdgeInsetsZero;
    _imageScrollView.contentOffset = CGPointZero;

    [self.view addSubview:_imageScrollView];
}

- (void)_setupNavigationBar
{
    [self addLeftButton:@"CANCEL"
               withFont:[UIFont systemFontOfSize:13.0]
                  Color:[UIColor redColor]
               selector:@selector(leftButtonAction:)];
        
    self.title = @"SELECT";
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)_setupHandleBar
{
    _handleBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frameWidth, self.view.frameWidth, 40)];
    _handleBar.backgroundColor = [UIColor blackColor];
    _handleBar.alpha = 0.5;
    
    UITapGestureRecognizer *tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(gestureHandler:)];
//    UIPanGestureRecognizer *panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                    action:@selector(gestureHandler:)];
    [_handleBar addGestureRecognizer:tapGestureRec];
//    [_handleBar addGestureRecognizer:panGestureRec];
    
    [self.view addSubview:_handleBar];
}

- (void)_loadAssetPickerComponent
{
    self.pickerController.view.frame = CGRectMake(0, _handleBar.frameBottom, self.view.frameWidth, self.view.frameHeight - _handleBar.frameBottom);
    self.pickerController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self addChildViewController:self.pickerController];
    [self.pickerController didMoveToParentViewController:self];
    [self.view addSubview:self.pickerController.view];
    self.pickerController.view.tag = kAssetPickerCollectionViewTag;
}

#pragma mark - Gesture Handler 

- (void)gestureHandler:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]])
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            [self _tapGestureHandler];
        }
    }
    else if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]])
    {
        [self _panGestureHanler:(UIPanGestureRecognizer *)gestureRecognizer];
    }
}

- (void)_tapGestureHandler
{
    if (_isPickerAnimating)
    {
        return ;
    }
    
    CGFloat orginYStart = (self.navigationController.navigationBar.translucent ? 0 : 64 );
    CGFloat offSetY = - self.view.frameWidth;
    CGFloat originYEnd  = orginYStart + offSetY;
    
    BOOL sholudMoveUp   = (self.view.frameY == orginYStart);
    
    CGFloat prevViewHeight = self.view.frameHeight;

    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:10
          initialSpringVelocity:6
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         _isPickerAnimating = YES;
                         if (sholudMoveUp) {
                             self.view.frameHeight = prevViewHeight + ABS(offSetY);
                         }
                         self.view.frameY = sholudMoveUp ? originYEnd : orginYStart;

                   } completion:^(BOOL finished) {
                       
                       _isPickerAnimating = NO;
                       if (sholudMoveUp == NO) {
                           self.view.frameHeight = prevViewHeight - ABS(offSetY);
                       }
    }];
}

- (void)_panGestureHanler:(UIPanGestureRecognizer *)gesture
{
    /**

    CGFloat orginYStart = (self.navigationController.navigationBar.translucent ? 0 : 64 );
    CGFloat offSetY = - self.view.frameWidth;
    CGFloat originYEnd  = orginYStart + offSetY;
    
    CGFloat currentY = [gesture locationInView:self.view].y;
    //TODO:
    if (currentY < orginYStart || currentY > orginYStart + ABS(offSetY)) {
        return;
    }

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self _animateViewWithGesture:gesture];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self _animateViewToFinalStateWithGesture:gesture
                                     withOriginYStart:orginYStart
                                        andOriginYEnd:originYEnd];
            break;
        }
        default:
            break;
    }
     **/
}
/**
- (void)_animateViewWithGesture:(UIPanGestureRecognizer *)gesture
{
    UIView *rootView = self.view;
    if (rootView.superview != nil) {
        rootView = rootView.superview;
    }
    
    CGFloat translationY = [gesture translationInView:rootView].y;
    
    self.view.center = (CGPoint){ self.view.center.x ,   // x direction should not change
                                  self.view.center.y + translationY };
    
    self.view.frameHeight = self.view.frameHeight - translationY;
}

- (void)_animateViewToFinalStateWithGesture:(UIPanGestureRecognizer *)gesture
                           withOriginYStart:(CGFloat)max_originY
                              andOriginYEnd:(CGFloat)min_originY
{
    CGFloat velocityY = [gesture velocityInView:self.view].y;
    CGFloat originHeightOfView = [PBGeneralHelper screenHeight] - max_originY;
    
    if (velocityY == 0)
    {
        
    }
    else
    {
        CGFloat k = ([gesture locationInView:self.view].y - ABS(min_originY)) / (max_originY - ABS(min_originY));
        k = ( velocityY < 0 ) ?: 1 - k;
        
        CGFloat duration = 0.6 * k;
        
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:10
              initialSpringVelocity:velocityY
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             _isPickerAnimating = YES;
                             self.view.frameHeight = (velocityY > 0) ? originHeightOfView : originHeightOfView + (max_originY - min_originY);
                             self.view.frameY = (velocityY > 0) ? min_originY : max_originY;
                             
                             for (UIView *view in [self.view subviews]) {
                                 if (view.tag == kAssetAblumPickerTableViewTag || view.tag == kAssetPickerCollectionViewTag) {
                                    
                                 }
                             }
                             
                         } completion:^(BOOL finished) {
                             _isPickerAnimating = NO;
                         }];
    }
}
**/

- (void)addLeftButton:(NSString *)title withFont:(UIFont *)font Color:(UIColor *)color selector:(SEL)selector
{
    UIBarButtonItem *customButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:selector];
    customButtonItem.tintColor = color;
    
    [self.navigationItem setLeftBarButtonItem:customButtonItem animated:YES];
}

@end
