//
//  FullImageViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import "FullImageCell.h"

@protocol FullImageViewControllerDelegate<NSObject>//2016.02.02

@optional
-(void)getDeleteIndex:(NSString*)currentIndex;
@end

@interface FullImageViewController : BaseViewController <UIActionSheetDelegate,UIGestureRecognizerDelegate>{
    
    CGFloat maxHeight;
    CGFloat maxWidth;
    id<FullImageViewControllerDelegate> delegate;

}

@property (strong, nonatomic) NSMutableArray *assetsArray;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign,nonatomic)  BOOL isShowNavigationBar;

@property (strong, nonatomic) NSMutableArray *imageArray;

// health 从身体记录进入
@property (strong, nonatomic) NSString *viewType;

//代理
@property (nonatomic, assign) id<FullImageViewControllerDelegate> delegate;//2016.02.02

@end
