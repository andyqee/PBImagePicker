//
//  ViewController.m
//  PBImagePicker
//
//  Created by andy on 10/5/15.
//  Copyright (c) 2015 andy. All rights reserved.
//

#import "ViewController.h"
#import "PBSelectViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *presentImagePicker;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat width = CGRectGetWidth( self.view.frame );
    self.presentImagePicker.frame = (CGRect){ {0, 200}, {width, 30} };
    [self.presentImagePicker addTarget:self
                                action:@selector(buttonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [self.presentImagePicker setTitle:@"Present Image Picker" forState:UIControlStateNormal];
    [self.presentImagePicker.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
}

- (void)buttonAction:(id)sender
{
    PBSelectViewController *vc = [PBSelectViewController new];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
