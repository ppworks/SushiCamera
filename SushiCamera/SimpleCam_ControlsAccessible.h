//
//  SimpleCam_ControlsAccessible.h
//  SushiCamera
//
//  Created by koshikawa on 2014/07/16.
//  Copyright (c) 2014年 ppworks. All rights reserved.
//

#import "SimpleCam.h"

@interface SimpleCam ()
@property (strong, nonatomic) UIButton * backBtn;
@property (strong, nonatomic) UIButton * captureBtn;
@property (strong, nonatomic) UIButton * flashBtn;
@property (strong, nonatomic) UIButton * switchCameraBtn;
@property (strong, nonatomic) UIButton * saveBtn;
- (void)drawControls;
@end
