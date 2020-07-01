//
//  Camera360SDK.h
//  MicroSchool
//
//  Created by CheungStephen on 22/10/2016.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CameraInfoModel;

@interface Camera360SDK : NSObject

// 初始化Camera的信息
- (void)initCameraInfo;

@property(nonatomic, retain) CameraInfoModel *cameraInfo;

@end
