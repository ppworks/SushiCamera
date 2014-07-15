//
//  SushiCamera.m
//  SushiCamera
//
//  Created by koshikawa on 2014/07/16.
//  Copyright (c) 2014年 ppworks. All rights reserved.
//

#import "SushiCamera.h"

@interface SushiCamera ()
@property (nonatomic) UIButton *creditButton;

@end

@implementation SushiCamera

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hideBackButton = YES;
        self.controlAnimateDuration = 0.0;
        self.disablePhotoPreview = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawControls
{
    [super drawControls];
    [self setupCreditButton];
}

- (void)setupCreditButton
{
    self.creditButton = nil;
    self.creditButton = [[UIButton alloc] init];
    [self.creditButton setImage:[UIImage imageNamed: @"sushiyuki_27"] forState:UIControlStateNormal];
    
    self.creditButton.bounds = CGRectMake(0, 0, 40, 40);
    self.creditButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.creditButton.alpha = 0.6;
    
    self.creditButton.layer.shouldRasterize = YES;
    self.creditButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.creditButton.layer.cornerRadius = 4;
    
    self.creditButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.creditButton.layer.borderWidth = 0.5;
    
    
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.creditButton.center = CGPointMake(30, self.captureBtn.center.y);
        //self.creditButton.center = CGPointMake(30, self.view.bounds.size.height - 28);
    } else {
        self.creditButton.center = CGPointMake(self.captureBtn.center.x, 30);
    }
    [self.view addSubview:self.creditButton];
}

@end
