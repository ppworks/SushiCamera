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
#import "SimpleCam.h"


@interface ViewController () <SimpleCamDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self openCameraWithoutSegue];
    
    SimpleCam * simpleCam = [[SimpleCam alloc]init];
    simpleCam.delegate = self;
    [simpleCam setDisablePhotoPreview:YES];
    [self presentViewController:simpleCam animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SIMPLE CAM DELEGATE

- (void) simpleCam:(SimpleCam *)simpleCam didFinishWithImage:(UIImage *)image {
    
    if (image) {
        // simple cam finished with image
        UIImage *sushiImage = [UIImage imageNamed:@"sarayuki_akami"];
        
        
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
        
        UIImageWriteToSavedPhotosAlbum(outputImage, nil, nil, nil);
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
