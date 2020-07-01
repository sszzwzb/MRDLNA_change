//
//  RecipeUploadViewController.h
//  MicroSchool
//
//  Created by CheungStephen on 3/23/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "BaseViewController.h"

#import "AddImagesTool.h"

@interface RecipeUploadViewController : BaseViewController<UIScrollViewDelegate, UIImagePickerControllerDelegate, HttpReqCallbackDelegate>

-(void)updateSize:(UIView*)view;

@property(nonatomic,retain) NetworkUtility *networkUtility;

@property(nonatomic,retain) NSString *titleName;
@property(nonatomic,retain) NSDictionary *recipeDic;

@property (nonatomic, retain) UIImageView *iconImageView;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *contentLabel;

@property (nonatomic, retain) UIScrollView *scrollerView;
@property (nonatomic, retain) UIView *viewWhiteBg;

@property (nonatomic, retain) UIView *contentWhiteBGView;
@property (nonatomic, retain) UIView *imageWhiteBGView;

@property (nonatomic, retain) AddImagesTool *imageTool;
@property (nonatomic,strong) NSMutableDictionary *imageArray;

@property (nonatomic, retain) NSString *qngs;

@end
