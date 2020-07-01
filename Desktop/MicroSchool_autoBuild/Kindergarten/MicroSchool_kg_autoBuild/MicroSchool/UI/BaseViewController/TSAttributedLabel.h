//
//  TSAttributedLabel.h
//  MicroSchool
//
//  Created by jojo on 15/9/21.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <MLLabel/MLLinkLabel.h>
#import <MLLabel/NSString+MLExpression.h>
#import <MLLabel/NSAttributedString+MLExpression.h>

@protocol TSAttributedLabelDelegate<NSObject>//add 2015.12.14 新增代理 kate

@optional
-(void)clickLabel:(NSDictionary*)dic;
-(void)clickName:(NSDictionary*)dic;
@end

@interface TSAttributedLabel : MLLinkLabel

// 传入的参数字典
@property(nonatomic, retain) NSDictionary *infoDic;

// 如果是简单的参数，则用NSString
@property(nonatomic, retain) NSString *infoStr;

// 点击的类型
@property(nonatomic, retain) NSString *touchType;

// 是否带阴影
//@property(nonatomic, retain) NSString *isShowShadow;

@property(nonatomic, assign) int name1Start;
@property(nonatomic, assign) int name1End;
@property(nonatomic, assign) int hasName1;
@property(nonatomic, retain) UIImageView *imgViewName1;
@property(nonatomic, retain) NSString *name1Uid;

@property(nonatomic, assign) int name2Start;
@property(nonatomic, assign) int name2End;
@property(nonatomic, assign) int name2Size;
@property(nonatomic, assign) int hasName2;
@property(nonatomic, retain) UIImageView *imgViewName2;
@property(nonatomic, retain) NSString *name2Uid;

@property(nonatomic, assign) int msgWidth;
@property(nonatomic, assign) int msgHeight;
@property(nonatomic, retain) UIImageView *imgViewMsg;
@property(nonatomic, retain) NSString *msgPid;
@property(nonatomic, retain) NSString *msgUid;
@property(nonatomic, retain) NSString *msgPos;
@property(nonatomic, retain) NSString *msgTid;

@property(nonatomic, retain) NSString *cellNum;

@property(nonatomic, retain) NSString *msgComment;

@property(nonatomic, retain) NSString *isShowShadow;

//代理
@property (nonatomic, assign) id<TSAttributedLabelDelegate> delegate_TS;//2015.12.14 kate
@property (nonatomic, assign) int nameY;//y坐标用于判断点击名字事件 2015.12.15 kate

@end
