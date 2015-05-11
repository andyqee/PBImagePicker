//
//  PBAssetsDefine.h
//  PhotoBook
//
//  Created by andy on 8/4/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#ifndef PhotoBook_PBAssetsDefine_h
#define PhotoBook_PBAssetsDefine_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PBAssetImageResolution) {
    
    kPBAssetImageResolutionThumbnail,
    
    kPBAssetImageResolutionAspectRatioThumbnail,
    
    kPBAssetImageResolutionFullscreen,
    
    kPBAssetImageResolutionFullsize
};

//定义屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//定义屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//定义颜色
#define Color(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#endif

