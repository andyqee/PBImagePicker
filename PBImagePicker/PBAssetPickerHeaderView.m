//
//  PBAssetPickerHeaderView.m
//  PhotoBook
//
//  Created by andy on 26/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAssetPickerHeaderView.h"
#import "PhotoBook_Util.h"
#import "UIView+Position.h"

@implementation PBAssetPickerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) {
        return self;
    }
    [self _initSubviews];
    return self;
}

- (void)_initSubviews
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(60, 0, ScreenWidth - 120 , self.frameHeight);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel = titleLabel;
    [self addSubview:self.titleLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 44, self.frameHeight);
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)buttonAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didClickLeftBackButton:)]) {
        [_delegate didClickLeftBackButton:self];
    }
}

@end
