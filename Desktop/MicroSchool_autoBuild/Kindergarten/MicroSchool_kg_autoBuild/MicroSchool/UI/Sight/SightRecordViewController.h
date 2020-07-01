//
//  SightRecordViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 4/14/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

#import "RecordSightStartButton.h"
#import "ShowSightViewController.h"
#import "SightPlayerViewController.h"
#import "SightPlayer.h"

#import "PublishMomentsViewController.h"

@interface SightRecordViewController : BaseViewController<AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate>

//负责输入和输出设置之间的数据传递
@property (strong,nonatomic) AVCaptureSession *captureSession;

//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;

//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;

//相机拍摄预览图层
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

//视频容器
@property (strong,nonatomic) UIView *viewContainer;

@property (assign,nonatomic) float preLayerWidth;
@property (assign,nonatomic) float preLayerHeight;
@property (assign,nonatomic) float preLayerHWRate;

@property (strong,nonatomic) UIView* progressPreView;
@property (strong,nonatomic) NSTimer *countTimer;
@property (assign,nonatomic) float progressStep;
@property (assign,nonatomic) float totalTime;
@property (assign,nonatomic) float currentTime;

@property (strong,nonatomic) RecordSightStartButton *startButton;
@property (strong,nonatomic) UILabel *tipsLabel;
@property (assign,nonatomic) BOOL isCancel;

@property (strong,nonatomic) UIImageView *aaa;
@property (strong,nonatomic) NSString *cid;
@property (strong,nonatomic) NSString *fromName;

@end
