//
//  ViewController.m
//  SushiCamera
//
//  Created by koshikawa on 2014/07/15.
//  Copyright (c) 2014年 ppworks. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import <UIKit/UIKit.h>
#import "SushiCamera.h"

@interface ViewController () <SimpleCamDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
- (IBAction)touchYes:(id)sender;
- (IBAction)touchNo:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self reset];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self openCameraWithoutSegue];
    if (!self.previewImageView.image) {
        [self showCamera];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    if (self.previewImageView.image) {
        self.yesButton.hidden = NO;
        self.noButton.hidden = NO;
    }
}

- (void)showCamera
{
    SushiCamera * simpleCam = [[SushiCamera alloc]init];
    simpleCam.delegate = self;
    [self presentViewController:simpleCam animated:NO completion:nil];
}

- (IBAction)touchNo:(id)sender {
    [self reset];
    [self showCamera];
}

- (IBAction)touchYes:(id)sender
{
    NSLog(@"touchYes");
    UIImageWriteToSavedPhotosAlbum(self.previewImageView.image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
}

- (void) savingImageIsFinished:(UIImage *)_image
      didFinishSavingWithError:(NSError *)_error
                   contextInfo:(void *)_contextInfo
{
    [self reset];
    [self showCamera];
}

- (void)reset
{
    NSLog(@"reset");
    self.previewImageView.image = nil;
    self.yesButton.hidden = YES;
    self.noButton.hidden = YES;
}

#pragma mark SIMPLE CAM DELEGATE

- (void)simpleCam:(SimpleCam *)simpleCam didFinishWithImage:(UIImage *)image {
    
    if (image) {
        NSArray *sushiCandidates = @[@"sushiyuki_18", @"sushiyuki_19", @"sarayuki_akami"];
        NSString *sushi = sushiCandidates[arc4random_uniform((int)sushiCandidates.count)];
        UIImage *sushiImage = [UIImage imageNamed:sushi];
        
        
        //UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height), NO, 0.0);
        [sushiImage drawInRect:CGRectMake(arc4random_uniform(image.size.width - 50), arc4random_uniform(image.size.height - 50), 50, 50)];
        sushiImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        GPUImagePicture* picture1 = [[GPUImagePicture alloc] initWithImage:image];
        GPUImagePicture* picture2 = [[GPUImagePicture alloc] initWithImage:sushiImage];
        GPUImageNormalBlendFilter* filter = [[GPUImageNormalBlendFilter alloc] init];
        [filter useNextFrameForImageCapture];
        [picture1 addTarget:filter];
        [picture1 processImage];
        [picture2 addTarget:filter];
        [picture2 processImage];
        
        // フィルター適応後の画像を表示
        UIImage* outputImage = [filter imageFromCurrentFramebufferWithOrientation:image.imageOrientation];
        self.previewImageView.image = outputImage;
    }
    else {
        // simple cam finished w/o image
    }
    
    // Close simpleCam - use this as opposed to dismissViewController: to properly end photo session
    [simpleCam closeWithCompletion:^{
        NSLog(@"SimpleCam is done closing ... ");
        // It is safe to launch other ViewControllers, for instance, an editor here.
    }];
}

- (void) simpleCamDidLoadCameraIntoView:(SimpleCam *)simpleCam {
    NSLog(@"Camera loaded ... ");
}
@end
