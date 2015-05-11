//
//  PBImagePickerCoordinator.m
//  PhotoBook
//
//  Created by andy on 23/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBImagePickerCoordinator.h"
#import "PBSelectViewController.h"
#import "ALAssetsLibrary+sharedInstance.h"
#import "PBAssetLibraryUtil.h"
#import "UIImage+fix_rotation.h"
#import "PBUtils.h"

@interface PBImagePickerCoordinator() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation PBImagePickerCoordinator
{
    UIImagePickerController *_camera;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        _camera = [self _setupImagePicker];
        [self _setUpCustomerUIOnImagePicker];
    }
    return self;
}

- (UIImagePickerController *)cameraVC
{
    return _camera;
}

#pragma mark - Private methods

- (UIImagePickerController *)_setupImagePicker
{
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.modalPresentationStyle = UIModalPresentationCurrentContext;
    camera.allowsEditing = YES;
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    camera.delegate = self;
    return camera;
}

- (void)_setUpCustomerUIOnImagePicker
{
    
}

- (void)rightButtonAction:(id)sender
{
    PBSelectViewController *selector = [PBSelectViewController new];
    [_camera pushViewController:selector animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        [PBAssetLibraryUtil addImage:image
                         orientation:ALAssetOrientationUp
                             toAlbum:@"PhotoBook"
                     completionBlock:^(NSURL *assetURL, NSError *error) {
                         NSLog(@"Save Image To PhotoBook Succesllfully");
                         PBPerformBlockOnMainThread(^{
                             [picker dismissViewControllerAnimated:YES completion:nil];
                         });

                     } failureBlock:^(NSError *error) {
                         NSLog(@"Save Image To PhotoBook failed");
                         PBPerformBlockOnMainThread(^{
                             [picker dismissViewControllerAnimated:YES completion:nil];
                         });

        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
