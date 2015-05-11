//
//  PBAlbumPikerTableViewCell.m
//  PhotoBook
//
//  Created by andy on 25/1/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "PBAlbumPikerTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PBAlbumPikerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configureCell:(ALAssetsGroup *)assetsGroup {
    
    UIImage *image = [UIImage imageWithCGImage:[assetsGroup posterImage]];
    self.imageView.image = image;
    self.textLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%ld,", [assetsGroup numberOfAssets] ];
}


@end
