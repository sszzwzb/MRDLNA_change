//
//  RecordSightViewController.h
//  VideoRecord
//
//  Created by CheungStephen on 4/12/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "RecordSightStartButton.h"
#import "ShowSightViewController.h"
#import "SightPlayerViewController.h"
#import "SightPlayer.h"

@interface RecordSightViewController : UIViewController<AVCaptureFileOutputRecordingDelegate, UIGestureRecognizerDelegate>

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

@property (assign,nonatomic) float preLayerWidth;//镜头宽
@property (assign,nonatomic) float preLayerHeight;//镜头高
@property (assign,nonatomic) float preLayerHWRate; //高，宽比

@property (strong,nonatomic) UIView* progressPreView; //进度条
@property (strong,nonatomic) NSTimer *countTimer; //计时器
@property (assign,nonatomic) float progressStep; //进度条每次变长的最小单位
@property (assign,nonatomic) float totalTime; //视频总长度 默认10秒
@property (assign,nonatomic) float currentTime; //当前视频长度

@property (strong,nonatomic) RecordSightStartButton *startButton;
@property (strong,nonatomic) UILabel *tipsLabel;
@property (assign,nonatomic) BOOL isCancel;


@end
