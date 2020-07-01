//
//  HomeworkDetailUploadViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 2/8/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "AddImagesTool.h"
#import "HomeworkDetailViewController.h"

@interface HomeworkDetailUploadViewController : BaseViewController <UIImagePickerControllerDelegate, HttpReqCallbackDelegate>

-(void)updateSize:(UIView*)view;

@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *tid;

@property (nonatomic, retain) AddImagesTool *imageToolForHomework;

@property (nonatomic,strong) NSMutableDictionary *imageArray;

@property (nonatomic, retain) NSString *qngs;//删除作业内容图片id

@end
