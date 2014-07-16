//
//  SushiCamera.m
//  SushiCamera
//
//  Created by koshikawa on 2014/07/16.
//  Copyright (c) 2014年 ppworks. All rights reserved.
//

#import "SushiCamera.h"

@interface SushiCamera ()<UIWebViewDelegate>
@property (nonatomic) UIButton *creditButton;
@property (nonatomic) UIWebView *creditView;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupCredit];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.creditView.hidden) {
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(capturePhoto) userInfo:nil repeats:NO];
    } else {
        self.creditView.hidden = YES;
    }
}

- (void)drawControls
{
    [super drawControls];
    [self changeCreditPosition];
}

- (void)setupCredit
{
    self.creditButton = [[UIButton alloc] init];
    [self.creditButton addTarget:self action:@selector(touchedCreditButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.creditButton setImage:[UIImage imageNamed: @"sushiyuki_27"] forState:UIControlStateNormal];
    
    self.creditButton.bounds = CGRectMake(0, 0, 40, 40);
    self.creditButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];

    self.creditButton.layer.shouldRasterize = YES;
    self.creditButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.creditButton.layer.cornerRadius = 4;
    
    self.creditButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.creditButton.layer.borderWidth = 0.5;
    [self.view addSubview:self.creditButton];
    
    self.creditView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.creditView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.creditView.opaque = NO;
    self.creditView.hidden = YES;
    self.creditView.delegate = self;
    [self.view addSubview:self.creditView];
    
    [self changeCreditPosition];
}

- (void)changeCreditPosition
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.creditButton.center = CGPointMake(30, self.captureBtn.center.y);
    } else {
        self.creditButton.center = CGPointMake(self.captureBtn.center.x, 30);
    }
    self.creditView.center = self.view.center;
}

- (void)touchedCreditButton:(id)sender
{
    if (self.creditView.hidden) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"credit" ofType:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [self.creditView loadRequest:request];
        self.creditView.hidden = NO;
    } else {
        self.creditView.hidden = YES;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (UIWebViewNavigationTypeLinkClicked == navigationType) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

@end
