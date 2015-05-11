//
//  PBAssetLibraryUtil.m
//  PhotoBook
//
//  Created by andy on 3/3/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAssetLibraryUtil.h"
#import <CoreImage/CoreImage.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+sharedInstance.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation PBAssetLibraryUtil

+ (void)addImage:(UIImage *)image
        metaData:(NSDictionary *)metaData
         toAlbum:(NSString *)albumName
 completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock
    failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock
{
    [[ALAssetsLibrary sharedInstance] writeImageToSavedPhotosAlbum:image.CGImage
                                                          metadata:metaData
                                                   completionBlock:^(NSURL *assetURL, NSError *error) {
                                                       
                                                       [self addAssetURL:assetURL toAlbum:albumName completionBlock:^(NSURL *assetURL, NSError *error) {
                                                           if (completionBlock != nil) {
                                                               completionBlock(assetURL, nil);
                                                           }
                                                       } failureBlock:^(NSError *error) {
                                                           if (failureBlock != nil) {
                                                               failureBlock(error);
                                                           }
                                                       }];

    }];
}

+ (void)addImage:(UIImage *)image
     orientation:(ALAssetOrientation)orientation
         toAlbum:(NSString *)albumName
 completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock
    failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock
{
    [[ALAssetsLibrary sharedInstance] writeImageToSavedPhotosAlbum:image.CGImage
                                                       orientation:orientation
                                                   completionBlock:^(NSURL *assetURL, NSError *error) {
                                                       [self addAssetURL:assetURL toAlbum:albumName completionBlock:^(NSURL *assetURL, NSError *error) {
                                                           if (completionBlock != nil) {
                                                               completionBlock(assetURL, nil);
                                                           }
                                                       } failureBlock:^(NSError *error) {
                                                           if (failureBlock != nil) {
                                                               failureBlock(error);
                                                           }
                                                       }];
    }];
}

+ (void)addImage:(UIImage *)image toAlbum:(NSString *)albumName completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock
{
    [[ALAssetsLibrary sharedInstance] writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        [self addAssetURL:assetURL toAlbum:albumName completionBlock:^(NSURL *assetURL, NSError *error) {
            if (completionBlock != nil) {
                completionBlock(assetURL, nil);
            }
        } failureBlock:^(NSError *error) {
            if (failureBlock != nil) {
                failureBlock(error);
            }
        }];
    }];
}

+ (void)addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)albumName completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock
{
    [[ALAssetsLibrary sharedInstance] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        [self addAsset:asset toAlbum:albumName completionBlock:^(BOOL finished) {
            if (completionBlock != nil) {
                completionBlock(assetURL, nil);
            }
        } failureBlock:^(NSError *error) {
            if (failureBlock != nil) {
                failureBlock(error);
            }
        }];
    } failureBlock:^(NSError *error) {
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

+ (void)addAsset:(ALAsset *)asset toAlbum:(NSString *)albumName completionBlock:(void (^)(BOOL finished))completion failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock
{
    __block BOOL albumWasFound = NO;
    
    // search all photo albums in the library
    [[ALAssetsLibrary sharedInstance] enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([albumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
            albumWasFound = YES;
            [group addAsset:asset];
            if (completion != nil) {
                completion(YES);
            }
            return;
        }
        if (group == nil && albumWasFound == NO){
            [[ALAssetsLibrary sharedInstance] addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
                [group addAsset:asset];
                if (completion != nil) {
                    completion(YES);
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock != nil) {
                    failureBlock(error);
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

+ (void)writeImage:(NSData *)imageData
   ToGroupWithName:(NSString *)groupName
           success:(successHandler)successHandler
           failure:(failureHandler)failureHandler {
    if (!imageData || !groupName) {
        return;
    }
    
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    __block ALAssetsGroup *groupToWrite;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:groupName]) {
            NSLog(@"assetsGroup been found %@", groupName);
            groupToWrite = group;
            
            [library writeImageDataToSavedPhotosAlbum:imageData metadata:@{} completionBlock:^(NSURL *assetURL, NSError *error) {
                [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    [groupToWrite addAsset:asset];
                    NSLog(@"asset be added to %@ ",groupName);
                    
                } failureBlock:^(NSError *error) {
                    NSLog(@"failed to add asset to %@ ", groupName);
                }];
            }];
            return ;
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"failed to enumerate alblums:n\Error: %@", [error localizedDescription]);
    }];
}


+ (void)writeImageToSavedPhotoAlbum:(CIImage *)image
                            success:(successHandler)successHandler
                            failure:(failureHandler)failureHandler {
    CIContext *context = [CIContext contextWithOptions:@{ kCIContextUseSoftwareRenderer: @(YES)}];
    CGImageRef imageRef = [context createCGImage:image fromRect:[image extent]];

    [[ALAssetsLibrary sharedInstance] writeImageToSavedPhotosAlbum:imageRef
                                                          metadata:[image properties]
                                                   completionBlock:^(NSURL *assetURL, NSError *error) {
                                                       CGImageRelease(imageRef);
                                                       if (error.code == 0) {
                                                           NSLog(@"AssetURL: %@ ", assetURL);
                                  
                                  
                                                       }
    }];
    
}

+ (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)canUserPickPhotosFromPhotoLibrary
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    if (sourceImage.size.width < ScreenWidth) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ScreenWidth;
        btWidth = sourceImage.size.width * (ScreenWidth / sourceImage.size.height);
    } else {
        btWidth = ScreenWidth;
        btHeight = sourceImage.size.height * (ScreenWidth / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
            scaledWidth  = width * scaleFactor;
            scaledHeight = height * scaleFactor;
        }
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.9;
        } else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.9;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
