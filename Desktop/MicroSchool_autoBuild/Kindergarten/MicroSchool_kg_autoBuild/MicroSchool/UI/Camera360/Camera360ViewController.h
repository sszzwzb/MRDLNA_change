//
//  Camera360ViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 24/10/2016.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"
#import "Camera360View.h"

#if DEVICE_IPHONE
@class QHCamBaseInfo;
#endif

@class CameraInfoModel;

@interface Camera360ViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate,Camera360ViewDelegate>

@property(nonatomic,strong) NSString *cId;
@property(nonatomic,strong) NSString *titleName;

// 班级入口时，是否为班级管理员
@property (assign, nonatomic) BOOL isAdmin;

// 可用摄像头的index的列表
@property(nonatomic,retain) NSMutableArray *cameraOpenIndexArray;

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *dataArr;

#if DEVICE_IPHONE

// 上下右方灰色条
@property(nonatomic,strong) UIView *topDarkGreyView;
@property(nonatomic,strong) UIView *bottomDarkGreyView;
@property(nonatomic,strong) UIView *rightDarkGreyView;

@property(nonatomic,assign) BOOL showDarkGreyView;

@property(nonatomic,strong) UILabel *cameraErrorLabel;
@property(nonatomic,strong) UIButton *cameraErrorButton;

// 当前时间的显示
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) UILabel *currentTime;

// 下方灰色条上的button
@property(nonatomic,strong) UIButton *previousButton;
@property(nonatomic,strong) UIButton *nextButton;
@property(nonatomic,strong) UIButton *switchCameraButton;

@property(nonatomic, strong) QHCamBaseInfo *camInfo;
@property(nonatomic, strong) CameraInfoModel *camera360Model;

@property(nonatomic, strong) UILabel *titleLabel;

// 当前选择的摄像头
@property(nonatomic, assign) NSInteger selectCameraIndex;
@property(nonatomic, strong) Camera360View *maskView;

#endif

@end
