//
//  HomeworkDetailInfo.h
//  MicroSchool
//
//  Created by CheungStephen on 1/29/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

// 作业详情的文字说明与图片展示

#import <UIKit/UIKit.h>

#import "TSImageSelectView.h"

@class HomeworkDetailInfo;

// 代理方法
@protocol HomeworkDetailInfoDelegate <NSObject>

// 返回动态显示的高度
-(void)homeworkDetailInfo:(HomeworkDetailInfo *)v height:(NSInteger)h;

// 点击图片的index
-(void)homeworkDetailInfoSelectedImage:(HomeworkDetailInfo *)v index:(NSInteger)index;

@end

@interface HomeworkDetailInfo : UIView <TSImageSelectViewSelectDelegate>

@property (nonatomic, assign) id<HomeworkDetailInfoDelegate> delegate;

@property (nonatomic, assign) NSInteger headHeight;
@property (nonatomic, retain) NSString *contentHeight;

@property (nonatomic, retain) NSMutableDictionary *dicInfo;

// 答案标题
@property (nonatomic, retain) UILabel *labelAnswerTitle;

// 内容
@property (nonatomic, retain) UILabel *labelContent;

// 图片选择
@property (retain, nonatomic) TSImageSelectView *imageSelectView;

- (void)initElementsWithDic:(NSDictionary *)dic showTitle:(NSString *)title;

@end
