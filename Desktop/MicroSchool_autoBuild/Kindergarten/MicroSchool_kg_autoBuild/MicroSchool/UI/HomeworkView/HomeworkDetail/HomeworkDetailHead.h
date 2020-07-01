//
//  HomeworkDetailHead.h
//  MicroSchool
//
//  Created by CheungStephen on 1/29/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

// 作业详情最上面的基本信息

#import <UIKit/UIKit.h>

#import "Masonry.h"
#import "Utilities.h"
#import "UIImageView+WebCache.h"

@class HomeworkDetailHead;

// 代理方法
@protocol HomeworkDetailHeadDelegate <NSObject>

// 返回动态显示的高度
-(void)homeworkDetailHead:(HomeworkDetailHead *)v height:(NSInteger)h;

@end

@interface HomeworkDetailHead : UIView

@property (nonatomic, assign) id<HomeworkDetailHeadDelegate> delegate;

@property (nonatomic, assign) NSInteger headHeight;

// 标题
@property (nonatomic, retain) UILabel *labelSubject;

// 头像
@property (nonatomic, retain) UIImageView *imageViewHead;

// 姓名
@property (nonatomic, retain) UILabel *labelUsername;

// 时间
@property (nonatomic, retain) UILabel *labelDateline;

// 预计完成时间
@property (nonatomic, retain) UILabel *labelExpectedtime;
@property (nonatomic, retain) UILabel *labelTime;

- (void)initElementsWithDic:(NSDictionary *)dic;

@end
