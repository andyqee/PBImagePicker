//
//  PBAssetLibraryUtil.h
//  PhotoBook
//
//  Created by andy on 3/3/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <UIKit/UIKit.h>

@class CIImage;

typedef void(^successHandler)();
typedef void(^failureHandler)();

@interface PBAssetLibraryUtil : NSObject

+ (void)addImage:(UIImage *)image
        metaData:(NSDictionary *)metaData
         toAlbum:(NSString *)albumName
 completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock
    failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock;

+ (void)addImage:(UIImage *)image
     orientation:(ALAssetOrientation)orientation
         toAlbum:(NSString *)albumName
 completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock
    failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock;

+ (void)addImage:(UIImage *)image toAlbum:(NSString *)albumName completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock;
+ (void)addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)albumName completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock;
+ (void)addAsset:(ALAsset *)asset toAlbum:(NSString *)albumName completionBlock:(void (^)(BOOL finished))completion failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock;


+ (BOOL)isCameraAvailable;

+ (BOOL)isRearCameraAvailable;

+ (BOOL)isFrontCameraAvailable;

+ (BOOL)doesCameraSupportTakingPhotos;

+ (BOOL)isPhotoLibraryAvailable;

+ (BOOL)canUserPickPhotosFromPhotoLibrary;

+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

@end
